# SaarAI - Architecture Decisions

## Version 1

Date: 2026-08-02

### Project Name
SaarAI

### Meaning
"Saar" (सार) means the essence or truth of something.

### Tech Stack

Frontend:
- Flutter

Backend:
- FastAPI

AI:
- Google Gemini

Database:
- None (MVP)

Authentication:
- None (MVP)

Hosting:
- TBD

### Principles

- Flutter never talks directly to Gemini.
- Backend owns all AI communication.
- Gemini always returns JSON.
- Images are processed and discarded.
- No user accounts in MVP.