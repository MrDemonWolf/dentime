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
		"/docs/friend-codes/",
		"/docs/meetups/",
		"/docs/privacy/",
		"/docs/support/",
	];
	return paths.map((path) => ({
		url: `${site}${basePath}${path}`,
		lastModified: now,
	}));
}
