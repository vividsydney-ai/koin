export function Footer() {
  return (
    <footer className="border-t border-border bg-surface py-8 text-center text-xs text-muted-foreground">
      <p className="font-display text-sm font-semibold text-foreground">Koinaku</p>
      <p className="mt-1">Financial literacy, one lesson at a time.</p>
      <p className="mt-4">© {new Date().getFullYear()} Vivid Savitri-Hampton trading as Koinaku.</p>
    </footer>
  );
}
