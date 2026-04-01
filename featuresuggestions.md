# Feature Suggestions: Claude Plugin Marketplace

## Product Advisor Agent Plugin

### Problem Statement

Claude Code is optimized for implementation — writing, reviewing, and debugging code. When users need higher-level product thinking (use case discovery, value proposition analysis, architectural brainstorming, feature prioritization), the tool defaults to engineering solutions rather than strategic discussion. There is no built-in agent, skill, or MCP tool that facilitates product-level thinking.

### Proposed Plugin: `product-advisor`

A plugin that provides a Product Advisor agent and supporting skills for strategic product discussions within Claude Code sessions.

### Agent: `product-advisor`

**Purpose:** Shift Claude from engineer mode to product strategist mode. The agent should think like a combination of product manager, solution architect, and devil's advocate.

**Capabilities:**

1. **Use Case Discovery & Expansion**
   - Identify primary, secondary, and non-obvious use cases for a product
   - Map user personas and their journeys
   - Explore adjacent problem spaces the product could address
   - "What else could this do?" brainstorming

2. **Value Proposition Analysis**
   - Articulate the core value proposition clearly
   - Identify differentiators vs. existing solutions
   - Evaluate build-vs-buy decisions for features
   - Assess which features deliver 80/20 value

3. **Feature Prioritization**
   - Impact vs. effort matrix analysis
   - MoSCoW prioritization (Must/Should/Could/Won't)
   - Dependency mapping between features
   - MVP scoping — what is the minimum viable path to value?

4. **Architectural Trade-offs (Astronaut View)**
   - System-level "what if" discussions (monolith vs. microservices, embedded vs. API, local vs. cloud)
   - Scalability and evolution paths
   - Integration points and ecosystem positioning
   - Technology bets and their risk profiles

5. **Risk & Opportunity Mapping**
   - Technical risks that could derail the product
   - Market risks and competitive landscape
   - Opportunities the current architecture enables
   - "What could this become in 2 years?" forward-looking vision

6. **Challenge Mode**
   - Actively challenge assumptions in the specification
   - Play devil's advocate on design decisions
   - Ask "why not X instead?" questions
   - Identify blind spots in the current plan

### Suggested Skills

#### `/brainstorm`
**Trigger:** User wants to explore ideas openly.
**Behavior:** Structured brainstorming session with phases:
1. Diverge — generate many ideas without judgment
2. Cluster — group related ideas into themes
3. Evaluate — assess feasibility, impact, effort
4. Converge — recommend top 3-5 actionable items

Output: Markdown summary with ideas, themes, and ranked recommendations.

#### `/product-review`
**Trigger:** User wants a product-level review of their current spec/code.
**Behavior:** Read SPECIFICATION.md, CLAUDE.md, and key code files, then produce:
- Product summary (what it does, who it serves, why it matters)
- Strengths (what the product does well)
- Gaps (missing use cases, underserved personas)
- Opportunities (features or pivots that could increase value)
- Risks (technical, market, or architectural)

#### `/use-cases`
**Trigger:** User wants to explore use cases for the product.
**Behavior:** Generate a structured use case map:
- Primary use cases (core value)
- Secondary use cases (extensions of core value)
- Edge use cases (unexpected but valid applications)
- Anti-use cases (what the product should explicitly NOT try to do)

Each use case includes: actor, goal, preconditions, happy path, and value delivered.

#### `/trade-offs`
**Trigger:** User faces an architectural or product decision.
**Behavior:** Structured trade-off analysis:
- State the decision clearly
- List options (minimum 3, including "do nothing")
- For each option: pros, cons, risks, cost, reversibility
- Recommendation with reasoning
- Document decision in SPECIFICATION.md decision log

### Agent System Prompt (Draft)

```
You are a product strategist and solution architect. You think about products
from the perspective of users, markets, and long-term value — not just code.

Your role is to:
- Ask probing questions before jumping to solutions
- Challenge assumptions respectfully but firmly
- Think about the "why" before the "how"
- Consider non-obvious use cases and value propositions
- Balance ambition with pragmatism
- Always ground discussions in the user's actual context and constraints

You do NOT write code. You think, discuss, question, and recommend.
When a discussion leads to a decision, you help document it clearly.

Your output should be structured, concise, and actionable.
Use markdown for formatting. Include trade-off tables where appropriate.
End discussions with clear next steps or decision points.
```

### Integration Points

- **Reads:** SPECIFICATION.md, CLAUDE.md, README.md, project structure
- **Writes:** Can update SPECIFICATION.md decision log (with user approval)
- **Tools:** WebSearch (for competitive analysis), Mermaid Chart (for architecture diagrams)
- **Does NOT use:** Edit, Write (for source code), Bash (for builds/tests)

### Why This Matters

Most development projects fail not because of bad code but because of unclear product thinking. Having a product advisor agent inside Claude Code bridges the gap between "what are we building?" and "how do we build it?" — keeping both conversations in the same workspace rather than forcing users to switch between Claude.ai (ideation) and Claude Code (implementation).

### Applicability

This plugin is project-agnostic — useful for any software project, not tied to a specific language or framework. It would work equally well for a .NET backend, a React frontend, a mobile app, or a data pipeline.
