# Lemma Document Flow And Git Sync Rules v1

Status: contract-only  
Scope: public docs/contracts repo governance  
Non-goals:
- does not claim runtime implementation
- does not replace runtime deploy/runbooks
- does not replace PR review judgment

## 1. Purpose

This document exists to prevent collaboration drift across:

- local-only edits that never reach GitHub
- docs being updated while UI still follows old assumptions
- contract changes being made without runtime alignment
- unclear truth sources between chat, local files, and GitHub

## 2. Role Split

### juliushsu

Responsible for:

- defining round goal
- defining priority and allowed scope
- deciding whether to merge
- deciding which document becomes formal source of truth

### CTO

Responsible for:

- reading both Readdy and Codex status
- converging official spec, responsibility split, and success criteria
- deciding truth source and reporting format
- reviewing structural drift and contract drift

### Readdy

Responsible for:

- UI
- page flow
- user interaction
- i18n presentation

Rules:

- must not define formal contract alone
- must implement against formal docs and canonical responses
- should report mainly on visible UI and data flow behavior

### Codex

Responsible for:

- docs
- contracts
- update packs
- backend contract alignment
- runtime repo implementation when a runtime repo is explicitly in scope

Rules:

- every document change must go through Git flow
- work must not stop at local-only edits

## 3. Repo Split

### A. Public docs/contracts repo

Primary use:

- `DOCS`
- `contracts`
- architecture documents
- update packs
- sample spec
- product proposals

This repo is the long-term public knowledge layer.

### B. Runtime repo

Primary use:

- `app/api`
- migrations
- frontend runtime code
- deployable code
- Railway/staging/production integration

This repo is the executable implementation layer.

## 4. Truth Source Rules

### Document truth source

Formal document truth is the pushed GitHub version.

Not truth source:

- chat text
- local files that are not committed/pushed
- screenshots

### Contract truth source

Formal contract truth comes from:

- public repo `DOCS`
- public repo `contracts`

Runtime repo must align to them and must not silently drift.

### UI truth source

UI truth comes from:

- runtime implementation
- confirmed contract

Readdy must not invent payload shape.

## 5. Mandatory Codex Git Sync Flow

Every Codex document round must explicitly report:

1. repo path
2. branch name
3. `git status --short`
4. whether the work is committed
5. commit hash
6. whether the work is pushed
7. pushed branch name
8. PR title draft
9. PR summary draft

If any item is missing, the Git sync is incomplete.

## 6. File Placement Rules

Formal documents belong in:

- `DOCS/product/...`
- `DOCS/architecture/...`
- `contracts/...`

Update packs belong in:

- `updates/YYYY-MM-DD_<name>/...`

Update pack purpose:

- handoff to runtime repo
- portability to other projects
- preservation of the current implementation slice

## 7. Readdy Reporting Rules

Each Readdy round should report:

1. modified files
2. visible UI changes
3. which hardcoded strings were removed
4. how the UI aligns with backend contract
5. build result

Readdy must not unilaterally declare:

- contract is established
- backend is ready
- staging truth is proven

unless confirmed by Codex or juliushsu.

## 8. CTO Convergence Rules

Before each round, define:

1. the single truth source for the round
2. what is out of scope
3. what counts as success
4. the fixed reporting format

Without these four items, collaboration loops become likely.

## 9. Cross-Repo Alignment Rules

If public repo docs are updated but runtime repo is not yet implemented:

- label the result as `contract-only`
- do not claim deployed
- do not claim live
- do not treat doc completion as runtime completion

If runtime repo is implemented but public repo is not updated:

- public docs/contracts must be updated
- code-only completion is not enough

## 10. Branch Rules

Codex may work only on:

- `codex/*`

`main`:

- no direct push
- PR required

Document changes also follow branch + commit + push.

## 11. Minimum PR Content

Each PR should include:

### Title

Examples:

- `docs: define leave employee locale hint contract slice`
- `feat(leave): add self-service leave entry`
- `fix(org-chart): correct reporting line join keys`

### Summary

Must state:

- what changed
- which contracts are affected
- whether deploy happened
- whether canonical keys changed
- what follow-up remains

## 12. Document Status Labels

Recommended status labels:

- `proposal`
- `contract-only`
- `implemented`
- `runtime-aligned`
- `deprecated`

This allows fast recognition of maturity.

## 13. Supabase Collaboration MVP Positioning

Supabase collaboration MVP should be retained, but downgraded in responsibility.

Recommended role:

- task intake
- bug tracking
- validation log
- decision log
- smoke checklist
- release note ledger

It should not be the final truth source for:

- formal contracts
- formal code status
- formal document truth

Recommended positioning:

- Supabase collaboration MVP = project ops ledger
- public GitHub repo = docs/contracts truth source
- runtime repo = deployable implementation truth source

## 14. Portability

This rule set is intentionally portable to other projects.

Recommended reusable companion templates:

- `Project Document Flow And Git Sync Rules v1`
- `Project Repo Responsibility Matrix v1`
- `Project AI Collaboration Task Template v1`
