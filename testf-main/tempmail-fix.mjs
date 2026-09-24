// Fixed Tempmail.lol inbox creation — replaces generic "Failed to create a Tempmail.lol inbox"
// Root causes fixed:
//  1. Sending `domain` you don't own -> 400 {"error":"Invalid domain selected"}
//  2. Invalid `prefix` (<4 chars / uppercase / symbols) -> 400
//  3. Missing Content-Type: application/json / empty body handling
//  4. Swallowing HTTP status + body behind a generic error
// Verified: POST https://api.tempmail.lol/v2/inbox/create with {} returns {address, token}

const BASE_URL = "https://api.tempmail.lol/v2";

function sanitizePrefix(prefix) {
  if (prefix == null || prefix === "") return undefined;
  const clean = String(prefix).toLowerCase().replace(/[^a-z0-9]/g, "");
  if (clean.length < 4) throw new Error(`Invalid prefix "${prefix}": must be >=4 chars a-z0-9 after sanitizing (got "${clean}")`);
  return clean;
}

async function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

export async function createInbox({ prefix, domain, apiKey, retries = 3, timeoutMs = 20000 } = {}) {
  const body = {};
  const cleanPrefix = sanitizePrefix(prefix);
  if (cleanPrefix) body.prefix = cleanPrefix;
  // Only send domain if you own it via Plus/Ultra + apiKey. Otherwise omit or API 400s.
  if (domain) {
    if (!apiKey) throw new Error(`Refusing to send domain "${domain}" without apiKey — free tier would 400 with "Invalid domain selected". Omit domain for a random inbox.`);
    body.domain = domain;
  }

  const headers = {
    "Content-Type": "application/json",
    "User-Agent": "TempMailJS/4.4.0",
  };
  if (apiKey) headers["Authorization"] = `Bearer ${apiKey}`;

  let lastErr;
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const ctrl = new AbortController();
      const t = setTimeout(() => ctrl.abort(), timeoutMs);
      let res;
      try {
        res = await fetch(`${BASE_URL}/inbox/create`, {
          method: "POST",
          headers,
          body: JSON.stringify(body),
          signal: ctrl.signal,
        });
      } finally {
        clearTimeout(t);
      }
      if (res.status === 429 || res.status >= 500) {
        const text = await res.text().catch(() => "");
        lastErr = new Error(`Tempmail.lol transient [${res.status}]: ${text || res.statusText}`);
        if (attempt < retries) {
          await sleep(1000 * attempt);
          continue;
        }
        throw lastErr;
      }
      if (!res.ok) {
        const text = await res.text().catch(() => "");
        throw new Error(`Create inbox failed [${res.status}]: ${text || res.statusText}`);
      }
      const data = await res.json();
      if (!data?.address || !data?.token) throw new Error(`Bad inbox response: ${JSON.stringify(data)}`);
      return data; // { address, token }
    } catch (e) {
      if (e?.name === "AbortError") lastErr = new Error(`Create inbox timed out after ${timeoutMs}ms (attempt ${attempt}/${retries})`);
      else lastErr = e;
      if (attempt >= retries) break;
      // Don't retry on 4xx programming errors, only on network/transient
      if (String(lastErr.message).match(/\[40[03]\]|\[400\]|Invalid prefix|Refusing to send domain/)) break;
      await sleep(1000 * attempt);
    }
  }
  throw new Error(`Failed to create a Tempmail.lol inbox after ${retries} attempt(s): ${lastErr?.message}`);
}

export async function checkInbox(token) {
  const res = await fetch(`${BASE_URL}/inbox?token=${encodeURIComponent(token)}`, {
    headers: { "User-Agent": "TempMailJS/4.4.0" },
  });
  if (!res.ok) throw new Error(`Check inbox failed [${res.status}]: ${await res.text()}`);
  const data = await res.json();
  if (data.expired) return undefined;
  return data.emails ?? [];
}
