import { DocsLayout } from "fumadocs-ui/layouts/docs";
import type { ReactNode } from "react";
import { source } from "@/lib/source";

export default function Layout({ children }: { children: ReactNode }) {
	return (
		<DocsLayout
			tree={source.pageTree}
			nav={{
				title: (
					<span className="flex items-center gap-2 font-semibold">
						<span
							aria-hidden
							className="inline-block size-6 rounded-md"
							style={{ background: "#0FACED" }}
						/>
						DenTime
					</span>
				),
			}}
			links={[
				{ text: "Home", url: "/" },
				{ text: "Terms", url: "/legal/terms" },
				{ text: "Privacy", url: "/legal/privacy" },
			]}
		>
			{children}
		</DocsLayout>
	);
}
