# Lemma Repo Responsibility Matrix v1

Status: contract-only  
Scope: public repo vs runtime repo responsibility split  
Non-goals:
- does not claim runtime implementation status
- does not replace service-specific runbooks

## 1. Purpose

Define which repo and which collaborator owns which type of change, so public docs, runtime implementation, and UI do not drift apart.

## 2. Repo Responsibility Matrix

| Area | Public docs/contracts repo | Runtime repo |
|------|----------------------------|--------------|
| Product strategy | Yes | No |
| Architecture docs | Yes | Optional local notes only |
| Canonical contract docs | Yes | Must align |
| Update packs | Yes | Optional consumption only |
| API route code | No | Yes |
| Migrations | No formal truth | Yes |
| Deployable frontend | No | Yes |
| Railway deploy config | No formal truth | Yes |
| Smoke implementation | Optional checklist only | Yes |

## 3. Readdy Ownership

Readdy should own:

- UI pages
- page composition
- user flows
- i18n presentation

Readdy should not own:

- formal API contract definition
- backend truth claims
- deployment truth claims

## 4. Codex Ownership

Codex should own:

- public docs updates
- contract alignment
- update packs
- runtime implementation when runtime repo is explicitly in scope
- backend route/migration/deploy work in runtime repo

## 5. Dual-Write Cases

These changes usually require writing to both repos:

- new backend contract
- response shape changes
- implementation slices that start in docs then move into runtime
- API naming changes
- new rollout rules that affect both documentation and execution

Expected order:

1. public docs/contracts repo
2. runtime repo implementation
3. smoke/validation confirmation

## 6. Public-Only Cases

These may be updated only in the public repo:

- product strategy
- role rules
- truth source rules
- repo governance
- contract-only proposals
- update pack preparation before runtime implementation

## 7. Runtime-Only Cases

These may exist only in runtime repo:

- route implementation details
- deploy commands
- environment variable wiring
- migration execution state
- service-specific hotfixes

But if runtime-only work changes contract behavior, public docs must be updated afterward.

## 8. Alignment Triggers

A public repo update requires runtime follow-up when it changes:

- API field names
- response shape
- route ownership
- environment semantics
- rollout gating

A runtime repo update requires public repo follow-up when it changes:

- payload contract
- canonical key policy
- flow semantics
- operational responsibilities

## 9. Responsibility by Artifact

### Public repo artifacts

- `DOCS/architecture/...`
- `DOCS/product/...`
- `contracts/...`
- `updates/...`

### Runtime repo artifacts

- `app/api/...`
- frontend runtime code
- `supabase/migrations/...`
- deployment configuration
- smoke scripts tied to live behavior

## 10. Review Rule

Before closing a round, confirm:

1. Was this change public-only, runtime-only, or dual-write?
2. Is the truth source clearly stated?
3. Is any repo now ahead of the other?
4. If yes, is that explicitly labeled as `contract-only` or `runtime-only`?
