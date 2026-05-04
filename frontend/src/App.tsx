import { useEffect, useState } from "react";
import { getHealth } from "./lib/api";

export default function App() {
  const [status, setStatus] = useState<"checking" | "ok" | "down">("checking");

  useEffect(() => {
    getHealth()
      .then((s) => setStatus(s === "ok" ? "ok" : "down"))
      .catch(() => setStatus("down"));
  }, []);

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100">
      <main className="mx-auto max-w-3xl px-6 py-16">
        <h1 className="text-3xl font-semibold tracking-tight">SEC 10-K RAG</h1>
        <p className="mt-2 text-slate-400">
          Production RAG pipeline over SEC 10-K filings with evaluation harness.
        </p>

        <section className="mt-10 rounded-lg border border-slate-800 bg-slate-900 p-6">
          <h2 className="text-lg font-medium">Backend status</h2>
          <div className="mt-3 flex items-center gap-3">
            <span
              className={`inline-block h-2.5 w-2.5 rounded-full ${
                status === "ok"
                  ? "bg-emerald-400"
                  : status === "down"
                  ? "bg-red-400"
                  : "bg-amber-400"
              }`}
            />
            <span className="text-sm text-slate-300">
              {status === "ok"
                ? "API reachable (/health = ok)"
                : status === "down"
                ? "API unreachable — start the backend service"
                : "Checking…"}
            </span>
          </div>
        </section>

        <section className="mt-6 rounded-lg border border-slate-800 bg-slate-900 p-6 text-sm text-slate-400">
          <p>Phase 1: scaffold complete.</p>
          <p>Phase 2 will add SEC EDGAR ingestion of AAPL 10-K filings.</p>
        </section>
      </main>
    </div>
  );
}
