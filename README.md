# otelbench

A pluggable testbench for developing and validating OpenTelemetry Collector observability pipeline configurations.

## Overview

otelbench orchestrates a complete observability stack using Podman Compose to enable OTel Collector configuration development with controlled, coherent synthetic telemetry.

**Components:**

- **otelbox** - Generates coherent synthetic telemetry signals
- **OpenTelemetry Collector** - Observability data pipeline under test
- **HAProxy** - Load balancer for gateway high availability testing
- **VictoriaMetrics** - Time-series metric storage
- **Loki** - Log aggregation system
- **Grafana** - Metric visualization and validation

## Use Case

Validate OTel Collector transformation correctness without production infrastructure. Test complex multi-stage transformation pipelines with mathematical verification. Test high availability and failover scenarios with multiple gateway instances.

**Example:** Verify that aggregating gauge metrics to produce a counter matches a directly generated counter (constant offset expected).

## Architecture

```
otelbox (OTLP) → OTel Collector (OTLP + gRPC keepalive) → HAProxy (TCP LB) → Gateway-1 (OTLP) → VictoriaMetrics (Prometheus Remote Write) → Grafana (HTTP)
                                                                           → Gateway-2 (OTLP) → Loki (OTLP)                            → Grafana (HTTP)
```

**Failover Mechanism:**

- OTel Collector sends gRPC keepalive PING every 30 seconds
- Dead connections detected after 10 seconds (no PONG response)
- HAProxy routes new connections to healthy gateways
- Total failover time: 10-15 seconds
- Queue prevents data loss during transition

All components run in containers with simple bridge networking. Fresh data on each run ensures reproducible tests.

## Current Status

**Phase 2: OTel Collector Migration** (Complete)

- Core pipeline operational with transform and deltatocumulative processors
- High availability testing with HAProxy load balancer
- gRPC keepalive for connection health monitoring
- Metrics validation dashboard active
- Loki integration complete
- Self-monitoring in progress

## Requirements

- Podman + Podman Compose
- Make (for simplified workflows)
- Linux host with container runtime support

## Quick Start

**WSL2/Ubuntu (without container monitoring):**

```bash
make up          # Start testbench
make logs        # View logs
make down        # Stop and cleanup
```

**Arch Bare Metal (with container monitoring):**

```bash
make up-bench    # Start with container metrics (auto socket setup)
make logs        # View logs
make down        # Stop and cleanup
```

**View all commands:**

```bash
make help
```

## Platform Compatibility

### Arch Linux (bare metal)

**Full support** - Use `make up-bench`

- Automatic Podman socket setup via Makefile
- Container metrics collection enabled
- All dashboard features functional

**Socket Configuration (automated by `make up-bench`):**

```bash
# Enable Podman socket (user session)
systemctl --user enable --now podman.socket

# Set socket permissions (required for container access)
sudo chmod 666 $XDG_RUNTIME_DIR/podman/podman.sock
```

### WSL2/Ubuntu

**Limited support** - Use `make up`

- ✅ Application metrics (otelbox → OTel Collector → VictoriaMetrics) work normally
- ✅ Transformation validation works normally
- ✅ Failover testing works normally
- ✅ All dashboards except container resource table function correctly
- ❌ Container metrics unavailable (WSL2 cgroups v2 limitation)

**Note:** The `podman_stats` receiver cannot collect container statistics in WSL2 environments. This limitation does not affect core testbench functionality. Container metrics table will remain empty but application telemetry is fully operational.

## Services

**Access Points:**

- Grafana: http://localhost:3000 (dashboards and visualization)
- VictoriaMetrics: http://localhost:8428 (metrics API)
- HAProxy Stats: http://localhost:8404 (load balancer status)

**Container Architecture:**

```
otelbox              → Telemetry generator
otelcol              → Primary collector (transforms + keepalive)
haproxy              → Load balancer (OTLP traffic distribution)
otelcol-gateway-1    → Gateway instance 1 (storage export)
otelcol-gateway-2    → Gateway instance 2 (storage export)
otelcol-bench        → Infrastructure monitoring (optional, Arch only)
victoriametrics      → Metrics storage
loki                 → Log storage
grafana              → Visualization
```

## License

MIT License - See LICENSE file for details
