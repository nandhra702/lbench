#!/bin/bash

set -e

INPUT=16000
OUTFILE="timing_results.txt"
> "$OUTFILE"  # Reset file

declare -A lang_times
declare -A lang_counts
declare -A lang_best_times
declare -A lang_best_names

run_and_time() {
    NAME=$1
    CMD=$2
    LANG=$3

    echo "Running $NAME ..."
    START=$(date +%s.%N)
    eval "$CMD" > /dev/null
    END=$(date +%s.%N)

    DURATION=$(echo "$END - $START" | bc)
    printf "%s: %.2f seconds\n" "$NAME" "$DURATION" | tee -a "$OUTFILE"

    lang_times[$LANG]=$(echo "${lang_times[$LANG]:-0} + $DURATION" | bc)
    lang_counts[$LANG]=$(( ${lang_counts[$LANG]:-0} + 1 ))

    if [[ -z "${lang_best_times[$LANG]}" || 1 -eq "$(echo "$DURATION < ${lang_best_times[$LANG]}" | bc)" ]]; then
        lang_best_times[$LANG]=$DURATION
        lang_best_names[$LANG]=$NAME
    fi
}

# --- C ---
gcc -O3 -fopenmp bench2.c -o bench2
run_and_time "bench2.c" "./bench2 $INPUT" "C"

gcc -O3 -pthread benchc.c -o benchc
run_and_time "benchc.c" "./benchc $INPUT" "C"

# --- Rust ---
for folder in rustbench rustbench2; do
    echo "Building $folder ..."
    (cd "/home/sukhraj/lbench/my_source/mandelbrot/$folder" && cargo build --release)

    BIN="/home/sukhraj/lbench/my_source/mandelbrot/$folder/target/release/$folder"
    run_and_time "$folder" "$BIN $INPUT" "Rust"
done

# --- C++ ---
g++ -O3 -fopenmp benchcpp.cpp -o benchcpp
run_and_time "benchcpp.cpp" "./benchcpp $INPUT" "C++"

g++ -O3 -fopenmp benchcpp2.cpp -o benchcpp2
run_and_time "benchcpp2.cpp" "./benchcpp2 $INPUT" "C++"

# --- Go ---
go build -o gobench gobench.go
run_and_time "gobench.go" "./gobench $INPUT" "Go"

go build -o gobench2 gobench2.go
run_and_time "gobench2.go" "./gobench2 $INPUT" "Go"

# --- Python ---
run_and_time "pythonbench.py" "python3 pythonbench.py $INPUT" "Python"



# --- Summary ---
{
    echo ""
    echo "--- Summary by Language ---"
    for lang in "${!lang_times[@]}"; do
        avg=$(echo "${lang_times[$lang]} / ${lang_counts[$lang]}" | bc -l)
        printf "%s:\n  Total Time: %.2f s\n  Average Time: %.2f s\n  Best Time: %.2f s (%s)\n" \
            "$lang" "${lang_times[$lang]}" "$avg" "${lang_best_times[$lang]}" "${lang_best_names[$lang]}"
    done
} >> "$OUTFILE"

echo -e "\n✅ All timings written to $OUTFILE"
