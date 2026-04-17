import Link from "next/link";

export default function DocsPage() {
  return (
    <main className="shell">
      <p className="tag">Docs</p>
      <h1>Getting started</h1>
      <ol>
        <li>Install DenTime from the Mac App Store or iOS App Store.</li>
        <li>Sign in with Apple.</li>
        <li>
          Open <strong>Settings → Your code</strong> and share your friend
          code.
        </li>
        <li>
          Paste a friend&apos;s code into <strong>Add a friend</strong> to see
          their local time in your menu bar.
        </li>
      </ol>

      <h2>Features</h2>
      <ul>
        <li>Roster — live local times for everyone you&apos;ve added.</li>
        <li>Time Peek — client-side future-time lookup across your roster.</li>
        <li>Meetups — Doodle-style polls with .ics or EventKit output.</li>
        <li>Groups — organize your roster and invite whole groups at once.</li>
        <li>Widgets — iOS home screen and macOS Notification Center.</li>
        <li>Menu-bar rich timeline — optional 12-hour overlap strip.</li>
        <li>Push notifications for meetup invites and RSVPs.</li>
      </ul>

      <h2>Subscription</h2>
      <p>
        $0.99/month or $10.99/year with a 7-day free trial. One subscription
        unlocks both the macOS and iOS apps.
      </p>

      <p>
        <Link href="/">← Home</Link>
      </p>
    </main>
  );
}
