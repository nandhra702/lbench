#!/bin/bash

# Output file
output_file="execution_report.txt"
: > "$output_file"

declare -A lang_times
declare -A lang_best

log_time() {
    local lang=$1
    local prog=$2
    local path=$3

    if [[ ! -x "$path" ]]; then
        echo "$lang/$prog: Not executable or missing" | tee -a "$output_file"
        return
    fi

    for i in {1..5}; do
        time_output=$( ( /usr/bin/time -f "%e" "$path" 21 > /dev/null ) 2>&1 )
        exit_code=$?

        if [[ $exit_code -ne 0 ]]; then
            echo "$lang/$prog: Run #$i Crashed (exit code $exit_code)" | tee -a "$output_file"
            continue
        fi

        echo "$lang/$prog: Run #$i: $time_output seconds" | tee -a "$output_file"
        lang_times["$lang"]+="$time_output "
        if [[ -z ${lang_best[$lang]} || $(echo "$time_output < ${lang_best[$lang]}" | bc) -eq 1 ]]; then
            lang_best["$lang"]=$time_output
        fi
    done
}

# Benchmark definitions
declare -a programs=(
    "C bs1c ./c/bs1c"
    "C bs2c ./c/bs2c"
    "C++ bs1cpp ./cpp/bs1cpp"
    "C++ bs2cpp ./cpp/bs2cpp"
    "Go bs1 ./go/bs1"
    "Go bs2 ./go/bs2"
    "Rust bs1 ./rust/bs1/target/release/bs1"
    "Rust bs2 ./rust/bs2/target/release/bs2"
    "Zig bs2 ./zig/bs2/zig-out/bin/bs1"
)

# Run benchmarks
for entry in "${programs[@]}"; do
    log_time $entry
done

# Process results
echo -e "\n=== Averages and Best Times ===" | tee -a "$output_file"
declare -A lang_avg
for lang in "${!lang_times[@]}"; do
    times=(${lang_times[$lang]})
    total=0
    for t in "${times[@]}"; do
        total=$(echo "$total + $t" | bc)
    done
    avg=$(echo "scale=4; $total / ${#times[@]}" | bc)
    lang_avg[$lang]=$avg
    echo "$lang: Avg=${avg}s, Best=${lang_best[$lang]}s" | tee -a "$output_file"
done

# Sort by average time
echo -e "\n=== Ranking by Average Time (Fastest to Slowest) ===" | tee -a "$output_file"
for lang in $(for k in "${!lang_avg[@]}"; do echo "$k ${lang_avg[$k]}"; done | sort -k2 -n | awk '{print $1}'); do
    echo "$lang: ${lang_avg[$lang]}s" | tee -a "$output_file"
done
