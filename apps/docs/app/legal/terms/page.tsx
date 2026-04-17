import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Terms of Service — DenTime",
};

export default function TermsPage() {
  return (
    <main className="shell">
      <p className="tag">Legal</p>
      <h1>Terms of Service</h1>
      <p>
        <strong>Last updated:</strong> [insert date on publish]
      </p>
      <p>
        <strong>Lawyer review required before publishing.</strong> Draft terms
        tailored to DenTime&apos;s actual flows live in the approved
        implementation plan. Replace this placeholder with the final,
        counsel-reviewed copy before the first App Store submission.
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
