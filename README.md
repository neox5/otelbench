# alloy-testbench

A pluggable testbench for developing and validating Grafana Alloy observability pipeline configurations.

## Overview

alloy-testbench orchestrates a complete observability stack using Podman Compose to enable Alloy configuration development with controlled, coherent synthetic telemetry.

**Components:**

- **obsbox** - Generates coherent synthetic telemetry signals
- **Grafana Alloy** - Observability data pipeline under test
- **VictoriaMetrics** - Time-series metric storage
- **Grafana** - Metric visualization and validation

## Use Case

Validate Alloy transformation correctness without production infrastructure. Test complex multi-stage transformation pipelines with mathematical verification.

**Example:** Verify that aggregating gauge metrics to produce a counter matches a directly generated counter (constant offset expected).

## Architecture

```
obsbox (OTLP) → Alloy Chain (OTLP) → VictoriaMetrics (Prometheus Remote Write) → Grafana (HTTP)
```

All components run in containers with simple bridge networking. Fresh data on each run ensures reproducible tests.

## Current Status

**Phase 1: Simple Chain** (In Progress)

- Repository structure established
- Basic orchestration pending
- Component integration pending

## Requirements

- Podman + Podman Compose
- Linux host with container runtime support

## License

MIT License - See LICENSE file for details
