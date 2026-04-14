# auth.me.v2

## Purpose

Define the contract baseline for explicit environment switching and selected context. This is a documentation-first contract and does not imply that runtime implementation is complete yet.

## Why v2 Exists

`auth.me.v1` is sufficient for a single effective membership, but it is not a safe long-term contract once one user can access both:

- `lemma-demo`
- `lemma-staging-write`

The contract must stop implying that the first membership is the active context.

## Response Shape

```json
{
  "schema_version": "auth.me.v2",
  "data": {
    "user": {},
    "memberships": [],
    "available_contexts": [],
    "current_context": null,
    "current_org": null,
    "current_company": null,
    "locale": "en",
    "environment_type": "production"
  },
  "meta": {
    "request_id": "uuid",
    "timestamp": "iso_datetime"
  },
  "error": null
}
```

## Context Object

```json
{
  "membership_id": "uuid",
  "org_id": "uuid",
  "org_slug": "lemma-demo",
  "org_name": "Lemma Demo",
  "company_id": "uuid",
  "company_name": "Lemma Demo Company",
  "role": "viewer",
  "scope_type": "company",
  "environment_type": "demo",
  "access_mode": "read_only_demo",
  "writable": false,
  "is_default": false
}
```

## Required Rules

- `memberships` is the raw list of granted memberships
- `available_contexts` is the normalized list the frontend may switch into
- `current_context` is the authoritative runtime context
- `current_org` and `current_company` should reflect `current_context`, not incidental ordering
- `environment_type` should reflect `current_context`

## Compatibility Guidance

- Existing clients may continue consuming `auth.me.v1`
- New environment-switch UI should target `auth.me.v2`
- No client should assume `memberships[0]` is the active workspace

## Proposed Companion Endpoint

### `POST /api/session/context`

Request:

```json
{
  "membership_id": "uuid"
}
```

Response:

```json
{
  "schema_version": "auth.session.context.v1",
  "data": {
    "current_context": {
      "membership_id": "uuid",
      "org_id": "uuid",
      "company_id": "uuid",
      "environment_type": "sandbox",
      "access_mode": "sandbox_write",
      "writable": true
    }
  },
  "meta": {
    "request_id": "uuid",
    "timestamp": "iso_datetime"
  },
  "error": null
}
```

