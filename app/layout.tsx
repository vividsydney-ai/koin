import type { Metadata, Viewport } from "next";
import "./globals.css";

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
    </html>
  );
}
