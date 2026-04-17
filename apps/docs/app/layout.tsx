import type { Metadata } from "next";
import type { ReactNode } from "react";
import "./globals.css";

export const metadata: Metadata = {
  title: "DenTime — Timezones, but friendly",
  description:
    "Share your timezone with friends, peek at future times, and schedule meetups that respect everyone's wall clock.",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
