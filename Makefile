.PHONY: help dev down build backend frontend test ingest eval clean logs

help:
	@echo "Targets:"
	@echo "  make dev       - docker compose up --build (backend :8000, frontend :5173)"
	@echo "  make down      - stop and remove containers"
	@echo "  make build     - rebuild images without starting"
	@echo "  make backend   - start backend only"
	@echo "  make frontend  - start frontend only"
	@echo "  make test      - run backend pytest suite locally (uv)"
	@echo "  make ingest    - run SEC 10-K ingestion (Phase 2+)"
	@echo "  make eval      - run evaluation harness (Phase 8+)"
	@echo "  make logs      - tail compose logs"
	@echo "  make clean     - prune containers, networks, named volumes"

dev:
	docker compose up --build

down:
	docker compose down

build:
	docker compose build

backend:
	docker compose up --build backend

frontend:
	docker compose up --build frontend

test:
	cd backend && uv run pytest -q

ingest:
	cd backend && uv run python ../scripts/ingest_filings.py

eval:
	cd backend && uv run python -m app.evaluation.runner

logs:
	docker compose logs -f

clean:
	docker compose down -v --remove-orphans
