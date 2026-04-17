/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  trailingSlash: true,
  reactStrictMode: true,
  basePath: "/dentime",
  assetPrefix: "/dentime/",
  images: { unoptimized: true },
};

export default nextConfig;
