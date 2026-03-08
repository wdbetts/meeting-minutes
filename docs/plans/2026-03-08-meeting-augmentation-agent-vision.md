# Meeting Augmentation Agent - Vision

## Problem Statement

### Current Pain

- During meetings, you manually research context on another monitor
- You search past meetings, Slack, Jira for relevant info
- You drop links in Zoom chat to share findings
- After meetings, you manually extract TODOs and update backlog
- This splits your attention and takes you out of the conversation

### Vision

An agent that listens to meeting topics in real-time and autonomously gathers context, surfacing it to you without requiring your attention. Post-meeting, it synthesizes TODOs and enriches your backlog.

### Key Constraints

- Agent is **external** to Meetily - consumes topic events but never pushes data back
- **Local deployment** only for the foreseeable future
- Runs alongside Meetily on your machine

---

## Agent Pipeline Architecture

### Core Concept

A local agent process that connects to Meetily's topic stream and provides hooks for future capabilities.

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                 Meetily (Local App)                         │
│            WebSocket: ws://localhost:PORT/ws/topics         │
└───────────────────────────┬─────────────────────────────────┘
                            │ Topic Events (real-time)
                            v
┌─────────────────────────────────────────────────────────────┐
│              Meeting Augmentation Agent (Local)             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Event Receiver                          │   │
│  │  - WebSocket client for real-time topics             │   │
│  │  - Webhook listener for post-meeting events          │   │
│  └───────────────────────────┬─────────────────────────┘   │
│                              │                              │
│                              v                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Plugin Pipeline                         │   │
│  │  - Receives topic events                             │   │
│  │  - Routes to registered handlers                     │   │
│  │  - Handlers are future work (search, backlog, etc.)  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Pipeline Interface (Conceptual)

```python
class TopicHandler:
    async def on_topic(self, event: TopicEvent) -> None:
        """Override to handle topic events."""
        pass

    async def on_meeting_end(self, meeting_id: str) -> None:
        """Override for post-meeting processing."""
        pass
```

### Topic Event Schema

Events received from Meetily follow this structure:

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

---

## Future Exploration (Out of Scope)

These capabilities will be explored once the pipeline is working:

- **What systems the agent connects to** - Slack, Jira, Confluence, past meetings, etc.
- **How context is surfaced** - Slack DM, local UI, or other
- **TODO extraction** - Identifying backlog candidates from discussion
- **Backlog enrichment** - Adding context to existing items, priority signals
- **Specific handler implementations** - Each data source becomes a handler plugin

### Relevant Skills for Future Work

When implementing handlers, these skills may be useful:

- `backlog-discovery` - Finding and organizing backlog items
- `wave-planner` - Prioritization and planning
- `agent-slack` - Slack automation and context gathering

---

## Related Documents

- [Twilio Internal Meetily Roadmap](./2026-03-08-twilio-internal-meetily-roadmap.md) - The app that produces topic events
