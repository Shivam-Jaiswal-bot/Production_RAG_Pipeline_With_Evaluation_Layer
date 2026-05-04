.PHONY: help dev down build backend frontend frontend-install frontend-docker test ingest eval clean logs

help:
	@echo "Targets:"
	@echo "  make dev               - backend in Docker (:8000) + Vite frontend natively (:5173)"
	@echo "  make backend           - start backend only (Docker, detached)"
	@echo "  make frontend          - start Vite dev server natively (foreground)"
	@echo "  make frontend-install  - npm install for frontend (run once)"
	@echo "  make frontend-docker   - run frontend in Docker too (Linux-friendly)"
	@echo "  make down              - stop containers"
	@echo "  make build             - rebuild docker images without starting"
	@echo "  make test              - run backend pytest suite locally (uv)"
	@echo "  make ingest            - run SEC 10-K ingestion (Phase 2+)"
	@echo "  make eval              - run evaluation harness (Phase 8+)"
	@echo "  make logs              - tail compose logs"
	@echo "  make clean             - prune containers, networks, named volumes"

dev: backend frontend-install
	@echo ""
	@echo "Backend running at http://localhost:8000 (logs: make logs)"
	@echo "Starting Vite dev server natively at http://localhost:5173 ..."
	$(MAKE) frontend

backend:
	docker compose up -d --build backend

frontend:
	cd frontend && npm run dev

frontend-install:
	cd frontend && npm install

frontend-docker:
	docker compose --profile docker-fe up --build

down:
	docker compose down

build:
	docker compose build

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
