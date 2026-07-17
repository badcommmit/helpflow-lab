# HelpFlow — Human-in-the-Loop Decision Table

Built in Module 6, grounded in what was observed in Modules 1-5: baseline.md's
finding that bug is the worst-performing category, the code-review plugin
catching a priority-rule flaw, and the eval in Module 5 confirming that flaw
as a real miss.

| Ticket type | Mode | Reasoning |
|---|---|---|
| how-to | Full-auto, with a human-escalation exit | Info can be pulled from published docs and shared directly. Needs an explicit "talk to a human" exit for anyone who wants one, even on a simple ticket. |
| billing (routine) | AI drafts, human sends | AI helps the agent move faster, but a human still makes the call and is the one who sends. Money makes people want a human on the other end. |
| billing (large refund / dispute) | AI-never | Higher-stakes money conversations should not have AI drafting or touching the response at all — a human should own this from the start. |
| bug (report only, no immediate action needed) | Full-auto | Low-stakes acknowledgment of a report can be automated. |
| bug (severe) | AI drafts, human sends | Bug is this dataset's worst-performing category (87.5% unresolved in baseline.md). Severe cases need a human in the loop before anything goes out, not just an automated draft. |
| churn-risk | AI drafts, human sends | The draft's purpose here is different from billing's — it helps the human assess the situation and decide how to respond, not just save them typing. Human takes over from there. |
| needs-human-review (ambiguous) | AI-never | The system already admitted it can't confidently categorize this ticket — drafting a confident-sounding response anyway risks a rushed human rubber-stamping something wrong. |
| legal threat / compliance mention | AI-never | Needs to go straight to the appropriate team to determine the correct response; too high-risk for AI to draft or touch. |

## Known gaps between this table and the current build
- Bug tickets currently all land on the same fallback branch in n8n
  (full-auto), with no split between "report only" and "severe." The
  severity distinction here is still keyword-based (crash/data loss),
  same caveat noted in the Module 5 eval writeup.
- Billing's Slack alert originally didn't surface the AI's drafted
  response at all — fixed in Module 6 by adding `suggested_response_draft`
  to the Slack message, closing the gap between "AI drafts" (design) and
  what the build actually showed a human.

## Update: needs-human-review gap fixed
Originally, needs-human-review tickets fell into the same fallback branch as bug/how-to (auto-drafted, no escalation) — contradicting this table's own AI-never judgment for that category. Fixed by adding a dedicated Switch branch: needs-human-review tickets now post to Slack with no auto-draft, flagged for manual categorization.
