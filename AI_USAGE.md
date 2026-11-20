# AI usage

I used Claude Code as my main development tool for Saathi. I made the product and technical decisions through discussion with Claude, had it implement the plan, and reviewed the result myself.

## Project setup

My first instruction to Claude was to fetch the latest documentation for the stack before writing code. Some of the Flutter and Dart changes landed after the model's knowledge cutoff, so I wanted the implementation to use current APIs and avoid deprecated patterns. I kept the relevant version and compatibility notes in the project's instructions. [Project instructions](CLAUDE.md)

I kept the skills and MCP servers relevant to Saathi scoped to the repository. That gave Claude access to the project guidance and tools it needed without loading unrelated instructions into each session. [Project skills](.claude/skills) · [MCP configuration](.mcp.json)

## Planning before implementation

I spent a couple of hours in Claude Code's Plan Mode before starting implementation. We worked through the product scope, user journeys, architecture, booking flow, offline behavior, safety rules, and testing strategy one decision at a time. I asked questions and refined the approach until I was happy with the plan. That document became the reference for implementation. [Project plan](PLAN.md)

## Building and verifying in steps

Once I finalized the plan, I asked Claude to implement it step by step and verify each part before moving on. I kept the workflow token-efficient by focusing each pass on the current task and its checks. I used tests, mocks, and shared fixtures to make verification repeatable for both the Flutter app and the backend. Live model behavior was evaluated separately through hosted runs. [CI checks](.github/workflows/ci.yml) · [Model evaluations](evals/README.md)

## Reviewing and refining the result

When the first working version was ready, I reviewed the app and asked Claude to fix the issues I found. If a feature's implementation did not meet my expectations, I asked Claude to reimplement it. I followed up with a few smaller rounds of fixes and refinements until I was satisfied with the result.

Claude Code drove the initial build and review iterations. I also used Codex for later work on contextual safety and booking checks, CI, release preparation, and the implementation audit. [GitHub Actions](https://github.com/AmanSikarwar/booking-bot/actions)
