---
name: skill-creator
description: Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Gemini CLI's capabilities with specialized knowledge, workflows, or tool integrations.
---

# Skill Creator Skill

## Overview
The Skill Creator skill helps you design, implement, and document new Gemini CLI skills. A well-designed skill encapsulates expert knowledge and proven workflows, making complex tasks repeatable and reliable.

## When to use
Use this skill when you need to:
1.  **Automate a recurring workflow:** Create a structured process for tasks you perform frequently.
2.  **Codify expertise:** Document best practices and specialized knowledge for a specific domain or technology.
3.  **Integrate new tools:** Define how to use a specific set of tools or APIs effectively.
4.  **Enforce standards:** Ensure consistency across the codebase by defining standard ways of performing certain tasks.

## Principles of Great Skills
*   **Atomic and Focused:** Each skill should do one thing well. Avoid creating "Swiss Army Knife" skills that are too broad.
*   **Workflow-Oriented:** Skills should guide the agent through a logical sequence of steps (e.g., Research -> Strategy -> Execution).
*   **Tool-Aware:** Skills should specify which tools are most appropriate for each step of the workflow.
*   **Language-Specific (Optional):** If a skill is for a specific programming language, use idiomatic terms and patterns for that language.
*   **Self-Documenting:** The `SKILL.md` file should be easy for both humans and AI to understand.

## How to Create a Skill
1.  **Define the Scope:** What is the goal of the skill? What are its boundaries?
2.  **Identify the Workflow:** What are the logical steps required to achieve the goal?
3.  **Determine Tool Requirements:** Which tools will be needed for each step?
4.  **Write the SKILL.md:** Use the standard skill template to document the skill's name, description, and workflow.
5.  **Test and Refine:** Use the skill in a real-world scenario and iterate based on its performance.

## Skill Structure (SKILL.md)
Every skill MUST be defined in a `SKILL.md` file with the following structure:

```markdown
---
name: skill-name
description: A concise description of what the skill does and when to use it.
---

# Skill Title

## Overview
A more detailed explanation of the skill's purpose and value.

## When to use
Specific scenarios where this skill is the best tool for the job.

## Workflow
A step-by-step guide on how to perform the task using this skill. Use headers for each phase (e.g., ### Phase 1: Research).

## Best Practices
Tips and guidelines for using the skill effectively and avoiding common pitfalls.

## Examples (Optional)
Concrete examples of how to apply the skill in different contexts.
```
