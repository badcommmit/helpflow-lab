# HelpFlow AI Operator Lab

A worked example of the "AI Operator" workflow: take a team's existing process, find where it actually breaks using the data, redesign it with AI in the loop, and prove the fix with an eval instead of a gut feeling. The team here is fictional (HelpFlow, a support org), but the method (baseline first, then skill, then eval, then fix, then human-in-the-loop routing) is the point of this repo.

## The problem

HelpFlow's support tickets were already categorized fine. The gap was response speed on the two costliest categories: `bug` tickets sat unresolved 87.5% of the time (110-min median first response), and `churn-risk` tickets (customers actively threatening to leave) went unresolved 66.7% of the time (100-min median). Every ticket that *did* get resolved received a first response within 70 minutes; every unresolved one waited 85+. See [`baseline.md`](baseline.md) for the full analysis.

That threshold is the whole design brief: get bug and churn-risk tickets a fast, well-drafted first response without routing high-stakes replies through AI unsupervised.

## How it works

- **[`.claude/skills/helpflow-triage/`](.claude/skills/helpflow-triage)**: a Claude Code skill that takes raw ticket text and returns a category (`billing` / `bug-minor` / `bug-severe` / `how-to` / `churn-risk` / `needs-human-review`), a priority, and a drafted response.
- **[`HelpFlow.json`](HelpFlow.json)**: an n8n workflow that runs incoming tickets through the triage logic and routes them: billing, churn-risk, and `bug-severe` post to Slack with a suggested draft attached; needs-human-review posts with no draft, flagged for manual categorization; `bug-minor` and how-to are auto-drafted and logged with no escalation.

The categorization logic inside `HelpFlow.json` is plain rules-based JS, standing in for a live Claude API call. There's no Anthropic API billing set up for this project, so it's a scripted mock of the same rules `SKILL.md` documents. The actual Claude reasoning runs when the skill itself is invoked (e.g. via Claude Code), not inside the deployed n8n workflow.

There's no separate ticketing tool; tickets arrive as raw text and Slack is where a human sees and acts on the ones that need them. See [`playbook.md`](playbook.md) for the operator-facing runbook (what to do when a message lands in `#billing-alerts` vs `#needs-review`).

## The build, in order

The commit history is the actual artifact here: it's an eval-driven iteration loop, not a single build:

1. **Baseline** ([`baseline.md`](baseline.md)): analyzed `data/tickets.csv` (30 tickets) to find the real bottleneck before building anything.
2. **Skill** (`d3766d9`): built the triage skill and moved it into `.claude/skills` for auto-discovery.
3. **Code review caught a flaw** (`591d6ac`): the code-review plugin flagged that the skill's bug-priority rule (medium unless crash/data-loss) contradicted the baseline finding that `bug` is the worst-performing category.
4. **Eval, not opinion** (`b3a6bcb`): added a held-out, hand-labeled eval set (`data/eval_tickets.csv`) to confirm the flaw was a real miss, not a hunch.
5. **Fix, logged** (`3fa4f89`): bug priority defaults to high now, per the eval finding.
6. **Decision table** ([`decision_table.md`](decision_table.md)): once the categorization was trustworthy, decided which categories get full-auto vs. AI-drafts-human-sends vs. AI-never.
7. **Routing gap fixed** (`64e36d9`): `needs-human-review` tickets were silently falling into the same auto-draft branch as everything else, contradicting the decision table's own AI-never call for that category.
8. **Playbook** (`abbb4ed`): wrote the new-hire runbook for operating the flow day to day.
9. **Bug severity split** (`5a43099`): split `bug` into `bug-minor` (cosmetic, full-auto) and `bug-severe` (Slack alert, human review), turning the decision table's "AI drafts, human sends for severe bugs" into a real, tested branch instead of a stated intention.

Full detail: `git log --oneline`.

## Repo map

| Path | What it is |
|---|---|
| `data/tickets.csv` | Synthetic baseline dataset (30 tickets) used for the process analysis |
| `data/eval_tickets.csv` | Held-out, hand-labeled eval set for checking triage accuracy |
| `baseline.md` | Current-state process map, metrics, and the bottleneck hypothesis |
| `decision_table.md` | Which ticket types get full-auto / AI-drafts / AI-never, and why |
| `playbook.md` | Problem statement, before/after target metric, and the operator runbook |
| `.claude/skills/helpflow-triage/` | The Claude skill that categorizes and drafts responses |
| `HelpFlow.json` | The n8n workflow; reimplements the skill's rules as a JS mock and wires the result into Slack routing (no live Claude call; see "How it works" above) |

## Data & credentials

All ticket data is synthetic, with no real customer information. This repo talks to a local n8n instance for workflow development; `n8n_data/` (n8n's local database and encryption key) is gitignored and was never committed.
