export const metadata = {
	title: "Terms of Service",
	description: "DenTime Terms of Service.",
};

export default function TermsPage() {
	return (
		<>
			<h1>Terms of Service</h1>
			<p>
				<em>Last updated: April 19, 2026.</em>
			</p>

			<p>
				These terms govern your use of <strong>DenTime</strong>, a macOS menu bar
				application and accompanying documentation website, both published by{" "}
				<strong>MrDemonWolf, Inc.</strong> ("we", "us"). By installing or using DenTime, you
				agree to these terms. If you don’t, don’t install it.
			</p>

			<h2>License to use</h2>
			<p>
				We grant you a personal, non-exclusive, non-transferable, revocable license to use
				DenTime on any Apple device you own or control, subject to the App Store’s standard
				Licensed Application End User License Agreement. The source code in this repository
				is released under the MIT License.
			</p>

			<h2>Local-only nature (MVP1)</h2>
			<p>
				In this release (MVP1), DenTime runs entirely on your device. It does not have an
				account system, does not transmit data to us or to any third party, and does not
				require an internet connection to function. If that changes in a future release,
				these Terms and the Privacy Policy will be updated before the new behavior ships.
			</p>

			<h2>Your content</h2>
			<p>
				Any data you enter (friend names, timezones, groups) is stored in your Mac’s
				UserDefaults. It is yours. We cannot access it.
			</p>

			<h2>Acceptable use</h2>
			<p>
				Don’t reverse-engineer, resell, or redistribute DenTime except as permitted by the
				MIT License terms on the source code. Don’t use DenTime to violate anyone’s rights
				or applicable law.
			</p>

			<h2>No warranty</h2>
			<p>
				DenTime is provided <em>as is</em>, without warranty of any kind, express or
				implied, including merchantability, fitness for a particular purpose, and
				non-infringement.
			</p>

			<h2>Limitation of liability</h2>
			<p>
				To the maximum extent permitted by law, MrDemonWolf, Inc. is not liable for any
				indirect, incidental, special, consequential, or punitive damages arising from your
				use of DenTime. Our total liability for any claim will not exceed what you paid us
				for DenTime in the twelve months preceding the claim — which, for a free app, is
				zero.
			</p>

			<h2>Governing law</h2>
			<p>
				These Terms are governed by the laws of the State of Wisconsin, United States,
				without regard to its conflict-of-laws principles. Any dispute will be brought
				exclusively in state or federal courts located in Rock County, Wisconsin.
			</p>

			<h2>Changes</h2>
			<p>
				We may revise these Terms. If we do, we’ll update the "Last updated" date above and
				post the new version at this URL. For material changes, we’ll do our best to surface
				them in the app before they take effect.
			</p>

			<h2>Contact</h2>
			<p>
				Questions? <a href="mailto:support@mrdemonwolf.com">support@mrdemonwolf.com</a>.
			</p>
		</>
	);
}
