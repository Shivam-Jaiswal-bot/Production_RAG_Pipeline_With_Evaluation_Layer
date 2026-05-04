import axios from "axios";

// In native dev, Vite talks directly to the host-mapped backend at :8000.
// In Compose-internal dev (frontend-docker), VITE_API_URL=http://backend:8000
// is injected and the request still routes to the same FastAPI app.
const baseURL = import.meta.env.VITE_API_URL ?? "http://localhost:8000";

export const api = axios.create({ baseURL });

export async function getHealth(): Promise<string> {
  const { data } = await api.get<{ status: string }>("/health");
  return data.status;
}
