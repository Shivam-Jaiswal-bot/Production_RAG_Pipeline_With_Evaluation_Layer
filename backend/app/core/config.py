from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # API keys (populated from env at runtime; empty defaults so /health works pre-config)
    anthropic_api_key: str = ""
    openai_api_key: str = ""
    cohere_api_key: str = ""

    # Models
    generator_model: str = "claude-sonnet-4-6"
    judge_model: str = "claude-opus-4-7"
    embedding_model: str = "text-embedding-3-large"
    reranker_model: str = "rerank-v3.0"

    # Paths
    data_dir: Path = Path("data")
    filings_dir: Path = Path("data/filings")
    chroma_dir: Path = Path("data/chroma")
    eval_sets_dir: Path = Path("data/eval_sets")
    eval_db_path: Path = Path("data/eval_runs.db")

    # Retrieval defaults
    chunk_size: int = 800
    chunk_overlap: int = 100
    top_k: int = 10
    retriever_type: str = "dense"  # dense | sparse | hybrid | hybrid_rerank

    # CORS
    cors_origins: list[str] = ["http://localhost:5173", "http://127.0.0.1:5173"]


settings = Settings()
