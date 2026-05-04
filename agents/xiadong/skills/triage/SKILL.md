---
name: triage
description: Triage issues through a state machine driven by triage roles. Use when user wants to create an issue, triage issues, review incoming bugs or feature requests, prepare issues for an AFK agent, or manage issue workflow.
---

# Triage

Move issues on the project issue tracker through a small state machine of triage roles.

## State Roles
- `needs-triage` — evaluation in progress.
- `needs-info` — waiting on reporter.
- `ready-for-agent` — fully specified.
- `ready-for-human` — needs human implementation.
- `wontfix` — will not be actioned.

## Process
1.  **Gather Context**: Read the full issue and explore the codebase.
2.  **Reproduce**: Attempt to reproduce bugs before triaging.
3.  **Recommend**: Propose a state and category to the maintainer.
4.  **Apply**: Update labels and post comments.
