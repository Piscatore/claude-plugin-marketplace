---
name: 3-validate-plan
description: "Validate an implementation plan against architecture rules, pattern compliance, completeness, and risk. Updates the plan with fixes if issues are found."
user-invocable: true
---

# Validate Plan

Review and validate an implementation plan before execution.
This is an optional but recommended step of the RPI workflow.

## Process

### 1. Load Context

Read `.claude/rpi-config.json` if it exists. Extract:
- `architecture.layers` — for dependency order validation
- `architecture.codePatterns` — for pattern compliance
- `architecture.styleRules` — for code style checks
- `validation.structuralChecks` — project-specific structural rules
- `validation.patternChecks` — project-specific pattern rules

Read the most recent plan from `{workingDirs.plans}/`.
If no plan exists, tell the user to run `/2-create-plan` first.

### 2. Structural Validation

**If config has `validation.structuralChecks`**: Run each configured check.

**Always check these universal rules:**
- [ ] **Dependency order**: Changes respect the layer dependency flow
- [ ] **Interface-first**: New interfaces defined before implementations
- [ ] **Registration**: Every new service/component has a wiring step
- [ ] **Schema sync**: Data model changes match code model properties

**If config has `architecture.layers`**: Verify that each plan step is
assigned to the correct layer and that no step depends on a later layer.

### 3. Pattern Compliance

**If config has `validation.patternChecks`**: Verify each step follows
the configured patterns. For each check, read the relevant existing code
to confirm the plan matches.

**If config has `architecture.codePatterns`**: Verify each step references
or follows the documented patterns.

**Always check:**
- [ ] **Code style**: Consistent with existing codebase conventions
- [ ] **File naming**: Follows project naming conventions
- [ ] **Test coverage**: New functionality has test steps

### 4. Completeness Check

- [ ] All files listed in research are addressed in the plan
- [ ] Build verification steps included (at minimum after each phase)
- [ ] Test steps included for new functionality
- [ ] Configuration changes documented
- [ ] No orphan steps (every step has clear input and output)
- [ ] Acceptance criteria from the work brief are all addressable

### 5. Risk Assessment

- [ ] Breaking changes to existing interfaces identified
- [ ] Migration path clear for schema/data changes
- [ ] Large steps broken into smaller, independently verifiable pieces
- [ ] Rollback approach defined for risky steps

### 6. Update Plan

If issues found, update the plan with fixes. When a fix requires a user
decision (e.g. "two ways to resolve the layer violation — which do you
prefer?"), ask via `AskUserQuestion` rather than free-form prose. Batch
up to 4 related fix-decisions per call.

If validation is delegated to a subagent (e.g. a project-specific
validator from `validation.patternChecks`), the subagent prompt MUST
include the subagent propagation block from `agents/rpi-workflow.md`
so the subagent returns structured `open_questions` instead of trying
to talk to the user.


Add a validation log entry at the bottom of the plan document:

```markdown
## Validation Log

### {Date}
**Result**: PASS / PASS WITH NOTES / NEEDS REVISION

**Issues Found**:
1. {description} — **Fix**: {what was changed}

**Checklist**:
- [x] {check that passed}
- [ ] {check that failed — with explanation}
```

## Output

Report validation results: PASS / PASS WITH NOTES / NEEDS REVISION.
If passed, suggest proceeding with `/4-implement-plan`.
