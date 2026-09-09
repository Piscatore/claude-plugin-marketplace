---
name: dify-delegation
version: 1.0.0
---

# Dify Delegation

This file defines how `rpi-workflow` and `doc-maintainer` may hand a step of their own work to
a matching Dify specialist instead of running it locally — DifyLabs's write-capable
`rpi-workflow-v2` and `doc-maintainer-v2` apps, reached through `DifyRouter`'s `route_message`
MCP tool.

**Used by:**
- `rpi-workflow` — Research-Plan-Implement structured development workflow
- `doc-maintainer` — Documentation auditing and maintenance agent

## Purpose

Every plugin in this marketplace stays fully self-sufficient — delegation is an optional
accelerant, never a dependency (the same governing principle as
`shared/cross-plugin-registry.md`'s companion-plugin delegation, applied here to an external
service instead of another local plugin). The service offered to the human does not change:
same steps, same gates, same artifacts. What changes is *who* produces a given step's output,
and — per DifyLabs's own attribution design — that is never left to guesswork.

## Capability-based delegator/delegatee rule

Whether a step *may* delegate depends only on whether the calling context has a `route_message`
tool available, not on which plugin or step it is:

| Context | Has `route_message`? | Behavior |
|---|---|---|
| Claude Code main agent, DifyLocalGateway/DifyRouter running | Yes | May delegate a step per the pattern below |
| Claude Code main agent, gateway/router unreachable | No | Runs the step locally; falls back silently-but-announced (see Step 5) |
| A Dify specialist itself (`rpi-workflow-v2`, `doc-maintainer-v2`) | No — never attached | Must resolve the step itself or return `open_questions`; never re-delegates |

The last row is a hard invariant, not a default — see Backstops below.

## The 6-step pattern

1. **Try without a health-check.** Call `route_message` directly with `specialist_id` set to the
   matching specialist (`rpi-workflow-v2` for an `rpi-workflow` step, `doc-maintainer-v2` for a
   `doc-maintainer` step) and `already_delegated: false`. A prior health probe just doubles
   latency for the common case where the call simply succeeds.
2. **Pointers, not payloads.** The message sent to the specialist references the target repo path
   and the relevant artifact (work brief, plan, research note) by path — it does not paste whole
   documents into the request. The specialist reads what it needs through the gateway itself.
3. **Answer `open_questions` locally via `AskUserQuestion`.** A specialist with no user channel
   returns interview-pattern.md's `open_questions` envelope instead of guessing. `DifyRouter`
   surfaces this as a distinct field (`SpecialistResponse.OpenQuestions` /
   `RouteResponse.open_questions`) rather than mixing it into plain answer text. Resolve it with
   `AskUserQuestion` the normal way, then send a follow-up `route_message` call with the same
   `specialist_id` and the answers folded into the message.
4. **Verify the artifact on disk — don't trust the report.** A specialist's claim that it wrote a
   file, ran a command, or opened a PR is not evidence that it did. Confirm independently: a
   separate `read_repo_file`/`list_repo`/`git_log` call, or the actual PR via `gh_pr_view`. This is
   the same discipline DifyLabs's own KB applies everywhere else (`known-issues.md`'s repeated
   "don't trust a plausible-sounding answer" lesson) — a lying or merely wrong specialist must be
   caught here, not downstream.
5. **Fall back silently-but-announced.** *Silently* means without interrupting the user with an
   error dialog for a routine unavailability (gateway/router down, specialist call failed) — not
   without saying anything. Run the step locally as if delegation had never been attempted, and
   say so in the closing provenance line (Step 6). An unannounced fallback is not a preserved
   experience, it is an untestable one.
6. **Close with a provenance line.** Exactly one of two sources, never a specialist's own
   self-declaration:
   - Delegated: the literal `[routed to specialist: <id>]` prefix `DifyRouter` itself prepends
     (`RouteMessageTool.cs`) — trustworthy because the router adds it, not the model.
   - Local: `— local (<reason>)`, e.g. `— local (router unreachable)` or
     `— local (no route_message tool)`.

## Backstops against recursive delegation

Two self-reported guards exist on the `DifyRouter` side, both defense-in-depth rather than a
security boundary — `DifyRouter` has no per-caller identity system today (a single bearer token),
so both are only as honest as whatever calls them:

- `already_delegated: true` on `route_message` — refused unconditionally.
- `caller_specialist_id` naming a member of the target room — refused.

**The mechanism that actually holds is not either of these.** It is a literal checklist item for
whoever builds a Dify specialist app: **never attach DifyRouter's MCP server to `rpi-workflow-v2`
or `doc-maintainer-v2`.** A specialist with no `route_message` tool cannot delegate no matter what
it is asked to do — that is what row three of the table above encodes. Verify this on every Dify
Studio change to either app: `GET /console/api/apps/<id>` and confirm `model_config.agent_mode.tools`
contains no `provider_id`/`provider_name` referencing `difyrouter`.

## Room and specialist ids

Both specialists live in the `marketplace` room (`DifyRouter/src/DifyRouter/Rooms/marketplace.json`,
gitignored — see `marketplace.example.json` for the schema). Specialist ids:

- `rpi-workflow-v2` — mirrors this repo's `rpi-workflow` plugin.
- `doc-maintainer-v2` — mirrors this repo's `doc-maintainer` plugin.

## Briefing shape

Mirroring `interview-pattern.md`'s subagent-prompt convention, a delegated call's message states:

1. **Step name** — which RPI step or doc-maintainer operation this is (e.g. "4-implement-plan",
   "doc-maintainer active maintenance").
2. **Target repo path** — the repo the specialist should operate in, under the gateway's exposed
   `src-my` folder.
3. **Artifact pointers** — paths to the work brief / plan / research note / prior audit report the
   specialist needs, not their contents.

## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-09-09 | Initial: capability rule, 6-step pattern, backstops, room/specialist ids, briefing shape |

## Version

Delegation Pattern Version: 1.0.0
Last Updated: 2026-09-09
