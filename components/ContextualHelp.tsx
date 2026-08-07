"use client";

import {
  createContext,
  useContext,
  useEffect,
  useId,
  useLayoutEffect,
  useRef,
  useState,
  type ReactNode,
} from "react";
import { createPortal } from "react-dom";

type ContextualHelpState = {
  openId: string | null;
  setOpenId: (id: string | null) => void;
};

const ContextualHelpContext = createContext<ContextualHelpState | null>(null);

export function ContextualHelpProvider({ children }: { children: ReactNode }) {
  const [openId, setOpenId] = useState<string | null>(null);
  return (
    <ContextualHelpContext.Provider value={{ openId, setOpenId }}>
      {children}
    </ContextualHelpContext.Provider>
  );
}

export function ContextualHelp({
  label,
  children,
  align = "left",
  compact = false,
}: {
  label: string;
  children: ReactNode;
  align?: "left" | "right";
  compact?: boolean;
}) {
  const context = useContext(ContextualHelpContext);
  const generatedId = useId();
  const helpId = `context-help-${generatedId.replace(/:/g, "")}`;
  const containerRef = useRef<HTMLSpanElement>(null);
  const dialogRef = useRef<HTMLSpanElement>(null);
  const [position, setPosition] = useState({ top: 0, left: 0 });

  const isOpen = context?.openId === helpId;

  useEffect(() => {
    if (!isOpen || !context) return;
    const closeOnOutsidePointer = (event: PointerEvent) => {
      const target = event.target as Node;
      if (
        !containerRef.current?.contains(target) &&
        !dialogRef.current?.contains(target)
      )
        context.setOpenId(null);
    };
    document.addEventListener("pointerdown", closeOnOutsidePointer);
    return () =>
      document.removeEventListener("pointerdown", closeOnOutsidePointer);
  }, [context, isOpen]);

  useLayoutEffect(() => {
    if (!isOpen) return;
    const updatePosition = () => {
      const anchor = containerRef.current?.getBoundingClientRect();
      if (!anchor) return;
      const dialogWidth = 288;
      const gutter = 12;
      const preferredLeft =
        align === "right" ? anchor.right - dialogWidth : anchor.left;
      setPosition({
        top: anchor.bottom + 8,
        left: Math.min(
          Math.max(gutter, preferredLeft),
          window.innerWidth - dialogWidth - gutter,
        ),
      });
    };
    updatePosition();
    window.addEventListener("resize", updatePosition);
    window.addEventListener("scroll", updatePosition, true);
    return () => {
      window.removeEventListener("resize", updatePosition);
      window.removeEventListener("scroll", updatePosition, true);
    };
  }, [align, isOpen]);

  if (!context)
    throw new Error(
      "ContextualHelp must be used inside ContextualHelpProvider.",
    );

  return (
    <span ref={containerRef} className="relative inline-flex align-middle">
      <button
        type="button"
        aria-label={`More information about ${label}`}
        aria-expanded={isOpen}
        aria-controls={helpId}
        aria-haspopup="dialog"
        onClick={() => context.setOpenId(isOpen ? null : helpId)}
        onKeyDown={(event) => {
          if (event.key === "Escape") context.setOpenId(null);
        }}
        className={
          compact
            ? "relative inline-flex h-5 w-5 items-center justify-center rounded-full text-info outline-none transition before:absolute before:-inset-3 before:content-[''] hover:bg-info/10 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
            : "ml-1 inline-flex min-h-11 min-w-11 items-center justify-center rounded-full text-info outline-none transition hover:bg-info/10 focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2"
        }
      >
        <span
          aria-hidden="true"
          className={
            compact
              ? "flex h-4 w-4 items-center justify-center rounded-full border border-current text-[10px] font-bold leading-none"
              : "flex h-5 w-5 items-center justify-center rounded-full border border-current text-xs font-bold leading-none"
          }
        >
          i
        </span>
      </button>
      {isOpen &&
        createPortal(
          <span
            ref={dialogRef}
            id={helpId}
            role="dialog"
            aria-label={`${label} explanation`}
            style={position}
            className="fixed z-[70] w-72 rounded-xl border border-info/20 bg-surface p-3 text-left text-xs font-normal leading-relaxed text-muted-foreground shadow-lg"
          >
            {children}
          </span>,
          document.body,
        )}
    </span>
  );
}
