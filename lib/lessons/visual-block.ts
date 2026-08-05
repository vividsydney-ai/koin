import { z } from "zod";

export const visualBlockTypeSchema = z.enum([
  "annotated_data",
  "comparison",
  "process",
  "worked_example",
]);
export const visualBlockPlacementSchema = z.enum(["concept", "example"]);
export const visualBlockDataStatusSchema = z.enum(["illustrative", "source_derived", "calculated"]);

const textSchema = z.string().trim().min(1);
const optionalTextSchema = z.string().trim().min(1).optional();
const annotationSchema = z.object({
  number: z.number().int().min(1).max(99),
  label: textSchema,
  detail: textSchema,
});

const annotatedDataPayloadSchema = z.object({
  quoteTitle: textSchema,
  price: textSchema,
  change: optionalTextSchema,
  fields: z.array(z.object({ label: textSchema, value: textSchema, note: textSchema })).min(1),
  annotations: z.array(annotationSchema).min(1),
});
const comparisonPayloadSchema = z.object({
  leftTitle: textSchema,
  rightTitle: textSchema,
  rows: z.array(z.object({ left: textSchema, right: textSchema })).min(1),
});
const processPayloadSchema = z.object({
  steps: z.array(z.object({ title: textSchema, description: textSchema })).min(1),
});
const workedExamplePayloadSchema = z.object({
  inputs: z.array(z.object({ label: textSchema, value: textSchema })).min(1),
  steps: z.array(textSchema).min(1),
  outcome: textSchema,
});

const copySchema = z.object({
  title: textSchema,
  eyebrow: optionalTextSchema,
  disclosure: optionalTextSchema,
  altText: textSchema,
  payload: z.unknown(),
});

const contentSchema = z.object({ en: copySchema, id: copySchema });

export type VisualBlockType = z.infer<typeof visualBlockTypeSchema>;
export type VisualBlockPlacement = z.infer<typeof visualBlockPlacementSchema>;
export type VisualBlockDataStatus = z.infer<typeof visualBlockDataStatusSchema>;
export type VisualBlockLocale = "en" | "id";
export type AnnotatedDataPayload = z.infer<typeof annotatedDataPayloadSchema>;
export type ComparisonPayload = z.infer<typeof comparisonPayloadSchema>;
export type ProcessPayload = z.infer<typeof processPayloadSchema>;
export type WorkedExamplePayload = z.infer<typeof workedExamplePayloadSchema>;

type BaseVisualBlock = {
  id: string;
  lessonId: string;
  placement: VisualBlockPlacement;
  displayOrder: number;
  dataStatus: VisualBlockDataStatus;
  isPublished: boolean;
  content: z.infer<typeof contentSchema>;
};

export type LessonVisualBlock =
  | (BaseVisualBlock & { blockType: "annotated_data"; content: z.infer<typeof contentSchema> & { en: { payload: AnnotatedDataPayload }; id: { payload: AnnotatedDataPayload } } })
  | (BaseVisualBlock & { blockType: "comparison"; content: z.infer<typeof contentSchema> & { en: { payload: ComparisonPayload }; id: { payload: ComparisonPayload } } })
  | (BaseVisualBlock & { blockType: "process"; content: z.infer<typeof contentSchema> & { en: { payload: ProcessPayload }; id: { payload: ProcessPayload } } })
  | (BaseVisualBlock & { blockType: "worked_example"; content: z.infer<typeof contentSchema> & { en: { payload: WorkedExamplePayload }; id: { payload: WorkedExamplePayload } } });

const baseBlockSchema = z.object({
  id: z.string().uuid(),
  lessonId: z.string().uuid(),
  placement: visualBlockPlacementSchema,
  displayOrder: z.number().int().nonnegative(),
  dataStatus: visualBlockDataStatusSchema,
  isPublished: z.boolean(),
  content: contentSchema,
});

function parsePayload(type: VisualBlockType, payload: unknown) {
  switch (type) {
    case "annotated_data": return annotatedDataPayloadSchema.parse(payload);
    case "comparison": return comparisonPayloadSchema.parse(payload);
    case "process": return processPayloadSchema.parse(payload);
    case "worked_example": return workedExamplePayloadSchema.parse(payload);
  }
}

export function parseLessonVisualBlock(value: unknown): LessonVisualBlock | null {
  const input = z.object({ ...baseBlockSchema.shape, blockType: visualBlockTypeSchema }).safeParse(value);
  if (!input.success) return null;

  const { blockType, content, dataStatus } = input.data;
  if (dataStatus !== "source_derived" && (!content.en.disclosure || !content.id.disclosure)) return null;

  try {
    return {
      ...input.data,
      content: {
        en: { ...content.en, payload: parsePayload(blockType, content.en.payload) },
        id: { ...content.id, payload: parsePayload(blockType, content.id.payload) },
      },
    } as LessonVisualBlock;
  } catch {
    return null;
  }
}

export function visualBlockCopy(block: LessonVisualBlock, locale: VisualBlockLocale) {
  return block.content[locale];
}
