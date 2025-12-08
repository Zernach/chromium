# Chromium History Extension

A Chrome extension that lets you chat with AI about your browsing history.
Features high-performance Rust/WebAssembly processing and a long-running
websocket backend.

## Project Overview

This project consists of two main components:

1. **Chrome Extension** - Client-side extension with Rust/WASM for data
   processing
2. **Backend** - Go-based websocket server for AI request handling

## Architecture

```
┌─────────────────────────────────────────────────┐
│           Chrome Extension                      │
│  ┌────────────┐     ┌──────────────┐          │
│  │   Popup    │────▶│Service Worker│          │
│  │   (UI)     │     │              │          │
│  └────────────┘     └──────┬───────┘          │
│                             │                   │
│                     ┌───────▼────────┐         │
│                     │  Rust/WASM     │         │
│                     │  (History      │         │
│                     │   Processing)  │         │
│                     └────────────────┘         │
└─────────────────────────┬───────────────────────┘
                          │ WebSocket
                          ▼
          ┌───────────────────────────┐
          │  WebSocket Server         │
          │  (Go Backend)             │
          │  - Persistent Connection  │
          │  - Rate Limiting          │
          │  - API Key Management     │
          └───────────┬───────────────┘
                      │ HTTPS
                      ▼
          ┌───────────────────────────┐
          │  OpenAI API               │
          │  (GPT-4o-mini)            │
          └───────────────────────────┘
```

## Features

- 🤖 **AI Chat** - Natural language queries about your browsing history
- ⚡ **High Performance** - Rust/WebAssembly for fast data processing
- 🔒 **Secure** - No user API keys needed, backend handles credentials
- 🛡️ **Rate Limiting** - Built-in protection (10 req/min per IP)
- 🎯 **Smart Filtering** - Relevance scoring and keyword matching
- 💬 **Simple UI** - Clean, intuitive chat interface

## Quick Start

### 1. Start Backend Server (Required First)

```bash
cd backend
./setup.sh    # Configure environment and API key
./start.sh    # Start WebSocket server
# Note the server URL from output
```

See [Backend Setup Guide](backend/SETUP_GUIDE.md) for detailed instructions.

### 2. Build Extension

```bash
cd chromium-extension
# Update service_worker.js with your backend URL
make build
```

### 3. Load in Chrome

1. Open `chrome://extensions/`
2. Enable "Developer mode"
3. Click "Load unpacked"
4. Select the `chromium-extension/extension` directory

## Project Structure

```
chromium-history-extension/
├── backend/                     # Go WebSocket Server
│   ├── main.go                 # WebSocket handler
│   ├── openai.go               # OpenAI client
│   ├── types.go                # Type definitions
│   ├── rate_limit.go           # Rate limiting
│   ├── start.sh                # Server start script
│   ├── setup.sh                # Setup script
│   ├── README.md               # Backend docs
│   ├── SETUP_GUIDE.md          # Step-by-step setup
│   └── QUICK_REFERENCE.md      # Command reference
│
└── chromium-extension/          # Chrome Extension
    ├── rust/                    # Rust/WASM module
    │   ├── src/lib.rs          # History processing
    │   └── Cargo.toml
    ├── dart/                    # Dart source (compiles to JS)
    │   └── lib/
    │       ├── background/      # Service worker
    │       ├── popup/           # Popup UI
    │       └── shared/          # Utilities
    ├── extension/               # Chrome extension files
    │   ├── manifest.json
    │   ├── popup/
    │   ├── options/
    │   └── wasm/               # Compiled WASM
    ├── docs/
    │   ├── prd.md              # Product requirements
    │   ├── tasks.md            # Development tasks
    │   └── backend-integration.md
    └── README.md               # Extension docs
```

## Tech Stack

### Frontend (Chrome Extension)

- **Rust** → WebAssembly for data processing
- **Dart** → JavaScript for Chrome APIs and UI
- **Manifest V3** for modern Chrome extension

### Backend (WebSocket Server)

- **Go** for WebSocket server
- **Long-running WebSocket connections** for real-time communication
- **Environment variables** for secure API key storage
- **OpenAI GPT-4o-mini** for AI responses

## Documentation

### Getting Started

- [Backend Setup Guide](backend/SETUP_GUIDE.md) - Complete server setup
  walkthrough
- [Backend Quick Reference](backend/QUICK_REFERENCE.md) - Essential commands
- [Extension README](chromium-extension/README.md) - Extension details

### Technical Details

- [Backend README](backend/README.md) - Backend architecture and API
- [Backend Integration Guide](chromium-extension/docs/backend-integration.md) -
  How frontend connects to backend
- [PRD](chromium-extension/docs/prd.md) - Product requirements

## Prerequisites

### For Backend Server

- Go 1.19+ installed
- OpenAI API key

### For Extension Development

- Rust 1.70+ and wasm-pack
- Dart SDK 3.0+
- Make (optional)

## Development Workflow

### Backend Changes

```bash
cd backend
# Make your changes
./restart.sh  # Restart server with changes
```

### Extension Changes

```bash
cd chromium-extension
# Make your changes
make build   # Rebuilds extension
# Reload in chrome://extensions/
```

## Key Commands

### Backend

```bash
# Start server
cd backend && ./start.sh

# View logs
tail -f logs/server.log

# Test WebSocket connection
# Use a WebSocket client to connect to ws://localhost:8080
```

### Extension

```bash
# Build
cd chromium-extension && make build

# Clean
make clean

# Test WASM
cd rust && cargo test
```

## Rate Limiting

**Current Settings**: 10 requests per minute per IP address, burst of 5

To modify, edit `backend/main.go`:

```go
rateLimiter = NewRateLimiter(10.0/60.0, 5)
```

## Cost Estimates

### Server Hosting

- Self-hosted: $0 (use your own hardware)
- Cloud VPS: ~$5-20/month (depending on provider)

### OpenAI API (GPT-4o-mini)

- ~$0.001-0.005 per request (varies with history size)

**Total**: ~$0.001-0.005 per request + hosting

For 10,000 requests/month: ~$10-50/month + hosting

## Security & Privacy

- ✅ No user API keys required
- ✅ Backend manages OpenAI credentials via Secret Manager
- ✅ IP-based rate limiting
- ✅ No data persistence on backend
- ✅ All communication over HTTPS
- ✅ History processed client-side before sending to backend
- ✅ CORS configured for extension origin

## Troubleshooting

### "Backend connection issue" in extension

1. Verify WebSocket URL in `extension/background/service_worker.js`
2. Check server is running: `ps aux | grep backend`
3. Test WebSocket connection with a client tool

### "Rate limit exceeded"

- Wait 1 minute between requests
- Or increase rate limit in `backend/main.go` and restart server

### Backend returns errors

1. Check server logs: `tail -f backend/logs/server.log`
2. Verify OpenAI API key is set in environment variables
3. Check OpenAI API status

## Contributing

1. Follow existing code structure
2. Add tests for new features
3. Update documentation
4. Ensure build passes

## License

[Your license here]

## Support

- [Backend Documentation](backend/README.md)
- [Extension Documentation](chromium-extension/README.md)
- [Setup Guide](backend/SETUP_GUIDE.md)
- [Integration Guide](chromium-extension/docs/backend-integration.md)

---

Built with Rust 🦀, Go 🔵, and WebAssembly 🕸️
