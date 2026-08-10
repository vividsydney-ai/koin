# Security Audit — 2026-08-02T12:56:04Z

## 1. Dependency audit
FAIL: dependency audit found issues

## 2. Secret scan
PASS: no obvious live secrets in history

## 3. RLS policy review
Migrations with RLS enabled: 21

## 4. Raw HTML / XSS audit
app/(app)/friends/page.tsx:295:              dangerouslySetInnerHTML={{ __html: qrSvg }}
WARNING: dangerouslySetInnerHTML found; review manually

## Result: FAILED — create Linear issue with label security and escalate
