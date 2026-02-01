# otelbench

A pluggable testbench for developing and validating OpenTelemetry Collector observability pipeline configurations.

## Overview

otelbench orchestrates a complete observability stack using Podman Compose to enable OTel Collector configuration development with controlled, coherent synthetic telemetry.

**Components:**

- **otelbox** - Generates coherent synthetic telemetry signals
- **OpenTelemetry Collector** - Observability data pipeline under test
- **VictoriaMetrics** - Time-series metric storage
- **Loki** - Log aggregation system
- **Grafana** - Metric visualization and validation

## Use Case

Validate OTel Collector transformation correctness without production infrastructure. Test complex multi-stage transformation pipelines with mathematical verification.

**Example:** Verify that aggregating gauge metrics to produce a counter matches a directly generated counter (constant offset expected).

## Architecture

```
otelbox (OTLP) → OTel Collector Chain (OTLP) → VictoriaMetrics (Prometheus Remote Write) → Grafana (HTTP)
                                              → Loki (OTLP)                            → Grafana (HTTP)
```

All components run in containers with simple bridge networking. Fresh data on each run ensures reproducible tests.

## Current Status

**Phase 2: OTel Collector Migration** (In Progress)

- Core pipeline operational with transform and deltatocumulative processors
- Metrics validation dashboard active
- Loki integration complete
- Self-monitoring in progress

## Requirements

- Podman + Podman Compose
- Linux host with container runtime support

### Podman Socket Setup

The OTel Collector's `podman_stats` receiver requires access to the Podman socket for container metrics:

```bash
# Activate Podman socket (user session)
systemctl --user enable --now podman.socket

# Set socket permissions (required for container access)
sudo chmod 666 $XDG_RUNTIME_DIR/podman/podman.sock
```

**Platform Compatibility:**

- **Arch Linux (bare metal)**: Full support with above setup
- **WSL2/Ubuntu**: Not functional - podman_stats receiver incompatible with WSL2 environment

Note: Container metrics collection will be unavailable on WSL2/Ubuntu. Application metrics (otelbox telemetry) remain fully functional.

**Known Issue - WSL2/Ubuntu:**

The `podman_stats` receiver cannot collect container statistics in WSL2 environments due to cgroups v2 requirements. The error `"No stats found"` is expected behavior. This limitation does not affect the core testbench functionality:

- ✅ Application metrics (otelbox → OTel Collector → VictoriaMetrics) work normally
- ✅ Transformation validation works normally
- ✅ All dashboards except container resource table function correctly
- ❌ Container metrics table will remain empty

To eliminate error logs in WSL2, you can remove the `podman_stats` receiver configuration from `2_collection/otelcol/config.yaml` and remove the `metrics/container` pipeline from the service configuration.

## License

MIT License - See LICENSE file for details
