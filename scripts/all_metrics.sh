#!/bin/bash

# Output file
OUTPUT_FILE="output/all_metrics"

# Get all metric names
metric_names=$(curl -s 'http://localhost:8428/api/v1/label/__name__/values' | jq -r '.data[]')

# Create output directory if it doesn't exist
mkdir -p output

# Clear output file
>"$OUTPUT_FILE"

# For each metric name, get all its time series with labels
for metric in $metric_names; do
  curl -s "http://localhost:8428/api/v1/series?match[]=${metric}" |
    jq -r '.data[] | "\(.__name__) \(. | to_entries | map(select(.key != "__name__") | "\(.key)=\"\(.value)\"") | join(" "))"' >>"$OUTPUT_FILE"
done

echo "Metrics written to $OUTPUT_FILE"
