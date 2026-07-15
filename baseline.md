# Support Ticket Baseline

*Source: `data/tickets.csv` (30 tickets).*

## 1. Current-State Process Map (inferred)

```
Ticket arrives (customer submits text)
        │
        ▼
Auto/manual categorization
  ├─ billing     (7 tickets)  — charges, invoices, refunds
  ├─ bug         (8 tickets)  — crashes, broken features, outages
  ├─ how-to      (9 tickets)  — how do I / what is questions
  └─ churn-risk  (6 tickets)  — explicit cancellation / competitor language
        │
        ▼
First response (time-to-first-response logged in minutes)
        │
        ▼
Resolution attempt
  ├─ Resolved (Y)     → ticket closed
  └─ Not resolved (N) → ticket stays open (no escalation/re-response
                          field exists in the data)
```

Observations baked into this map:
- `billing` and `how-to` tickets are a **solved process**: 0% unresolved across 16 combined tickets, and the fastest response times (medians of 45 and 12 min).
- `bug` tickets are where the process breaks down: **87.5% unresolved** (7 of 8), with the slowest median response time of any category (110 min).
- `churn-risk` tickets — the highest-stakes category, since the customer is actively threatening to leave — are unresolved **66.7%** of the time (4 of 6), with the second-slowest median response (100 min). There's no sign these get routed or escalated differently from a routine bug report.
- There is no field for escalation, reassignment, or reopening, implying today's process is single-touch: categorize once, respond once, and if it isn't resolved on that pass, the ticket appears to just sit open.

## 2. Baseline Metrics

| Metric | Value |
|---|---|
| Median time-to-first-response (overall) | **47.5 min** |
| Median TTFR — how-to | 12 min |
| Median TTFR — billing | 45 min |
| Median TTFR — churn-risk | 100 min |
| Median TTFR — bug | 110 min |
| % unresolved (overall) | **36.7%** (11 of 30) |
| % unresolved — bug | 87.5% (7 of 8) |
| % unresolved — churn-risk | 66.7% (4 of 6) |
| % unresolved — billing / how-to | 0% (0 of 16) |
| % of tickets that are churn-risk | **20.0%** (6 of 30) |

## 3. Bottleneck Hypothesis

**There is a hard response-time threshold around the 70–85 minute mark that separates resolved from unresolved tickets.** Every ticket that was resolved had a first-response time of **70 minutes or less** (max resolved TTFR = 70 min), while every unresolved ticket had a first-response time of **85 minutes or more** (min unresolved TTFR = 85 min) — a clean split with no overlap across all 30 tickets. Combined with bug (110 min median) and churn-risk (100 min median) tickets being the slowest to get a first response, this points to a specific bottleneck: **tickets that don't get a first touch within roughly an hour are the ones that end up never resolved**, regardless of category. Speeding up initial response for `bug` and `churn-risk` tickets specifically — the two categories blowing past that ~70-minute threshold — is the highest-leverage fix implied by the data.

## Known Issue (found via code-review plugin, Module 3)
`helpflow-triage` skill's bug-priority rule (medium unless crash/data-loss mentioned) contradicts this dataset's finding that bug is the worst-performing category (87.5% unresolved). Revisit in Module 6 when redesigning human-in-loop routing.
