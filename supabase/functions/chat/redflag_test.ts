import { assertEquals } from "@std/assert";
import cases from "../../../safety/red_flag_cases.json" with { type: "json" };
import { RedFlagDetector } from "./redflag.ts";

const detector = new RedFlagDetector();

for (const c of cases) {
  Deno.test(`red flag: ${c.text}`, () => {
    const hit = detector.detect(c.text);
    assertEquals(hit?.outcome ?? "none", c.expected);
    assertEquals(hit?.soft ?? false, (c as { soft?: boolean }).soft ?? false);
  });
}

Deno.test("urgent wins over crisis when both match", () => {
  assertEquals(detector.detect("I want to die, chest pain is unbearable")?.outcome, "urgent");
});

Deno.test("empty and punctuation-only input", () => {
  assertEquals(detector.detect(""), null);
  assertEquals(detector.detect("?!..."), null);
});
