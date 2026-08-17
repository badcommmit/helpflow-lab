#!/bin/bash
# Smoke test: hits every routing branch in decision_table.md
# Uses the production webhook path — the workflow must be Published in n8n first.

# billing
curl -X POST http://localhost:5678/webhook/02eb8a36-aac8-4b7d-a8df-a477815fdc3f \
  -H "Content-Type: application/json" \
  -d '{"id": 1, "text": "I was charged twice this month"}'

# churn-risk
curl -X POST http://localhost:5678/webhook/02eb8a36-aac8-4b7d-a8df-a477815fdc3f \
  -H "Content-Type: application/json" \
  -d '{"id": 2, "text": "This is the third bug this month, thinking about cancelling"}'

# how-to
curl -X POST http://localhost:5678/webhook/02eb8a36-aac8-4b7d-a8df-a477815fdc3f \
  -H "Content-Type: application/json" \
  -d '{"id": 3, "text": "How do I add a teammate to my workspace?"}'

# needs-human-review (ambiguous)
curl -X POST http://localhost:5678/webhook/02eb8a36-aac8-4b7d-a8df-a477815fdc3f \
  -H "Content-Type: application/json" \
  -d '{"id": 4, "text": "i dont know what to do"}'

# bug-severe
curl -X POST http://localhost:5678/webhook/02eb8a36-aac8-4b7d-a8df-a477815fdc3f \
  -H "Content-Type: application/json" \
  -d '{"id": 5, "text": "App crashes and I lost all my data"}'

# bug-minor
curl -X POST http://localhost:5678/webhook/02eb8a36-aac8-4b7d-a8df-a477815fdc3f \
  -H "Content-Type: application/json" \
  -d '{"id": 6, "text": "There is a bug, the button color looks off"}'
