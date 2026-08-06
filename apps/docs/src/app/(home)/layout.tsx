import Link from "next/link";
import type { ReactNode } from "react";

export default function HomeLayout({ children }: { children: ReactNode }) {
	return (
		<div className="flex min-h-screen flex-col bg-[#091533] text-white">
			<header className="sticky top-0 z-50 border-b border-white/10 bg-[#091533]/80 backdrop-blur">
				<nav className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
					<Link href="/" className="flex items-center gap-2 font-semibold">
						<svg viewBox="0 0 32 32" width="28" height="28" aria-hidden="true">
							<rect width="32" height="32" rx="7" fill="#0FACED" />
							<circle cx="11" cy="11" r="2" fill="#091533" />
							<circle cx="16" cy="9" r="2" fill="#091533" />
							<circle cx="21" cy="11" r="2" fill="#091533" />
							<ellipse cx="16" cy="18" rx="6" ry="5" fill="#091533" />
						</svg>
						DenTime
					</Link>
					<div className="flex items-center gap-6 text-sm">
						<Link href="/docs" className="hover:text-[#0FACED]">
							Docs
						</Link>
						<Link href="/docs/privacy" className="hover:text-[#0FACED]">
							Privacy
						</Link>
						<Link href="/docs/support" className="hover:text-[#0FACED]">
							Support
						</Link>
						<a
							href="https://github.com/MrDemonWolf/dentime"
							target="_blank"
							rel="noopener noreferrer"
							className="hover:text-[#0FACED]"
						>
							GitHub
						</a>
					</div>
				</nav>
			</header>
			<main className="flex-1">{children}</main>
			<footer className="border-t border-white/10 py-8 text-center text-xs text-white/60">
				<div className="mx-auto max-w-6xl space-y-2 px-6">
					<p>© 2026 MrDemonWolf, Inc.</p>
					<p className="space-x-4">
						<Link href="/docs/privacy" className="hover:text-white">
							Privacy
						</Link>
						<Link href="/docs/support" className="hover:text-white">
							Support
						</Link>
						<a
							href="https://github.com/MrDemonWolf/dentime"
							className="hover:text-white"
							target="_blank"
							rel="noopener noreferrer"
						>
							GitHub
						</a>
					</p>
				</div>
			</footer>
		</div>
	);
}
