import { env } from "@dentime/env/server";
import { Hono } from "hono";
import { cors } from "hono/cors";
import { logger } from "hono/logger";

const app = new Hono();

app.use(logger());
app.use(
  "/*",
  cors({
    origin: env.CORS_ORIGIN,
    allowMethods: ["GET", "POST", "OPTIONS"],
  }),
);

app.get("/", (c) => c.text("DenTime API"));

app.get("/health", (c) =>
  c.json({
    status: "ok",
    service: "dentime-api",
    timestamp: new Date().toISOString(),
  }),
);

export default app;
