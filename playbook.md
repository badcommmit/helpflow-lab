# HelpFlow AI Triage Playbook

## Problem

HelpFlow's triage and categorization already work well. The gap is response speed on the two highest-stakes categories: bug tickets sit unresolved 87.5% of the time with a 110-minute median first response, and churn-risk tickets, customers actively threatening to leave, go unresolved 66.7% of the time with a 100-minute median. Both are currently routed and handled like any routine ticket, with no fast-path or escalation when a first response is delayed. In this dataset, every ticket that got resolved received a first response within 70 minutes; every ticket that didn't wait 85 minutes or more, a pattern worth validating at scale, but a strong signal on its own. The problem isn't diagnosis, it's speed, specifically where delay is most expensive.

## Before / After Metric

Bug and churn-risk tickets currently sit at a 100 to 110 minute median time to first response, well past the ~70-minute threshold this dataset shows separates resolved tickets from unresolved ones. The target is to get both categories under that 70-minute line. The lever isn't faster diagnosis, triage and categorization already work, it's removing the queue: instant routing to a dedicated Slack channel with a suggested response already drafted turns "wait until someone gets to it" into "read, edit if needed, send."

## How the Flow Works

When a ticket comes in, it's automatically categorized into billing, bug, how-to, churn-risk, or needs-human-review, with a priority assigned based on the language used. Billing and churn-risk tickets are posted to dedicated Slack channels with a suggested response ready to copy, edit, and send. Tickets the system can't confidently categorize are flagged separately for manual review, with no auto-draft attached. Bug and how-to tickets are auto-drafted with no escalation.

There is currently no separate ticketing tool. Tickets arrive as raw text and Slack is the operational surface where humans see and act on the ones that need them. If a real ticketing tool is added later, this flow would need to write back into it instead of just alerting, worth revisiting at that point.

## How a New Hire Runs It

**When a message lands in `#billing-alerts`:** read the ticket text and suggested response, both already in the Slack message. Check the draft against the ticket for accuracy, edit if needed, then reply to the customer directly (via whatever channel the ticket originally came in on, email, chat, etc.) using the edited response.

**When a message lands in `#needs-review`:** read the ticket text and the system's note explaining why it couldn't be categorized. Since there's no draft response, reply to the customer asking for clarification on what they need. Once they respond, resubmit the clarified ticket through the same automated intake, it may turn out to be a simple how-to or billing question the system can now handle without further human involvement, rather than assuming every needs-review ticket requires a human to see it through to resolution.

Bug and how-to tickets are auto-drafted and logged with no action required from a human by default.
