#!/bin/bash
# Gateway failure injection - simulates network partition

show_help() {
  cat <<EOF
Gateway Failure Injection

Usage: $0 [gateway_num] [duration] [container_name]

Arguments:
  gateway_num     1 or 2 (default: 1)
  duration        Seconds (default: 30)
  container_name  Override container (default: otelbench-otelcol-gateway-N)

Examples:
  $0           # Fail gateway-1 for 30s
  $0 2 60      # Fail gateway-2 for 60s
EOF
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  show_help
  exit 0
fi

GATEWAY_NUM=${1:-1}
DURATION=${2:-30}
CONTAINER=${3:-"otelbench-otelcol-gateway-${GATEWAY_NUM}"}

echo "Disconnecting $CONTAINER from network for ${DURATION}s..."
podman network disconnect otelbench_bench-net "$CONTAINER"
sleep "$DURATION"
podman network connect otelbench_bench-net "$CONTAINER"
echo "Restored $CONTAINER to network"
