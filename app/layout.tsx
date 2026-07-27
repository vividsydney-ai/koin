import type { Metadata, Viewport } from "next";
import "./globals.css";
import Script from "next/script";

export const metadata: Metadata = {
  title: "Koinaku — Keuangan, akhirnya mudah dipahami orang Indonesia",
  description:
    "Literasi keuangan baru untuk generasi muda Indonesia. Sumber terverifikasi OJK, BI, dan IDX.",
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    title: "Koinaku",
    statusBarStyle: "default",
  },
};

export const viewport: Viewport = {
  themeColor: "#faf8f5",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="id" className="h-full antialiased">
      <head>
        <link rel="preconnect" href="https://api.fontshare.com" crossOrigin="anonymous" />
        <link
          href="https://api.fontshare.com/v2/css?f[]=cabinet-grotesk@400,500,700,800,900&f[]=satoshi@300,400,500,700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="min-h-full flex flex-col">{children}</body>
      {/* Cloudflare Web Analytics — cookieless tracking */}
      <Script
        id="cloudflare-web-analytics-web"
        strategy="afterInteractive"
        type="module"
        src="https://static.cloudflareinsights.com/beacon.min.js"
        data-cf-beacon='{"token": "436077d39ca44d72a18cc7a11a214184"}'
      />
    </html>
  );
}
