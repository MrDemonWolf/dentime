export const metadata = {
	title: "Privacy Policy",
	description: "DenTime Privacy Policy.",
};

export default function PrivacyPage() {
	return (
		<>
			<h1>Privacy Policy</h1>
			<p>
				<em>Last updated: April 19, 2026.</em>
			</p>

			<p className="lead">
				<strong>
					DenTime for macOS (MVP1) collects nothing. Everything stays on your device.
				</strong>
			</p>

			<h2>Who we are</h2>
			<p>
				DenTime is published by <strong>MrDemonWolf, Inc.</strong>, a Wisconsin, USA
				company. We are the data controller for the (minimal) data described in this policy.
				Reach us at <a href="mailto:support@mrdemonwolf.com">support@mrdemonwolf.com</a>.
			</p>

			<h2>What we don’t collect</h2>
			<p>
				DenTime MVP1 does not collect, transmit, sell, or share any personal data. There is
				no account system, no telemetry, no crash reporter, no analytics, and no advertising
				SDK. The app runs inside Apple’s App Sandbox and its Privacy Manifest declares zero
				data collection.
			</p>

			<h2>What’s stored locally</h2>
			<p>
				To function, DenTime stores the following <em>on your Mac only</em>, inside macOS’s
				UserDefaults database:
			</p>
			<ul>
				<li>
					The friend names, timezones, optional group labels, and optional color hexes you
					enter
				</li>
				<li>
					Your display preferences (12h/24h, working hours, refresh interval,
					launch-at-login toggle)
				</li>
			</ul>
			<p>
				We have no way to access this data. It never leaves your device. Deleting the app or
				running <code>defaults delete com.mrdemonwolf.dentime</code> removes it.
			</p>

			<h2>This website</h2>
			<p>
				The DenTime docs site is static HTML hosted on GitHub Pages. We do not run analytics
				on it in MVP1. GitHub itself may log standard request metadata (IP, user agent) as
				part of serving the page — see{" "}
				<a
					href="https://docs.github.com/en/site-policy/privacy-policies/github-privacy-statement"
					target="_blank"
					rel="noopener noreferrer"
				>
					GitHub’s privacy statement
				</a>
				. We do not receive that data.
			</p>

			<h2>Cookies</h2>
			<p>None. The site sets no cookies.</p>

			<h2>Third parties</h2>
			<p>None, other than GitHub serving the static site.</p>

			<h2>Your rights under GDPR and similar laws</h2>
			<p>
				Because DenTime MVP1 processes no personal data, most data-subject rights (access,
				rectification, erasure, portability, objection) are exercised directly by you on
				your own device. If you believe we nonetheless hold any data about you and want to
				exercise these rights, email{" "}
				<a href="mailto:support@mrdemonwolf.com">support@mrdemonwolf.com</a> and we’ll
				confirm what (if anything) we have.
			</p>

			<h2>Children</h2>
			<p>
				DenTime is not directed at children under 13 (or the equivalent minimum age under
				your local law). We knowingly collect no data from anyone.
			</p>

			<h2>International transfers</h2>
			<p>
				Because we process no personal data, no cross-border transfer takes place under
				MVP1.
			</p>

			<h2>When sync ships (MVP2)</h2>
			<p>
				A future release (MVP2) will introduce opt-in sync via Apple Sign In. When that
				ships, we will collect: an Apple anonymous user identifier, the display name you
				choose, your timezone, your roster (friend names, timezones, groups), and any
				meetups you create. That data will live on our private infrastructure (Cloudflare D1
				in the United States) and will only be used to deliver the sync feature. This policy
				will be updated <em>before</em> that change goes live, with the lawful basis,
				retention period, and deletion mechanism spelled out.
			</p>

			<h2>Changes to this policy</h2>
			<p>
				We’ll update the "Last updated" date above when this policy changes. For material
				changes, we’ll do our best to surface them in the app before they take effect.
			</p>

			<h2>Contact</h2>
			<p>
				Questions, requests, or concerns:{" "}
				<a href="mailto:support@mrdemonwolf.com">support@mrdemonwolf.com</a>.
			</p>
		</>
	);
}
