# Skill Exchange — Flutter Documentation

> All architecture and specification documents for the Flutter Skill Exchange app.
> Start with ARCHITECTURE.md. Follow IMPLEMENTATION_ORDER.md for building.

---

## Documents — Recommended Reading Order

| # | File | Description |
|---|------|-------------|
| 1 | [ARCHITECTURE.md](./ARCHITECTURE.md) | **Start here.** Complete architecture: packages, folder structure, layers, networking, auth, state management, theme, navigation, widgets, and all feature modules. |
| 2 | [FLUTTER_CONVENTIONS.md](./FLUTTER_CONVENTIONS.md) | Coding rules and standards. Reference before writing any code. |
| 3 | [MODELS.md](./MODELS.md) | All Freezed data model definitions with field types and relationships. |
| 4 | [API.md](./API.md) | Complete API reference: every endpoint with request/response shapes and Flutter integration points. |
| 5 | [SCREENS.md](./SCREENS.md) | Every screen: route, widgets, providers, states, interactions, loading/empty/error patterns. |
| 6 | [IMPLEMENTATION_ORDER.md](./IMPLEMENTATION_ORDER.md) | Step-by-step build plan ordered by dependency. Follow this sequence. |

---

## Quick Reference

- **14 features**: Auth, Dashboard, Profile, Matching, Connections, Sessions, Reviews, Messaging, Notifications, Search, Community, Settings, Admin, Landing
- **19 screens**, **42 widgets**, **24 models**, **13 providers**, **56 API endpoints**
- **State management**: Riverpod 2.x with code generation
- **Navigation**: go_router with ShellRoute for bottom nav
- **HTTP client**: Dio with interceptors
- **Theme**: Light + Dark mode, extracted from React webapp
- **Architecture**: Feature-first, clean architecture (presentation → provider → repository → data source)

---

## Source React Webapp

This Flutter app is a mobile port of the React web application at:
`/Users/hompushparajmehta/Pushparaj/github/Learning/kruti/react/skill-exchange-platform`

The React app uses:
- React 19 + TypeScript
- React Router v7
- Zustand + Jotai + TanStack Query (state management)
- Axios (HTTP)
- shadcn/ui + Tailwind CSS v4 (UI)
- Zod + react-hook-form (forms)

Every feature, screen, model, and API endpoint in these docs was extracted by reading the React codebase.
