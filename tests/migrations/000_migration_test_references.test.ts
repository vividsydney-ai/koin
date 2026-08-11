import { existsSync, readdirSync, readFileSync } from "fs";
import { resolve } from "path";
import { describe, expect, it } from "vitest";

const migrationTestsDirectory = resolve(__dirname);
const migrationDirectory = resolve(__dirname, "../../supabase/migrations");
const migrationReference = /supabase\/migrations\/([^"'`\s)]+\.sql)/g;

describe("migration test references", () => {
  it("does not point at removed historical migration files", () => {
    const missingReferences: string[] = [];

    for (const filename of readdirSync(migrationTestsDirectory)) {
      if (!filename.endsWith(".test.ts")) continue;

      const testPath = resolve(migrationTestsDirectory, filename);
      const source = readFileSync(testPath, "utf8");
      const references = source.matchAll(migrationReference);

      for (const reference of references) {
        const migrationFilename = reference[1];
        if (!existsSync(resolve(migrationDirectory, migrationFilename))) {
          missingReferences.push(`${filename} -> ${migrationFilename}`);
        }
      }
    }

    expect(missingReferences).toEqual([]);
  });
});
