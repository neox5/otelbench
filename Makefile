.PHONY: help setup-socket up up-bench down restart logs logs-errors logs-errors-warn

# Default target
help:
	@echo "otelbench - OpenTelemetry Collector Testbench"
	@echo ""
	@echo "Usage:"
	@echo "  make up               Start testbench (no container monitoring)"
	@echo "  make up-bench         Start testbench with container monitoring (Arch bare metal)"
	@echo "  make down             Stop testbench and remove volumes"
	@echo "  make restart          Restart all services"
	@echo "  make logs             View logs from all services"
	@echo "  make logs-errors      View only error logs"
	@echo "  make logs-errors-warn View error and warning logs"
	@echo "  make setup-socket     Setup Podman socket for container metrics"
	@echo ""
	@echo "Platform Notes:"
	@echo "  WSL2/Ubuntu:     Use 'make up' (container monitoring unavailable)"
	@echo "  Arch bare metal: Use 'make up-bench' (full monitoring support)"

# Socket setup for Arch bare metal
setup-socket:
	@echo "Setting up Podman socket for container metrics..."
	systemctl --user enable --now podman.socket
	sudo chmod 666 $(XDG_RUNTIME_DIR)/podman/podman.sock
	@echo "Socket ready at $(XDG_RUNTIME_DIR)/podman/podman.sock"

# Start without bench monitoring (WSL2/Ubuntu compatible)
up:
	podman-compose up -d

# Start with bench monitoring (Arch bare metal - requires socket setup)
up-bench: setup-socket
	podman-compose --profile bench up -d

# Stop all services and remove volumes
down:
	podman-compose down -v -t 0

# Stop all services (including otelcol-bench) and remove volumes
down-bench:
	podman-compose --profile bench down -v -t 0

# Restart all services
restart: down up

# View logs
logs:
	podman-compose logs --names 2>&1
