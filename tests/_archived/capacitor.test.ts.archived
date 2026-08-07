import { describe, it, expect } from "vitest";
import { existsSync, readFileSync } from "fs";
import { resolve } from "path";

describe("Capacitor configuration", () => {
  const configPath = resolve(__dirname, "../../capacitor.config.ts");

  it("has capacitor.config.ts", () => {
    expect(existsSync(configPath)).toBe(true);
  });

  it("uses com.koin.app as appId", () => {
    const content = readFileSync(configPath, "utf-8");
    expect(content).toContain("com.koin.app");
  });

  it("points webDir to Next.js output", () => {
    const content = readFileSync(configPath, "utf-8");
    expect(content).toMatch(/webDir:\s*['"]out['"]/);
  });

  it("has cap sync script in package.json", () => {
    const pkg = JSON.parse(readFileSync(resolve(__dirname, "../../package.json"), "utf-8"));
    expect(pkg.scripts["cap:sync"]).toBeDefined();
    expect(pkg.scripts["cap:open:ios"]).toBeDefined();
    expect(pkg.scripts["cap:open:android"]).toBeDefined();
  });

  it("has generated iOS project", () => {
    expect(existsSync(resolve(__dirname, "../../ios/App/App.xcodeproj"))).toBe(true);
  });

  it("has generated Android project", () => {
    expect(existsSync(resolve(__dirname, "../../android/app/build.gradle"))).toBe(true);
  });
});
