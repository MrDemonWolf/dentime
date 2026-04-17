import { describe, it, expect } from "vitest";
import app from "../src/index";

describe("health endpoint", () => {
  it("returns ok status", async () => {
    const res = await app.request("/health");
    expect(res.status).toBe(200);
    const body = (await res.json()) as {
      status: string;
      service: string;
      timestamp: string;
    };
    expect(body.status).toBe("ok");
    expect(body.service).toBe("dentime-api");
    expect(new Date(body.timestamp).toString()).not.toBe("Invalid Date");
  });

  it("root returns api banner", async () => {
    const res = await app.request("/");
    expect(res.status).toBe(200);
    expect(await res.text()).toBe("DenTime API");
  });
});
