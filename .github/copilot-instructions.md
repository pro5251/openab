# OpenAB — Copilot Instructions

## Build, Test, and Lint

```bash
# Run the bot locally
cargo run

# Or with a specific config
cargo run -- run -c config.toml

# Check, lint, and test (mirrors CI)
cargo check
cargo clippy -- -D warnings
cargo test

# Run a single test by name
cargo test <test_name>

# Run tests in a specific module
cargo test acp::protocol::tests
```

CI runs on PRs that touch `src/**`, `Cargo.toml`, `Cargo.lock`, or `Dockerfile*`.

## Architecture

OpenAB is a **multi-platform ACP agent broker** written in async Rust (Tokio). It bridges Discord, Slack, and webhook platforms (Telegram, LINE) to any [Agent Client Protocol](https://github.com/anthropics/agent-protocol)-compatible CLI (Kiro, Claude Code, Codex, Gemini, etc.) over stdio JSON-RPC.

```
Platform Adapter  →  AdapterRouter  →  SessionPool  →  ACP CLI Process (child)
(discord/slack/gateway)               (one per thread)  (stdin/stdout JSON-RPC)
```

**Key modules:**

| Path                    | Role                                                              |
| ----------------------- | ----------------------------------------------------------------- |
| `src/adapter.rs`        | `ChatAdapter` trait + `AdapterRouter` — platform-agnostic routing |
| `src/discord.rs`        | Discord adapter (serenity `EventHandler`)                         |
| `src/slack.rs`          | Slack adapter (Socket Mode)                                       |
| `src/gateway.rs`        | WebSocket gateway adapter for Telegram/LINE                       |
| `src/acp/protocol.rs`   | JSON-RPC types + `AcpEvent` classification                        |
| `src/acp/connection.rs` | Spawn CLI child process, stdio JSON-RPC communication             |
| `src/acp/pool.rs`       | `SessionPool` — maps session key → `AcpConnection`                |
| `src/config.rs`         | TOML deserialization + `${ENV_VAR}` expansion                     |
| `src/reactions.rs`      | `StatusReactionController` — emoji debounce + stall detection     |
| `src/format.rs`         | Message splitting, thread name shortening                         |
| `src/markdown.rs`       | Markdown → platform text conversion                               |
| `src/cron.rs`           | Cron job scheduler (reuses shared adapters)                       |

Discord runs in the **foreground** (blocking `client.start()`). Slack and Gateway run as background Tokio tasks. Shutdown is coordinated via a `tokio::sync::watch` channel for graceful drain.

## Key Conventions

### `ChannelRef` vs `SenderContext` — critical distinction

These two types have **different semantics for `channel_id`**:

- **`ChannelRef`** — used for _routing_ (sending API calls). For Discord threads, `channel_id` is the **thread's channel ID** (required by Discord's API). `parent_id` holds the parent channel.
- **`SenderContext`** — injected as metadata _for the agent_. Here `channel_id` is always the **parent channel**, and `thread_id` is the thread identifier. This is consistent across all platforms (Slack model).

### Config — `${ENV_VAR}` expansion

All config values (local and remote URL) support `${VAR}` environment variable substitution. Never hardcode secrets; use env var references instead.

### `AllowBots` — three-value bot message filtering

`allow_bot_messages` in config accepts: `"off"` (default), `"mentions"`, or `"all"`. Bot's own messages are always ignored regardless.

### ACP permission auto-reply

`connection.rs` auto-replies to permission requests from the agent CLI, preferring `allow_always` > `allow_once` > any non-reject option.

### Clippy is enforced as errors

All warnings are errors in CI (`clippy -- -D warnings`). Keep the codebase warning-free.

### Tests live in source files

Unit tests are in `#[cfg(test)]` blocks at the bottom of each source file. Integration testing is done manually via Docker/k8s.

## Release Process

Releases are **tag-driven** and managed via GitHub Actions. Never bump versions manually.

1. Run **Actions → Release PR** workflow (auto-calculates or manual semver)
2. Merge the generated Release PR → `tag-on-merge.yml` auto-tags → `build.yml` builds multi-arch images
3. Stable release = **promote** the pre-release image (no rebuild). Run Release PR again with `0.x.y` (no `-beta`).

Version is kept in sync across: `Cargo.toml`, `charts/openab/Chart.yaml` (`version` + `appVersion`).

**Image variants** (7 total, each multi-arch amd64+arm64):
`openab` (kiro), `openab-claude`, `openab-codex`, `openab-gemini`, `openab-opencode`, `openab-copilot`, `openab-cursor`

## Language Preference

- 所有回覆請使用「繁體中文（台灣）」。
- 思考過程與說明也請使用繁體中文。
- 專有名詞保留英文，但說明需為中文。
- 如果有任何不確定的地方，請提出問題以獲得更多資訊。