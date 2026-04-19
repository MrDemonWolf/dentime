import Link from "next/link";

export default function HomePage() {
	return (
		<>
			{/* Hero */}
			<section className="relative overflow-hidden">
				<div className="mx-auto max-w-6xl px-6 pt-20 pb-24 text-center">
					<div className="mx-auto mb-8 inline-flex items-center justify-center">
						<svg viewBox="0 0 120 120" width="96" height="96" aria-hidden>
							<rect width="120" height="120" rx="26" fill="#0FACED" />
							<circle cx="42" cy="42" r="8" fill="#091533" />
							<circle cx="60" cy="34" r="8" fill="#091533" />
							<circle cx="78" cy="42" r="8" fill="#091533" />
							<ellipse cx="60" cy="72" rx="22" ry="18" fill="#091533" />
						</svg>
					</div>
					<h1 className="text-5xl sm:text-6xl font-bold tracking-tight">
						Timezones for your pack.
					</h1>
					<p className="mt-5 mx-auto max-w-2xl text-lg text-white/80">
						Stop guessing what time it is for Alex in Berlin. DenTime lives in your menu
						bar and shows the current time for everyone in your pack — grouped how you
						want, live, one click away.
					</p>
					<div className="mt-10 flex flex-col sm:flex-row items-center justify-center gap-4">
						<button
							disabled
							className="rounded-full bg-[#0FACED] px-8 py-3 font-semibold text-[#091533] shadow-lg hover:bg-[#0FACED]/90 transition disabled:opacity-70 disabled:cursor-not-allowed"
						>
							Download for Mac · Coming to App Store
						</button>
						<Link
							href="/docs"
							className="rounded-full border border-white/30 px-6 py-3 font-medium hover:bg-white/10 transition"
						>
							Read the docs →
						</Link>
					</div>
					<p className="mt-4 text-xs text-white/50">
						Free · macOS 13+ · iPhone coming soon
					</p>
				</div>
			</section>

			{/* Features */}
			<section className="mx-auto max-w-6xl px-6 py-20">
				<div className="grid gap-6 md:grid-cols-3">
					<FeatureCard
						title="Menu bar at a glance"
						body="Your roster, grouped how you want — Work, Pack, Family. Current time, live. Click anyone to copy a ready-to-paste time string."
					/>
					<FeatureCard
						title="Meeting finder that works"
						body="Pick a time. See it everywhere. Green, yellow, red — instantly know who’s awake, who’s about to be, and who’s fast asleep."
					/>
					<FeatureCard
						title="Privacy-first"
						body="Nothing leaves your Mac. No account. No tracking. No analytics. Your friends list is yours — stored locally, full stop."
					/>
				</div>
			</section>

			{/* Screenshots */}
			<section className="mx-auto max-w-6xl px-6 pb-20">
				<h2 className="text-2xl font-semibold mb-8 text-center">See it in action</h2>
				<div className="grid gap-6 md:grid-cols-2">
					{/* TODO: drop real screenshots once macOS app is notarized */}
					<PlaceholderShot label="Roster (menu bar)" />
					<PlaceholderShot label="Find a Time" />
				</div>
			</section>

			{/* FAQ teaser */}
			<section className="mx-auto max-w-3xl px-6 pb-24">
				<h2 className="text-2xl font-semibold mb-6 text-center">The short version</h2>
				<dl className="space-y-5 text-sm">
					<FAQItem
						q="Is it really free?"
						a="Yes. DenTime is free on the App Store. No paywall, no upsells."
					/>
					<FAQItem
						q="Does it know who my friends are?"
						a="Only the names and timezones you type in. We don’t read your contacts, calendar, or anything else."
					/>
					<FAQItem
						q="Do you track me?"
						a="No analytics, no crash reporting, no telemetry. The docs site runs on GitHub Pages — static HTML."
					/>
					<FAQItem
						q="iPhone?"
						a="Coming next. DenTime for iOS will sync across devices (optional, Apple Sign In)."
					/>
				</dl>
				<p className="mt-10 text-center text-sm">
					More answers in the{" "}
					<Link href="/docs/faq" className="text-[#0FACED] underline">
						full FAQ
					</Link>
					.
				</p>
			</section>
		</>
	);
}

function FeatureCard({ title, body }: { title: string; body: string }) {
	return (
		<div className="rounded-2xl border border-white/10 bg-white/5 p-6 backdrop-blur">
			<h3 className="text-lg font-semibold text-[#0FACED]">{title}</h3>
			<p className="mt-2 text-sm text-white/80 leading-relaxed">{body}</p>
		</div>
	);
}

function PlaceholderShot({ label }: { label: string }) {
	return (
		<div className="aspect-[16/10] rounded-xl border border-white/10 bg-gradient-to-br from-white/5 to-white/0 flex items-center justify-center text-white/40 text-sm">
			{label}
		</div>
	);
}

function FAQItem({ q, a }: { q: string; a: string }) {
	return (
		<div className="rounded-xl border border-white/10 bg-white/5 p-5">
			<dt className="font-medium text-white">{q}</dt>
			<dd className="mt-1 text-white/75">{a}</dd>
		</div>
	);
}
