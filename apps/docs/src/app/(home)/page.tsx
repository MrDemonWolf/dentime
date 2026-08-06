import Link from "next/link";

export default function HomePage() {
	return (
		<section className="mx-auto max-w-3xl px-6 py-24">
			<p className="font-mono text-xs uppercase tracking-[0.14em] text-[#0FACED]">
				MrDemonWolf, Inc.
			</p>
			<h1 className="mt-4 text-4xl font-bold leading-tight sm:text-5xl">
				Make plans with your pack, wherever they are.
			</h1>
			<p className="mt-6 border-l-2 border-[#0FACED] pl-4 text-lg text-white/80">
				A macOS menu bar app that keeps a roster of your people, shows their local time, and
				runs polls to pick a time that works for everyone.
			</p>
			<p className="mt-8 text-sm text-white/60">
				{/* TODO: real landing copy, screenshots and a download link once the app ships. */}
				In development. Nothing to download yet.
			</p>
			<div className="mt-8 flex gap-4 text-sm">
				<Link
					href="/docs"
					className="rounded-md bg-[#0FACED] px-4 py-2 font-medium text-[#091533]"
				>
					Read the docs
				</Link>
				<a
					href="https://github.com/MrDemonWolf/dentime"
					target="_blank"
					rel="noopener noreferrer"
					className="rounded-md border border-white/20 px-4 py-2 font-medium hover:border-[#0FACED]"
				>
					GitHub
				</a>
			</div>
		</section>
	);
}
