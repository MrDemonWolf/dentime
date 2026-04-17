import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Privacy Policy — DenTime",
};

export default function PrivacyPage() {
  return (
    <main className="shell">
      <p className="tag">Legal</p>
      <h1>Privacy Policy</h1>
      <p>
        <strong>Last updated:</strong> [insert date on publish]
      </p>
      <p>
        <strong>Lawyer review required before publishing.</strong> Draft policy
        content lives in the approved implementation plan. Replace this
        placeholder with the final, counsel-reviewed copy before the first App
        Store submission.
      </p>
      <p>
        Contact:{" "}
        <a href="mailto:legal@mrdemonwolf.com">legal@mrdemonwolf.com</a>
      </p>
      <p>
        <Link href="/">← Back home</Link>
      </p>
    </main>
  );
}
