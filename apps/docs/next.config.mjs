import { createMDX } from "fumadocs-mdx/next";

// Static export to GitHub Pages at mrdemonwolf.github.io/dentime.
// There is no custom domain — App Store Connect gets the github.io URLs.
const repoName = "dentime";
const isProd = process.env.NODE_ENV === "production";

/** @type {import('next').NextConfig} */
const config = {
	reactStrictMode: true,
	output: "export",
	trailingSlash: true,
	images: { unoptimized: true },
	basePath: isProd ? `/${repoName}` : "",
};

const withMDX = createMDX();

export default withMDX(config);
