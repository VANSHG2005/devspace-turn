# DevSpace CoTURN Server

Free, self-hosted TURN server for WebRTC relay. Runs on Render free tier.

## Setup

1. Push this folder as its own GitHub repo
2. Connect to Render → New Web Service → Docker
3. Set env vars (see below)
4. Deploy

## Env Vars (set in Render dashboard)

| Key | Value | Notes |
|-----|-------|-------|
| `TURN_USER` | `devspace` | Pick any username |
| `TURN_PASS` | `yourStrongPassword123` | Pick a strong password |
| `TURN_REALM` | `devspace.turn` | Can leave as-is |

## After deploy

Your TURN URL will be:
```
turn:devspace-turn.onrender.com:3478
```

Add to Vercel frontend env vars:
```
VITE_TURN_USER = devspace
VITE_TURN_PASS = yourStrongPassword123  
VITE_TURN_URL  = devspace-turn.onrender.com
```
