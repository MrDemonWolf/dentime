import Link from "next/link";

export default function Home() {
  return (
    <main className="shell">
      <p className="tag">DenTime</p>
      <h1>Timezones, but friendly.</h1>
      <p>
        Share your timezone with the people you choose, see their local times
        at a glance, peek at any future moment across your roster, and run
        Doodle-style meetup polls that respect everyone&apos;s wall clock.
      </p>
      <p>
        Native SwiftUI on macOS and iOS. One subscription unlocks both apps.
      </p>

      <p>
        <Link className="cta" href="/docs">Read the docs</Link>
      </p>

      <h2>Ship date</h2>
      <p>Coming soon to the Mac App Store and App Store.</p>

      <h2>Legal</h2>
      <ul>
        <li>
          <Link href="/legal/terms">Terms of Service</Link>
        </li>
        <li>
          <Link href="/legal/privacy">Privacy Policy</Link>
        </li>
      </ul>

      <footer style={{ marginTop: "4rem", opacity: 0.6 }}>
        Made by{" "}
        <a
          href="https://www.mrdemonwolf.com"
          target="_blank"
          rel="noopener noreferrer"
        >
          MrDemonWolf, Inc.
        </a>
      </footer>
    </main>
  );
}
