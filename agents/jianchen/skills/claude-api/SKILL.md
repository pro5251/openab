---
name: claude-api
description: Integration with Anthropic's Claude API. Use when the user wants to add AI capabilities to the backend, needs prompt engineering, or wants to manage LLM state.
---

# Claude API Integration

## Best Practices
1.  **Prompt Engineering**: Use XML tags for structure and provide clear instructions.
2.  **Streaming**: Implement server-sent events (SSE) for a better user experience.
3.  **Error Handling**: Handle rate limits (429) and context window limits gracefully.
4.  **Context Management**: Summarize or truncate conversation history to stay within limits.
