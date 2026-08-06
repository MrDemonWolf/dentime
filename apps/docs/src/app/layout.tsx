import { RootProvider } from "fumadocs-ui/provider/next";
import type { ReactNode } from "react";
import "./global.css";

// GitHub Pages is the only host — there is no custom domain. App Store Connect gets
// the privacy and support URLs under this origin.
const siteURL =
	process.env.NODE_ENV === "production"
		? "https://mrdemonwolf.github.io/dentime"
		: "http://localhost:3001";

export const metadata = {
	metadataBase: new URL(siteURL),
	title: {
		default: "DenTime",
		template: "%s · DenTime",
	},
	description:
		"Menu bar app for keeping track of your pack across time zones and picking a time that works for everyone.",
	icons: {
		icon: [{ url: "/favicon.ico", sizes: "any" }],
		apple: "/apple-touch-icon.png",
	},
	openGraph: {
		title: "DenTime",
		description: "Time zones for your pack. Menu bar for Mac.",
		type: "website",
		siteName: "DenTime",
		images: [{ url: "/og.png", width: 1200, height: 630, alt: "DenTime" }],
	},
	twitter: {
		card: "summary_large_image",
		title: "DenTime",
		description: "Time zones for your pack.",
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
