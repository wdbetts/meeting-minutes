# Twilio Internal Meetily - Feature Roadmap

## Overview

**Twilio Internal Meetily** is a fork of the Meetily Community Edition, extended with enterprise features for internal Twilio use.

### Goals

- Privacy-first meeting transcription for Twilio employees
- Enterprise-grade authentication and integrations
- Pluggable architecture enabling external agents to consume meeting data
- Better transcription quality via Bedrock-hosted models

### Non-Goals

- Competing with Meetily Pro/Enterprise commercially
- Building agents inside the app (agents are external)
- Multi-tenant SaaS deployment

### Deployment

- Local only for the foreseeable future
- Internal Twilio use only, not for external sale

---

## Feature Tiers

### P0 - Foundation (Build First)

| Feature | Description | Status |
|---------|-------------|--------|
| Okta SSO | SAML/OIDC integration for Twilio employee auth | Not started |
| Bedrock LLM Integration | Claude/GPT via AWS Bedrock for summarization | Not started |
| WebSocket Topic Streaming | Real-time structured topic events for external agents | Not started |
| Webhook Events | Post-meeting event delivery to configured endpoints | Not started |

### P1 - Core Integrations

| Feature | Description | Status |
|---------|-------------|--------|
| Slack Integration | Share summaries, send notifications to channels | Not started |
| Calendar Integration | Auto-detect meetings, pull attendee lists, schedule context | Not started |
| Topic Extraction Pipeline | LLM-powered extraction of structured topic summaries | Not started |

### P2 - Collaboration (Later)

| Feature | Description | Status |
|---------|-------------|--------|
| Shared Meeting Libraries | Team-accessible meeting archives | Not started |
| Team Workspaces | Organize meetings by team/project | Not started |
| Permissions Model | Control who can view/edit meetings | Not started |

---

## Pluggable Agent Architecture

### Core Principle

App produces data, agents consume it. One-way flow. No data flows back from agents to the app.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    Meetily (Twilio Internal)                │
│  ┌──────────────┐    ┌─────────────────────────────────┐   │
│  │ Transcription│───>│   Topic Extraction Pipeline     │   │
│  │   Engine     │    │   (LLM-powered, structured)     │   │
│  └──────────────┘    └───────────────┬─────────────────┘   │
│                                      │                      │
│         ┌────────────────────────────┼──────────────────┐  │
│         v                            v                  │  │
│  ┌─────────────────┐      ┌──────────────────┐         │  │
│  │ WebSocket Server│      │  Webhook Emitter │         │  │
│  │  (Real-time)    │      │  (Post-meeting)  │         │  │
│  └────────┬────────┘      └────────┬─────────┘         │  │
└───────────┼─────────────────────────┼──────────────────────┘
            │                         │
            v                         v
   ┌─────────────────────────────────────────────────────┐
   │              External Agents (Your Code)            │
   │  - Meeting Augmentation Agent                       │
   │  - Future: Backlog sync agent, Slack bot, etc.      │
   └─────────────────────────────────────────────────────┘
```

### Topic Event Schema

```json
{
  "event_id": "uuid",
  "meeting_id": "uuid",
  "timestamp": "2026-03-08T10:15:30Z",
  "type": "topic",
  "data": {
    "summary": "Discussion about migrating auth service to Okta",
    "mentioned_people": ["Sarah", "Mike"],
    "entities": ["auth service", "Okta", "Q2 timeline"],
    "confidence": 0.85
  }
}
```

### Endpoints

- **WebSocket (Real-time):** `ws://localhost:{PORT}/ws/topics/{meeting_id}`
- **Webhook (Post-meeting):** Configured endpoint receives same schema on meeting end

---

## Context: Meetily Pro/Enterprise Comparison

This fork fills gaps in Community Edition without conflicting with Meetily's paid roadmap:

| Feature | Community | Pro (Planned) | Twilio Internal |
|---------|-----------|---------------|-----------------|
| Speaker Attribution | Me/Them (audio source) | AI-based diarization | Me/Them (inherited) |
| LLM Provider | Ollama (local) | OpenAI-compatible | Bedrock (Claude/GPT) |
| Auth | None | Unknown | Okta SSO |
| Agent Interface | None | None | WebSocket + Webhooks |
| Calendar | None | Coming Soon | P1 priority |

---

## Related Documents

- [Meeting Augmentation Agent Vision](./2026-03-08-meeting-augmentation-agent-vision.md) - External agent that consumes topic events
