# Lemma HR+ — Data Source Status (v1)

## 說明
目前系統存在兩條資料鏈路：
- Railway API（canonical backend）
- Supabase direct（部分模組暫用）

---

## ✅ 可作 read-only 驗收頁（live API）

- /hr/employees
- /hr/attendance-logs
- /hr/attendance-summary
- /legal
- /legal/contracts
- /legal/cases

---

## ⚠️ 條件性（依 Railway 是否回資料）

- /hr/org-chart
- /settings/attendance-sources/*

---

## ❌ 暫不可驗收（仍 fallback/mock）

- /hr/leave（前端尚未接 canonical API）
- /hr/leave-policy（Supabase org_id 問題）
- /legal/access-logs（placeholder）

---

## 🔄 /hr/leave 狀態

- backend：已完成 canonical API
- frontend：尚未接
- fallback：目前仍顯示示範資料
- next step：接 `/api/hr/leave/requests`

---

## ⚠️ 注意

Production 環境 ≠ 每個頁面都是 live DB

部分頁面仍為：
- integration-ready
- fallback mock
