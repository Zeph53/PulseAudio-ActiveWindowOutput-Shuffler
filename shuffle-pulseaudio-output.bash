#!/bin/bash

# Get the active process ID
ACTIVE_PROC_ID=$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) _NET_WM_PID | cut -d ' ' -f 3)
# Get the active index ID
ACTIVE_INDEX_ID=$(pacmd list-sink-inputs | awk -v pid="$ACTIVE_PROC_ID" '/index:/{idx=$2} $1=="application.process.id" && $3=="\""pid"\""{print idx}')
# Get sink in use by active window
ACTIVE_SINK_ID=$(pacmd list-sink-inputs | awk -v active_idx="$ACTIVE_INDEX_ID" '$1 == "index:" {idx = $2} $1 == "sink:" && idx == active_idx {printf "%s", $2}')
# Get available sink IDs
AVAIL_SINK_IDS=$(pacmd list-cards | awk '/index:/{printf "%s ",$NF}')

# Count the number of available sinks
NUM_SINKS=$(echo "$AVAIL_SINK_IDS" | wc -w)

# If only one sink available, exit without switching
if [ "$NUM_SINKS" -eq 1 ]; then
    exit 0
fi

# Find the index of the current sink ID in the available sinks array
current_index=0
for sink_id in $AVAIL_SINK_IDS; do
    if [ "$sink_id" == "$ACTIVE_SINK_ID" ]; then
        break
    fi
    ((current_index++))
done

# Get the next available sink ID that is not in use by the active window
while :; do
    ((current_index++))
    next_index=$((current_index % NUM_SINKS + 1))
    NEXT_SINK_ID=$(echo "$AVAIL_SINK_IDS" | awk -v idx="$next_index" '{print $idx}')

    if [ "$NEXT_SINK_ID" != "$ACTIVE_SINK_ID" ]; then
        break
    fi
done

# Change the active sink to the next available sink ID
pacmd move-sink-input "$ACTIVE_INDEX_ID" "$NEXT_SINK_ID"
exit 0
