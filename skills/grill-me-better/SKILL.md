---
name: grill-me-better
license: MIT
description: Grill the user relentlessly about a plan, design, decision, or idea, one round of AskUserQuestion dialogs at a time, until every open decision is settled. Use whenever the user says "grill me", "stress-test this", "poke holes in", "challenge my plan", "interview me about", or wants their thinking pressure-tested before building, writing, or committing to something.
---

Interview the user relentlessly until the agent and the user reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

## Voice: "the agent" and "the user"

Everything the user sees during the session (question text, headers, option labels and descriptions, previews, and chat messages) refers to the agent as **"the agent"** and to the user as **"the user"**. Never use "I", "me", "my", "we", "you" or "your" there: in a design discussion it gets ambiguous who is meant to do what.

- ✅ "Should the agent write the migration, or will the user handle it?"
- ✅ "The agent recommends Postgres: the user already runs it in production."
- ❌ "Should I write the migration, or will you?"

## Rounds

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions the agent can ask _now_ without guessing at answers it hasn't heard yet. Ask the whole frontier in one round, then wait for the user's answers before the next round.

Ask every round with the `AskUserQuestion` tool, not as plain text in chat: the user answers with quick clicks, sees each trade-off next to its option, and can still type freely.

- **One frontier decision per question.** Put the agent's recommended answer first, with " (Recommended)" at the end of its label, and use each option's `description` for the trade-off. Use `preview` only to compare concrete artifacts (code, layouts, configs), and `multiSelect` only when the choices are not exclusive.
- **Open-ended decisions** (a name, a number, a wording) still get options: offer 2–3 concrete candidates. The user types their own into the free-text field if none fit.
- **Make each question stand on its own.** The user may see only the dialog, so put any context needed for the decision (what the agent found, what an earlier answer settled) into the question text.
- **End every call with the open question:** question "Anything else?", header "Thoughts", options "Nothing to add" and "Stop grilling". The user types their thoughts into the dialog's free-text field; treat them as input that can reshape the tree.
- **Size.** A call holds at most 4 questions: up to 3 frontier decisions plus the open question. Split a bigger frontier over consecutive calls, each ending with the open question.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Read the answers, including any free text attached to an option, recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

## Facts vs. decisions

Finding _facts_ is the agent's job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent with a fresh context window to find it. Don't ask the user for anything the agent could look up itself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

## Ending

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. If the user picks "Stop grilling", end early and list the branches still open. Before acting on anything, summarize the settled decisions in chat and confirm the shared understanding with one last AskUserQuestion. Do not act until the user confirms.
