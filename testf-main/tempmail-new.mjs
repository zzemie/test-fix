// New Tempmail provider: mail.tm (free, no API key, verified working 2026-09-24)
// Replaces tempmail.lol. API docs: https://docs.mail.tm
// Flow: GET /domains -> POST /accounts {address,password} -> POST /token -> GET /messages

const BASE = "https://api.mail.tm";

function randStr(n = 10) {
  const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  let s = "";
  for (let i = 0; i < n; i++) s += chars[Math.floor(Math.random() * chars.length)];
  return s;
}

async function req(path, { method = "GET", body, token, timeoutMs = 20000 } = {}) {
  const ctrl = new AbortController();
  const t = setTimeout(() => ctrl.abort(), timeoutMs);
  try {
    const res = await fetch(`${BASE}${path}`, {
      method,
      headers: {
        "Content-Type": "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
      signal: ctrl.signal,
    });
    if (!res.ok) throw new Error(`mail.tm ${method} ${path} [${res.status}]: ${await res.text()}`);
    return res.json();
  } finally {
    clearTimeout(t);
  }
}

export async function createInbox({ prefix } = {}) {
  const domains = await req("/domains");
  const domain = domains["hydra:member"]?.[0]?.domain;
  if (!domain) throw new Error(`mail.tm: no domains available: ${JSON.stringify(domains)}`);
  const login = (prefix?.toLowerCase().replace(/[^a-z0-9]/g, "") || randStr(10)).slice(0, 20);
  const address = `${login}@${domain}`;
  const password = randStr(12) + "Aa1!";
  await req("/accounts", { method: "POST", body: { address, password } });
  const { token } = await req("/token", { method: "POST", body: { address, password } });
  if (!token) throw new Error("mail.tm: no token returned");
  return { address, token, password, provider: "mail.tm" };
}

export async function checkInbox(inbox) {
  const data = await req("/messages", { token: inbox.token });
  return data["hydra:member"] ?? [];
}

export async function waitForEmail(inbox, { timeoutMs = 60000, pollMs = 5000 } = {}) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    const msgs = await checkInbox(inbox);
    if (msgs.length) return msgs[0];
    await new Promise((r) => setTimeout(r, pollMs));
  }
  return null;
}
