# Security Policy

## Plugin Execution Context

Claude Code plugins are agent specifications (Markdown files) that define behavior for Claude Code's AI agent. They do not contain executable code in the traditional sense -- they are instructions that Claude follows.

However, plugins can:
- Instruct Claude to read and write files on the user's filesystem
- Instruct Claude to execute shell commands via the Bash tool
- Instruct Claude to interact with external APIs (GitHub, web search)

Users should review plugin agent specs before installation and understand what capabilities a plugin requests.

## Security Considerations

### For plugin users

- **Review before installing.** Read the agent spec (`agents/*.md`) to understand what the plugin instructs Claude to do.
- **Claude Code permissions apply.** Your Claude Code permission settings (strict, normal, permissive) control what actions require approval, regardless of what a plugin requests.
- **Scope awareness.** Some plugins (like doc-maintainer) can be scoped to specific directories. Use scoping to limit the plugin's reach when appropriate.

### For plugin authors

- **Never instruct agents to read or write secrets.** Do not design agents that access `.env`, credentials, API keys, or other sensitive files.
- **Respect permission boundaries.** Design agents to work within Claude Code's permission model. Never instruct agents to bypass approval prompts.
- **Declare capabilities honestly.** The plugin description and agent spec should clearly state what the agent reads, writes, and executes.
- **Minimize filesystem scope.** If a plugin only needs access to `docs/`, say so in the spec.

## CI/CD Security

The GitHub Actions workflows in this repository:
- Require an `ANTHROPIC_API_KEY` secret for Claude API calls
- Truncate PR diffs to 50KB to prevent prompt injection via large diffs
- Use `actions/checkout@v4` with `fetch-depth: 0` for full history
- Write temporary files to the runner filesystem (cleaned up after workflow)

## Reporting Vulnerabilities

If you discover a security issue with a plugin in this marketplace, please open a GitHub issue. For sensitive issues, contact the repository owner directly.

## Supported Versions

Only the latest version of each plugin is supported. Update plugins regularly:

```bash
/plugin update
```
