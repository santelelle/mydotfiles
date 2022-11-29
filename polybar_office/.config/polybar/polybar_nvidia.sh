#!/bin/bash
export BAR=██████████
# export BAR_UNUSED=░░░░░░░░░░
export BAR_UNUSED=██████████
# for usage in $(nvidia-smi --query-gpu=gpu_name,memory.used,memory.total --format=csv,noheader,nounits | awk -F ',' '{printf "%.0f", ""$2/$3*100/10""} {print ""}'); do
#    echo -e "${BAR:0:$usage}${BAR_UNUSED:$usage:10}"
# done | awk '{printf $1 "  "}'
nvidia-smi --query-gpu=gpu_name,memory.used,memory.total --format=csv,noheader,nounits | awk -F ',' '{printf "%.0f\n", ""$2/$3*100/10""}' | awk -F ' ' -v bar="$BAR" -v bar_unused="$BAR_UNUSED" '{printf "%{F#98971a}%.*s%{F#7c6f64}%.*s ", $1, bar, ""10-$1"", bar_unused}'
