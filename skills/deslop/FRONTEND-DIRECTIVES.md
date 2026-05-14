# Frontend Directives

Loaded when repo has frontend code. Every finding must cite file:line.

## Component Architecture

- **God components**: Component > 200 lines → split. Component doing fetch + state + render + business logic → split by responsibility.
- **Prop drilling**: Props passed through > 3 levels → context/composition/store candidate.
- **State management bloat**: Redux/Zustand/MobX for state that's local to one component → overkill. Flag. Use component state.
- **Global state abuse**: Everything in global store including UI state (modals, tooltips) → flag. Only shared domain state belongs global.
- **Re-render traps**: Inline object/array/function props → new ref every render → child re-renders. Flag if in hot path.
- **useEffect abuse**: Effects doing what event handlers should → flag. Effects as "on mount do X" when X is just init → check if needed.
- **Stale closures**: Event handlers or effects capturing stale state → flag. Common with intervals/timeouts.
- **Key prop misuse**: Array `.map` without stable keys, or using index as key on reorderable lists → flag.

## Security

- **Secrets in client bundle**: `NEXT_PUBLIC_`, `VITE_`, `REACT_APP_` env vars containing API keys, DB urls, private tokens → flag critical. Only public-safe values in client env.
- **Token storage**: Tokens in localStorage → XSS-accessible. Prefer httpOnly cookies. Flag if localStorage/sessionStorage used for auth tokens.
- **Auth flow**: Client-side only auth checks (no server validation) → flag critical. JWT verification must happen server-side.
- **XSS vectors**: `dangerouslySetInnerHTML`, `v-html`, unescaped user input in DOM → flag critical.
- **CSRF**: State-changing requests without CSRF token (if cookie-based auth) → flag.
- **Exposed API routes**: Internal/admin APIs callable from client without auth → flag critical.
- **CSP headers**: Missing Content-Security-Policy → flag major if user-facing app.
- **CORS misconfiguration**: `Access-Control-Allow-Origin: *` on authenticated endpoints → flag critical. Whitelist specific origins.
- **Clickjacking**: No `X-Frame-Options` or `frame-ancestors` CSP directive → flag if user-facing.
- **Cookie flags**: Auth cookies missing `HttpOnly`, `Secure`, `SameSite` → flag critical.
- **Dependency supply chain**: Unpinned deps, no lockfile integrity checks, deps from unknown registries → flag.

## Performance

- **Bundle size**: Import entire library for one function (`import _ from 'lodash'` vs `import get from 'lodash/get'`) → flag.
- **No code splitting**: Single bundle for entire app, lazy routes not used → flag if app > 10 routes.
- **Image optimization**: Unoptimized images served raw → flag. Use next/image, srcset, or similar.
- **Memory leaks**: Subscriptions/event listeners/intervals created in mount, not cleaned up on unmount → flag.
- **Unnecessary re-renders**: Parent re-render cascading to all children without memoization on heavy subtrees → flag if measurable.
- **Heavy computation in render**: Complex calculations in render body without useMemo → flag if frequent.
- **No loading states**: Async data fetched, no skeleton/spinner/suspense → white flash. Flag.

## API Communication

- **Public API exposure**: Frontend hitting API without rate limiting → DDoS vector. Flag if production-facing.
- **No error boundaries**: Unhandled API errors crash entire page → flag. Graceful degradation needed.
- **Retry storms**: Failed request auto-retried without backoff → flag. Can amplify outages.
- **Caching strategy**: Same data fetched on every mount/navigation → SWR/React Query/cache candidate. Flag if re-fetching unnecessarily.
- **Request waterfalls**: Sequential fetches that could be parallel → flag.
- **Optimistic updates**: User waits for server round-trip on every action? Assess if optimistic updates appropriate.

## SSR / SSG

- **Secret leakage via SSR skip**: Framework supports SSR but API calls with secrets made client-side → move to server route/getServerSideProps/loader. Flag.
- **Hydration mismatches**: Server renders X, client renders Y → console warnings = bugs. Flag.
- **SEO**: Public content rendered client-only (SPA) without SSR/SSG → flag if SEO matters.
- **Data fetching location**: Fetching in useEffect what could be fetched in server loader → flag. Server = faster + secrets hidden.

## Styling

- **Mixed approaches**: Tailwind + CSS modules + styled-components in same repo → flag. Pick one.
- **!important abuse**: Multiple `!important` overrides → specificity war. Flag.
- **Inline styles for layout**: Complex layout in inline styles instead of CSS → flag.
- **No responsive design**: Fixed widths, no breakpoints on user-facing app → flag major.
- **Accessibility**: No alt text on images, no ARIA labels on interactive elements, no keyboard navigation on custom controls → flag.
- **Color contrast**: Text unreadable on background (< 4.5:1 contrast) → flag.

## Build & DX

- **TypeScript strictness**: `strict: false` or `any` escape hatches everywhere → flag. Should be strict.
- **Dead build config**: Webpack config for features removed, stale env vars in build → flag.
- **Dev/prod parity**: Different behavior dev vs prod (different API urls hardcoded, debug code in prod) → flag.
- **Hot reload broken**: Config issues preventing HMR → flag (DX critical).
- **Build warnings**: Deprecation warnings, unused vars in build output → flag minor. Clean builds = clean code.
