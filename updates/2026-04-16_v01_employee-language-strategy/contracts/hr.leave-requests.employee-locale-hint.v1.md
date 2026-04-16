# hr.leave-requests.employee-locale-hint.v1

Status: public contract proposal  
Scope: leave employee-facing routes only  
Non-goals:
- no runtime implementation in this repo
- no display text translation
- no canonical enum changes

## Routes

- `POST /api/hr/leave-requests`
- `GET /api/hr/leave-requests`
- `GET /api/hr/leave-requests/:id`

## Contract Rule

All three routes should expose the same locale hint fields:

- `resolved_locale`
- `locale_source`

These fields are additive only.
They do not replace canonical keys already returned by leave APIs.

## Locale Source Allowlist

- `employee.preferred_locale`
- `user.locale_preference`
- `company.locale_default`
- `org.locale_default`
- `fallback.en`

## Canonical Key Rule

The following values must remain canonical keys:

- `leave_type`
- `status`
- `approval_status`
- `approval_steps[*].status`

The backend must not return localized display text such as:

- `年假`
- `病假`
- `已核准`

## Response Shape Examples

### List

```json
{
  "schema_version": "hr.leave_request_mvp.list.v1",
  "data": {
    "resolved_locale": "zh-TW",
    "locale_source": "employee.preferred_locale",
    "items": [
      {
        "id": "75a51706-ed2d-4bdf-b3d4-c8f5767c2b01",
        "status": "pending",
        "current_step": 0
      }
    ]
  },
  "error": null
}
```

### Create

```json
{
  "schema_version": "hr.leave_request_mvp.create.v1",
  "data": {
    "id": "75a51706-ed2d-4bdf-b3d4-c8f5767c2b01",
    "status": "pending",
    "current_step": 0,
    "approval_steps_count": 2,
    "resolved_locale": "zh-TW",
    "locale_source": "employee.preferred_locale"
  },
  "error": null
}
```

### Detail

```json
{
  "schema_version": "hr.leave_request_mvp.detail.v1",
  "data": {
    "id": "75a51706-ed2d-4bdf-b3d4-c8f5767c2b01",
    "leave_type": "annual_leave",
    "status": "pending",
    "current_step": 0,
    "resolved_locale": "zh-TW",
    "locale_source": "employee.preferred_locale",
    "approval_steps": [
      {
        "step_order": 0,
        "approver_employee_id": "70000000-0000-0000-0000-000000000002",
        "status": "pending"
      }
    ]
  },
  "error": null
}
```
