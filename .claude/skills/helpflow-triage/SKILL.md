---
name: helpflow-triage
description: Categorizes a raw support ticket and drafts a suggested first response. Use when given ticket text that needs routing (billing, bug, how-to, or churn-risk) and a priority level.
---

# HelpFlow Ticket Triage

Given raw ticket text, output exactly this structure:

- **category**: one of billing | bug | how-to | churn-risk
- **priority**: high | medium | low
  - churn-risk is always high priority
  - bug is high if it mentions crashes/data loss, medium otherwise
  - billing is medium unless it mentions a repeat/duplicate charge, then high
  - how-to is always low
- **suggested_response_draft**: 2-3 sentence draft reply, empathetic tone, acknowledges the issue and states next step (do not promise specific resolution times)

Do not guess category if the ticket is ambiguous — output category: "needs-human-review" instead and explain why in one line.
