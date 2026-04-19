import type { MetadataRoute } from "next";

export const dynamic = "force-static";

const basePath = process.env.NODE_ENV === "production" ? "/dentime" : "";
const site = "https://mrdemonwolf.github.io";

export default function robots(): MetadataRoute.Robots {
	return {
		rules: [{ userAgent: "*", allow: "/" }],
		sitemap: `${site}${basePath}/sitemap.xml`,
	};
}
