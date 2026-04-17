"use client";

import Link from "next/link";
import { useEffect, useState, Suspense } from "react";
import { useSearchParams } from "next/navigation";

type Profile = { displayName: string; timezone: string };

const API_BASE = "https://dentime.mrdemonwolf.workers.dev";

function formatTime(timezone: string): string {
  try {
    return new Intl.DateTimeFormat("en-US", {
      timeZone: timezone,
      hour: "numeric",
      minute: "2-digit",
      hour12: true,
    }).format(new Date());
  } catch {
    return "—";
  }
}

function Profile() {
  const params = useSearchParams();
  const code = params.get("code")?.toUpperCase().replace(/[^0-9A-Z]/g, "");
  const [profile, setProfile] = useState<Profile | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [now, setNow] = useState(() => new Date());

  useEffect(() => {
    const t = setInterval(() => setNow(new Date()), 30_000);
    return () => clearInterval(t);
  }, []);

  useEffect(() => {
    if (!code) {
      setError("missing_code");
      return;
    }
    let cancelled = false;
    fetch(`${API_BASE}/u/${encodeURIComponent(code)}`)
      .then((r) => {
        if (!r.ok) throw new Error(`HTTP ${r.status}`);
        return r.json();
      })
      .then((data: Profile) => !cancelled && setProfile(data))
      .catch((err) => !cancelled && setError(String(err)));
    return () => {
      cancelled = true;
    };
  }, [code]);

  if (!code || error === "missing_code") {
    return (
      <>
        <h1>No profile code</h1>
        <p>This page needs a <code>?code=</code> query string.</p>
      </>
    );
  }
  if (error) {
    return (
      <>
        <h1>Profile unavailable</h1>
        <p>This friend code may have been regenerated or does not exist.</p>
      </>
    );
  }
  if (!profile) return <h1>Loading…</h1>;
  return (
    <>
      <h1>{profile.displayName}</h1>
      <p>
        It&apos;s <strong>{formatTime(profile.timezone)}</strong> in{" "}
        {profile.timezone.replace(/_/g, " ")} right now.
      </p>
      <p className="tag" suppressHydrationWarning>
        Updated {now.toLocaleTimeString()}
      </p>
    </>
  );
}

export default function ProfilePage() {
  return (
    <main className="shell">
      <p className="tag">DenTime profile</p>
      <Suspense fallback={<h1>Loading…</h1>}>
        <Profile />
      </Suspense>
      <p>
        <Link href="/">← Get DenTime</Link>
      </p>
    </main>
  );
}
