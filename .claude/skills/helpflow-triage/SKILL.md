---
name: helpflow-triage
description: Categorizes a raw support ticket and drafts a suggested first response. Use when given ticket text that needs routing (billing, bug-minor, bug-severe, how-to, or churn-risk) and a priority level.
---

# HelpFlow Ticket Triage

Given raw ticket text, output exactly this structure:

- **category**: one of billing | bug-minor | bug-severe | how-to | churn-risk
- **priority**: high | medium | low
  - churn-risk is always high priority
  - bug-severe is high by default (bug tickets have the worst resolution rate in this dataset) — this covers anything with real functional impact (crashes, data loss, broken core features).
  - bug-minor is medium — reserved for cosmetic-only issues with no functional impact (e.g. font, color, spacing, alignment, wording/typos). A ticket merely mentioning the word "text" is not on its own a minor/cosmetic signal — look for an actual cosmetic defect.
  - billing is medium unless it mentions a repeat/duplicate charge, then high
  - how-to is always low
- **suggested_response_draft**: 2-3 sentence draft reply, empathetic tone, acknowledges the issue and states next step (do not promise specific resolution times)

Do not guess category if the ticket is ambiguous — output category: "needs-human-review" instead and explain why in one line.
