# Changelog

All notable governance, contract, migration, and repo-structure changes should be recorded here.

## Unreleased

### Added

- Initial repository governance baseline documents
- Environment governance and RBAC documentation
- `auth.me.v2` contract draft
- Seed registry and layered seed directory structure
- Pull request template

### Changed

- Reorganized seeds into `base`, `demo`, and `staging`
- Updated seed scripts to reference the new seed layout

### Planned Next

- Selected context and environment switch implementation
- Demo read-only runtime guardrails
- Demo reset maintenance flow

- ## 2026-04-14 (v163)

### Added
- HR Leave canonical API adapter (staging-first)
  - GET /api/hr/leave/requests
  - GET /api/hr/leave/requests/:id
  - POST /approve / reject / cancel

### Changed
- System routes fully migrated to selected-context-aware logic
- Removed memberships[0] dependency in system APIs

### Notes
- /hr/leave frontend still using fallback/mock
- Production /api/me remains v1
- Staging supports selected-context v2

### Next
- Connect frontend /hr/leave to canonical API (read-only)

  ## 2026-04-14 (v165)

### Changed
- Replaced user-facing `Production / PROD` labels with `Primary / PRIMARY`
- No DB, enum, selected-context, or writable logic changed

### Reason
- Align UI semantics with current staging-first architecture
- Avoid misleading testers into thinking the current environment is full production
