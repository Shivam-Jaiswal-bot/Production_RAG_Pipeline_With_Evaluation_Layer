import axios from "axios";

const baseURL = import.meta.env.VITE_API_URL ?? "/api";

export const api = axios.create({ baseURL });

export async function getHealth(): Promise<string> {
  const { data } = await api.get<{ status: string }>("/health");
  return data.status;
}
