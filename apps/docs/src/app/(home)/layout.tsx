import type { ReactNode } from "react";
import Link from "next/link";

export default function HomeLayout({ children }: { children: ReactNode }) {
	return (
		<div className="flex min-h-screen flex-col bg-[#091533] text-white">
			<header className="sticky top-0 z-50 backdrop-blur bg-[#091533]/80 border-b border-white/10">
				<nav className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
					<Link href="/" className="flex items-center gap-2 font-semibold">
						<svg viewBox="0 0 32 32" width="28" height="28" aria-hidden>
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
						<Link href="/legal/terms" className="hover:text-[#0FACED]">
							Terms
						</Link>
						<Link href="/legal/privacy" className="hover:text-[#0FACED]">
							Privacy
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
				<div className="mx-auto max-w-6xl px-6 space-y-2">
					<p>© 2026 MrDemonWolf, Inc. · Made with ❤️ in Beloit, WI</p>
					<p className="space-x-4">
						<Link href="/legal/terms" className="hover:text-white">
							Terms
						</Link>
						<Link href="/legal/privacy" className="hover:text-white">
							Privacy
						</Link>
						<a
							href="https://github.com/MrDemonWolf/dentime"
							className="hover:text-white"
							target="_blank"
							rel="noopener noreferrer"
						>
							GitHub
						</a>
						<a href="https://mrdemonwolf.com" className="hover:text-white">
							mrdemonwolf.com
						</a>
					</p>
				</div>
			</footer>
		</div>
	);
}
