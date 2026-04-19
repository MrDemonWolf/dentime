import type { ReactNode } from "react";
import Link from "next/link";

export default function LegalLayout({ children }: { children: ReactNode }) {
	return (
		<div className="flex min-h-screen flex-col bg-white text-slate-900 dark:bg-[#091533] dark:text-slate-100">
			<header className="border-b border-slate-200 dark:border-white/10">
				<nav className="mx-auto flex max-w-2xl items-center justify-between px-6 py-4">
					<Link href="/" className="font-semibold">
						DenTime
					</Link>
					<div className="flex items-center gap-5 text-sm">
						<Link href="/docs" className="hover:underline">
							Docs
						</Link>
						<Link href="/legal/terms" className="hover:underline">
							Terms
						</Link>
						<Link href="/legal/privacy" className="hover:underline">
							Privacy
						</Link>
					</div>
				</nav>
			</header>
			<main className="mx-auto w-full max-w-2xl flex-1 px-6 py-10 prose prose-slate dark:prose-invert">
				{children}
			</main>
			<footer className="border-t border-slate-200 py-6 text-center text-xs text-slate-500 dark:border-white/10 dark:text-white/50">
				© 2026 MrDemonWolf, Inc.
			</footer>
		</div>
	);
}
