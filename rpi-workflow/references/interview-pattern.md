# Interview Pattern (shared reference)

Canonical rules for all user dialogue in the RPI workflow. Skills reference
this file instead of repeating these rules.

## Orchestrator rules (AskUserQuestion)

1. All user dialogue goes through `AskUserQuestion` — never free-form
   "please answer these questions" prose.
2. Batch up to 4 related questions per call; prefer ONE call per gate.
   Never ask anything already answerable from context (git state, config,
   prior artifacts, linked specs) — read those first.
3. 2–4 concrete options per question, each with a one-line `description`.
   The tool adds an "Other" free-text option automatically; do not add one.
4. Put the sensible default first and suffix its label with "(Recommended)".
5. `header` is a chip of ≤12 characters (e.g. "Scope", "Merge now?").
6. `multiSelect: true` only for genuinely non-exclusive choices.
7. `preview` only on single-select options where visual comparison helps
   (code patterns, PR bodies). Keep previews ≤10 lines.
8. Plan approval inside plan mode uses `ExitPlanMode`, never AskUserQuestion.
9. More than 4 open questions → sequential calls in dependency order
   (earlier answers may change later options).

## Canonical example

AskUserQuestion({
  questions: [{
    question: "Should X be implemented with pattern A or pattern B?",
    header: "Pattern",
    multiSelect: false,
    options: [
      { label: "Pattern A (Recommended)",
        description: "Matches existing code in HandlerA; simpler to review",
        preview: "// HandlerA.cs:42-47 excerpt" },
      { label: "Pattern B",
        description: "Newer style; more flexible but diverges from codebase" }
    ]
  }]
})

## Subagent dialogue contract (open_questions)

Subagents have no user channel and MUST NOT call AskUserQuestion. Every
subagent prompt issued from an RPI skill includes this block:

> No user channel: do not ask the user anything. Return unknowns as entries
> in an `open_questions` list in your final report — each entry: question,
> header (≤12 chars), 2–4 options (label + one-line description), multiSelect
> flag, optional recommended label, one-line rationale. The orchestrator will
> consolidate and ask the user.

The orchestrator merges `open_questions` from all subagents, deduplicates
near-identical questions, maps each entry to an AskUserQuestion question
object, and asks per the rules above.
