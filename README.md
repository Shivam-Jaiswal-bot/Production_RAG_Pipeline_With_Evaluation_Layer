# Production RAG Pipeline with Evaluation Layer

Production-grade Retrieval-Augmented Generation system over **SEC 10-K filings** (Apple Inc.), with a measurable evaluation harness scoring **Faithfulness, Answer Relevancy, Context Precision, and Context Recall**. The harness lets us prove the pipeline actually improves when we change retrievers, prompts, or models.

> "Production" here means properly modular, containerized, evaluated, and observable — not cloud-deployed. Target environment is local Docker Compose.

## Stack

| Layer | Tool |
|---|---|
| Backend | Python 3.11, FastAPI, uvicorn |
| Package manager | `uv` |
| RAG framework | LlamaIndex |
| Vector DB | ChromaDB (persistent) |
| Embeddings | OpenAI `text-embedding-3-large` |
| Generator LLM | Anthropic Claude **Sonnet 4.6** (`claude-sonnet-4-6`) |
| Judge LLM (eval) | Anthropic Claude **Opus 4.7** (`claude-opus-4-7`) |
| Eval framework | RAGAS |
| Reranker (Phase 10) | Cohere Rerank v3 |
| Run persistence | SQLite via SQLAlchemy |
| Frontend | React + TypeScript + Vite + Tailwind |
| Charts | Recharts |
| Orchestration | Docker Compose |

## Prerequisites

- Docker Desktop (with Compose v2)
- Node 20+ and Python 3.11 are **only required if you want to run services natively**; otherwise the Compose images are self-contained.
- API keys: Anthropic, OpenAI, Cohere (Cohere only needed for Phase 10).

## Setup

```bash
git clone https://github.com/Shivam-Jaiswal-bot/Production_RAG_Pipeline_With_Evaluation_Layer.git
cd Production_RAG_Pipeline_With_Evaluation_Layer

cp .env.example .env
# Then open .env and fill in the API keys + your SEC_USER_AGENT.

make dev
```

Once the containers are up:

| Service | URL |
|---|---|
| Frontend (UI) | http://localhost:5173 |
| Backend API | http://localhost:8000 |
| Health probe | http://localhost:8000/health |

The landing page pings `/health` and shows a green dot when the API is reachable.

## Layout

```
.
├── backend/              FastAPI + RAG + eval pipeline
│   ├── app/
│   │   ├── main.py
│   │   ├── api/routes/   query, eval, ingest endpoints
│   │   ├── core/         config, logging
│   │   ├── ingestion/    SEC EDGAR downloader, HTML parser, table extractor
│   │   ├── chunking/     recursive + section-aware strategies
│   │   ├── embeddings/   OpenAI embeddings
│   │   ├── vectorstore/  ChromaDB persistent store
│   │   ├── retrieval/    dense, sparse (BM25), hybrid (RRF), reranker
│   │   ├── generation/   Anthropic LLM + prompt templates
│   │   ├── evaluation/   metrics, eval set loader, runner, store
│   │   └── models/       pydantic request/response models
│   ├── data/
│   │   ├── filings/      raw + parsed 10-Ks (gitignored)
│   │   ├── eval_sets/    committed eval-set artifacts
│   │   └── chroma/       persistent vector index (gitignored)
│   └── tests/
├── frontend/             Vite + React + TS + Tailwind
│   └── src/
│       ├── components/   ChatInterface, CitationCard, MetricChart, RunDetail
│       ├── pages/        Chat, Evaluation, RunDetail
│       └── lib/api.ts    Axios client
├── scripts/              ingest_filings.py, build_eval_set.py
├── eval_data/            golden_set.jsonl (committed, Phase 6)
├── docker-compose.yml
├── Makefile
└── .env.example
```

## Common commands

```bash
make dev         # build + start backend (:8000) and frontend (:5173)
make down        # stop containers
make test        # run backend pytest suite (locally via uv)
make ingest      # Phase 2+: download/parse 10-Ks (AAPL × 4 fiscal years)
make eval        # Phase 8+: run eval harness over the golden set
make logs        # tail compose logs
make clean       # full teardown including named volumes
```

## Build phases

This repo is being built **strictly phase-by-phase**. Each phase ends with a tested commit; the next phase only starts after explicit approval.

| Phase | Deliverable | Status |
|---|---|---|
| 1 | Scaffold (FastAPI `/health`, Vite/React UI, Compose, env) | **In progress** |
| 2 | SEC EDGAR ingestion (AAPL × last 4 FYs, sections + tables) | Pending |
| 3 | Chunking + OpenAI embeddings + ChromaDB index | Pending |
| 4 | Dense retrieval + Claude Sonnet 4.6 generation, `POST /query` | Pending |
| 5 | Frontend chat UI with citation cards | Pending |
| 6 | Synthetic golden eval set (30 Q&A, Opus-generated) | Pending |
| 7 | Four eval metrics (Faithfulness, Relevancy, Precision, Recall) | Pending |
| 8 | Eval runner + SQLite persistence + `/eval/*` endpoints | Pending |
| 9 | Eval dashboard (runs table, Recharts trends, run detail) | Pending |
| 10 | Hybrid retrieval + Cohere rerank — proves the harness works | Pending |

## License

For educational / portfolio use. Not affiliated with the SEC, Apple, or Anthropic.
