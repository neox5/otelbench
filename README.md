# otel-testbench

A pluggable testbench for developing and validating OpenTelemetry Collector observability pipeline configurations.

## Overview

otel-testbench orchestrates a complete observability stack using Podman Compose to enable OTel Collector configuration development with controlled, coherent synthetic telemetry.

**Components:**

- **obsbox** - Generates coherent synthetic telemetry signals
- **OpenTelemetry Collector** - Observability data pipeline under test
- **VictoriaMetrics** - Time-series metric storage
- **Grafana** - Metric visualization and validation

## Use Case

Validate OTel Collector transformation correctness without production infrastructure. Test complex multi-stage transformation pipelines with mathematical verification.

**Example:** Verify that aggregating gauge metrics to produce a counter matches a directly generated counter (constant offset expected).

## Architecture

```
obsbox (OTLP) → OTel Collector Chain (OTLP) → VictoriaMetrics (Prometheus Remote Write) → Grafana (HTTP)
```

All components run in containers with simple bridge networking. Fresh data on each run ensures reproducible tests.

## Current Status

**Phase 2: OTel Collector Migration** (In Progress)

- Core pipeline operational with transform and deltatocumulative processors
- Metrics validation dashboard active
- Loki integration pending

## Requirements

- Podman + Podman Compose
- Linux host with container runtime support

## License

MIT License - See LICENSE file for details
