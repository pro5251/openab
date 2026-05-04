---
name: diagnose
description: Disciplined diagnosis loop for hard bugs and performance regressions. Reproduce → minimise → hypothesise → instrument → fix → regression-test. Use when user says "diagnose this" / "debug this", reports a bug, says something is broken/throwing/failing, or describes a performance regression.
---

# Diagnose

A discipline for hard bugs. Skip phases only when explicitly justified.

## Phase 1 — Build a feedback loop
Spend disproportionate effort here. Build the right feedback loop (test, script, harness), and the bug is 90% fixed.

## Phase 2 — Reproduce
Run the loop. Watch the bug appear.

## Phase 3 — Hypothesise
Generate **3–5 ranked hypotheses** before testing any of them. Each hypothesis must be **falsifiable**.

## Phase 4 — Instrument
Each probe must map to a specific prediction. Change one variable at a time.

## Phase 5 — Fix + regression test
Write the regression test **before the fix**.

## Phase 6 — Cleanup + post-mortem
Re-run the Phase 1 feedback loop. Ask: what would have prevented this bug?
