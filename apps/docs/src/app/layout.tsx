import { RootProvider } from "fumadocs-ui/provider/next";
import type { ReactNode } from "react";
import "./global.css";

export const metadata = {
	title: {
		default: "DenTime",
		template: "%s · DenTime",
	},
	description:
		"Menu bar app for finding the best time to meet across timezones. macOS today, iPhone soon.",
	icons: {
		icon: [{ url: "/favicon.ico", sizes: "any" }],
		apple: "/apple-touch-icon.png",
	},
	openGraph: {
		title: "DenTime",
		description: "Timezones for your pack. Menu bar for Mac.",
		type: "website",
		siteName: "DenTime",
		images: [{ url: "/og.png", width: 1200, height: 630, alt: "DenTime" }],
	},
	twitter: {
		card: "summary_large_image",
		title: "DenTime",
		description: "Timezones for your pack.",
		images: ["/og.png"],
	},
};

export default function RootLayout({ children }: { children: ReactNode }) {
	return (
		<html lang="en" suppressHydrationWarning={true}>
			<body className="flex min-h-screen flex-col">
				<RootProvider search={{ enabled: false }} theme={{ defaultTheme: "dark" }}>
					{children}
				</RootProvider>
			</body>
		</html>
	);
}
