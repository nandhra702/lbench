#!/bin/bash

set -e

INPUT=50000000
OUTFILE="timings.txt"
> "$OUTFILE"  # Clear or create the file

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

    # Sum for average
    lang_times[$LANG]=$(echo "${lang_times[$LANG]:-0} + $DURATION" | bc)
    lang_counts[$LANG]=$(( ${lang_counts[$LANG]:-0} + 1 ))

    # Best time tracker
    if [[ -z "${lang_best_times[$LANG]}" || 1 -eq "$(echo "$DURATION < ${lang_best_times[$LANG]}" | bc)" ]]; then
        lang_best_times[$LANG]=$DURATION
        lang_best_names[$LANG]=$NAME
    fi
}

# --- C Programs ---
gcc -O2 -mavx bench_c.c -o bench_c -lm
run_and_time "bench_c.c" "./bench_c $INPUT" "C"

gcc -O2 -mavx benchc_2.c -o benchc_2 -lm
run_and_time "benchc_2.c" "./benchc_2 $INPUT" "C"

gcc -O2 -mavx benchc_3.c -o benchc_3 -lm
run_and_time "benchc_3.c" "./benchc_3 $INPUT" "C"

# --- Rust Projects ---
for folder in rust_build1 rust_build2 rust_build3; do
    echo "Building $folder ..."
    (cd "$folder" && cargo build --release)

    BIN="./$folder/target/release/$folder"
    run_and_time "$folder" "$BIN $INPUT" "Rust"
done

# --- C++ Programs ---
g++ bench_cpp1.cpp -o bench_cpp1 -O2
run_and_time "bench_cpp1.cpp" "./bench_cpp1 $INPUT" "C++"

g++ bench_cpp2.cpp -o bench_cpp2 -O2 -msse3
run_and_time "bench_cpp2.cpp" "./bench_cpp2 $INPUT" "C++"

# --- Go Programs ---
run_and_time "Gobench1.go" "go run Gobench1.go $INPUT" "Go"
run_and_time "Gobench2.go" "go run Gobench2.go $INPUT" "Go"
run_and_time "Gobench3.go" "go run Gobench3.go $INPUT" "Go"

# --- OCaml ---
ocamlopt -o ocamelbench ocamelbench.ml
run_and_time "ocamelbench.ml" "./ocamelbench $INPUT" "OCaml"

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
