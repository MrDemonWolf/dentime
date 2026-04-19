import type { MetadataRoute } from "next";

export const dynamic = "force-static";

const basePath = process.env.NODE_ENV === "production" ? "/dentime" : "";
const site = "https://mrdemonwolf.github.io";

export default function sitemap(): MetadataRoute.Sitemap {
	const now = new Date();
	const paths = [
		"/",
		"/docs/",
		"/docs/getting-started/",
		"/docs/adding-friends/",
		"/docs/finding-a-meeting-time/",
		"/docs/settings/",
		"/docs/faq/",
		"/docs/troubleshooting/",
		"/docs/roadmap/",
		"/docs/dev/architecture/",
		"/docs/dev/building-from-source/",
		"/docs/dev/contributing/",
		"/docs/dev/debugging/",
		"/legal/terms/",
		"/legal/privacy/",
	];
	return paths.map((p) => ({
		url: `${site}${basePath}${p}`,
		lastModified: now,
	}));
}
