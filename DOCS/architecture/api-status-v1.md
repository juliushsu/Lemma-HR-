# API Status (v1)

## 已完成 canonical API

### HR
- /api/hr/employees
- /api/hr/attendance-logs
- /api/hr/attendance-summary
- /api/hr/org-chart

### Legal
- /api/legal/documents
- /api/legal/cases

### Leave（NEW）
- /api/hr/leave/requests
- /api/hr/leave/requests/:id
- approve / reject / cancel

狀態：
- staging：可用
- production：尚未 rollout

---

## 未完成 / 部分完成

- leave frontend adapter（未接）
- leave-policy（Supabase direct）
- attendance-sources（混合）
