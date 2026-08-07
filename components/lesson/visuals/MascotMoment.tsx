import Image from "next/image";

export type MascotRole = "coach" | "celebrate" | "think" | "explore";

const mascotAssets: Record<MascotRole, { src: string; width: number; height: number }> = {
  coach: { src: "/brand/mascots/koin-coach.png", width: 188, height: 188 },
  celebrate: { src: "/brand/mascots/koin-celebrate.png", width: 188, height: 188 },
  think: { src: "/brand/mascots/koin-think.png", width: 188, height: 188 },
  explore: { src: "/brand/mascots/koin-explore.png", width: 188, height: 188 },
};

export function MascotMoment({ role, altText }: { role: MascotRole; altText: string }) {
  const asset = mascotAssets[role];
  return (
    <div className="pointer-events-none absolute -right-2 -top-7 hidden w-24 sm:block" aria-hidden="false">
      <Image
        src={asset.src}
        alt={altText}
        width={asset.width}
        height={asset.height}
        className="h-auto w-full drop-shadow-sm"
        sizes="96px"
      />
    </div>
  );
}
