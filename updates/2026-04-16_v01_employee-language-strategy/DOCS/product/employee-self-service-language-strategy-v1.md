# Employee Self-Service Language Strategy v1
Lemma HR+ — CTO Canonical Document

---

## 1. 目標（Why）

本策略定義 Lemma HR+ 在「員工自助端（Employee Self-Service）」的語言設計原則。

核心目標：

1. 降低外籍員工教育訓練成本
2. 提升高頻操作（打卡 / 請假）的理解正確率
3. 支援多國籍勞動場景（台灣製造 / 倉儲 / 餐飲 / 照護）
4. 建立產品差異化（非僅 HR 可用，而是員工也易用）

---

## 2. 適用範圍（Scope）

本策略適用於「員工端」所有模組：

- 打卡（Attendance Check-in）
- 出勤狀況（Attendance Summary / Logs）
- 請假申請（Leave Request）
- 我的請假紀錄（My Leave Requests）
- 審批結果通知（Approval Result / Notifications）

不適用於：

- 管理端（Admin / HR / Finance / Governance）

---

## 3. 核心原則（Core Principles）

### 3.1 員工端：母語優先

所有員工端頁面必須優先使用員工母語顯示。

### 3.2 管理端：管理語言優先

HR / Admin 介面維持公司或管理者語言，不強制多語。

### 3.3 資料層禁止存 display text

所有資料庫與 API：

- 必須使用 **canonical key**
- 不得儲存多語文字

---

## 4. Locale Resolution Chain（語言決策鏈）

員工端語言解析順序如下：

	1.	employee.preferred_locale
	2.	user.locale_preference
	3.	company.locale_default
	4.	org.locale_default
	5.	system fallback (“en”)

說明：

| 層級 | 說明 |
|------|------|
| employee.preferred_locale | HR 設定之工作語言（最高優先） |
| user.locale_preference | 使用者偏好（未來擴充） |
| company.locale_default | 公司預設語言 |
| org.locale_default | 組織預設語言 |
| fallback | 系統保底 |

---

## 5. Supported Locales（v1）

支援語系（v1 allowlist）：

zh-TW
en
ja
th
vi
id
tl
my
hi

⚠️ 本輪僅作為 contract allowlist，不強制 DB constraint。

---

## 6. Canonical Key Strategy（關鍵設計）

### 6.1 Leave Types

```text
annual_leave
sick_leave
personal_leave
unpaid_leave
marriage_leave
bereavement_leave
maternity_leave
paternity_leave
```

### 6.2 Leave Status

```text
draft
submitted
pending
approved
rejected
cancelled
```

### 6.3 Attendance

```text
check_in
check_out

on_time
late
absent
leave
```

### 6.4 原則

- DB 存 key
- API 回 key
- Frontend 負責翻譯

---

## 7. API Contract 原則

### 7.1 Backend 不做翻譯

API response 範例：

```json
{
  "leave_type": "annual_leave",
  "status": "pending"
}
```

❌ 不可：

```json
{
  "leave_type": "年假"
}
```

### 7.2 Employee-facing API 可帶 locale hint

建議：

```json
{
  "resolved_locale": "vi",
  "locale_source": "employee.preferred_locale"
}
```

### 7.3 Leave employee-facing implementation slice（public contract only）

本輪只定義 leave employee-facing routes 的 contract，不宣稱 runtime 已實作。

適用 route：

- `POST /api/hr/leave-requests`
- `GET /api/hr/leave-requests`
- `GET /api/hr/leave-requests/:id`

對齊原則：

- 三支 route 都應回：
  - `resolved_locale`
  - `locale_source`
- 既有 canonical keys 維持不變
- 不回本地化 display text
- 不新增 display-only enum

`locale_source` allowlist：

- `employee.preferred_locale`
- `user.locale_preference`
- `company.locale_default`
- `org.locale_default`
- `fallback.en`

list response sample：

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

create response sample：

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

detail response sample：

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

注意：

- `leave_type` 仍為 canonical key，例如 `annual_leave`
- `status` 仍為 canonical key，例如 `pending`
- `approval_steps[*].status` 仍為 canonical key
- 顯示文字由 frontend i18n 層處理

## 8. Frontend Strategy

### 8.1 使用 useEmployeeLocale()

統一取得語言：

```ts
const locale = useEmployeeLocale();
const t = i18n.getFixedT(locale);
```

### 8.2 獨立 namespace

員工端使用：

```text
selfService.*
leave.*
attendance.*
```

避免與 admin 共用語氣。

---

## 9. Phase Rollout

Phase 1（本輪）
	•	建立 language strategy
	•	建立 useEmployeeLocale()
	•	/hr/leave-requests 導入

Phase 2
	•	attendance 模組導入
	•	將 leave locale hint contract 接入 runtime repo

Phase 3
	•	通知系統（LINE / Email / Push）
	•	多語完整覆蓋

---

## 10. 不在本輪處理（Out of Scope）
	•	全語系翻譯完成
	•	管理端多語
	•	DB constraint 強制 locale
	•	AI 自動翻譯

---

## 11. 成功標準（Success Criteria）
	•	員工可用母語完成請假申請
	•	無需教育訓練即可理解狀態
	•	HR 不需解釋假別差異
	•	API / DB 不含 display text

---

## 12. CTO 結語

本策略是 Lemma HR+ 核心產品差異之一。

請務必遵守：

「資料 canonical，語言在前端解析」

避免未來出現多語混亂與維護災難。

---
