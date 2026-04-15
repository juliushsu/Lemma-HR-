Railway Environment Responsibility Matrix v1

⸻

1. 目的（Purpose）

本文件定義 Lemma HR+ 在 Railway 上之多環境（multi-environment）架構責任分界，確保：
	•	preview（Readdy）開發不污染正式資料鏈
	•	selected-context 驗證具備一致性與可信度
	•	demo / staging / production 各自職責明確
	•	避免「修好 preview → 壞 production」的情況

⸻

2. 環境總覽（Environment Overview）

Environment	Domain（預期）	用途	是否允許寫入
demo	demo.lemmahr.com（或內部 URL）	展示 / 業務 Demo	❌ 不允許
staging	staging.lemmahr.com / Railway staging URL	功能驗證 / QA / preview backend	⚠️ 有條件允許
production	lemmahr.com	正式營運環境	✅ 允許


⸻

3. 核心設計原則（Core Principles）

3.1 單一真源（Single Source of Truth）

Preview 正規讀鏈（Preview Read Chain）
	•	Railway backend（staging）
	•	x-preview-context / _preview_ctx
	•	request-scoped override
	•	不寫 cookie
	•	read-only

正式鏈（First-Party Chain）
	•	POST /api/session/context
	•	cookie-based persistence
	•	authoritative session context

⸻

3.2 Preview 與正式鏈完全隔離

項目	Preview	Production
context 切換	x-preview-context	/api/session/context
persistence	❌ 無	✅ cookie
writable	❌ false	✅ 依角色
資料可信度	測試用	正式


⸻

3.3 不允許雙資料鏈（No Dual Provider）

任何「需要驗證 selected-context」的頁面：

❌ 禁止：
	•	Railway + Edge Function 混用
	•	silent fallback 到另一條鏈
	•	request A 用 Railway、request B 用 Supabase

✅ 必須：
	•	單一 provider（Railway）
	•	同一條 request chain

⸻

4. 三環境責任分界（Responsibility Matrix）

4.1 Demo Environment

用途：
	•	對外展示
	•	穩定資料
	•	Demo 故事演示

規則：
	•	固定 seed data
	•	不追新 schema
	•	不驗 selected-context
	•	強制 read-only

適用對象：
	•	客戶
	•	投資人
	•	業務展示

⸻

4.2 Staging Environment（核心）

用途：
	•	preview backend
	•	selected-context 驗證
	•	新功能 QA

規則：

Preview 模式（來自 readdy.ai）
	•	使用 x-preview-context
	•	強制：
	•	writable = false
	•	mutation → PREVIEW_READ_ONLY
	•	不寫 cookie

First-party 模式（直接打 staging domain）
	•	使用 /api/session/context
	•	驗 cookie persistence
	•	可驗 writable

⸻

4.3 Production Environment

用途：
	•	正式使用
	•	使用者操作
	•	真實資料

規則：
	•	僅允許已驗證功能
	•	不允許 preview override
	•	不允許 demo fallback
	•	嚴格 RBAC + RLS

⸻

5. Preview（Readdy）行為定義

5.1 Preview 判斷條件

hostname === "readdy.ai"
|| hostname.endsWith(".readdy.ai")


⸻

5.2 Preview request 規則
	•	所有 request：
	•	必須打 Railway staging backend
	•	帶：

x-preview-context: <membership_id>


	•	禁止：
	•	呼叫 /api/session/context
	•	使用 cookie
	•	呼叫 production backend

⸻

5.3 Preview 限制

行為	結果
POST / PATCH / DELETE	403 PREVIEW_READ_ONLY
cookie persistence	❌
writable	永遠 false


⸻

6. Selected Context 驗證流程

6.1 Preview 驗證（Readdy）

只驗：
	1.	GET /api/me
	•	current_context.membership_id 改變
	2.	GET /api/hr/employees
	•	scope 改變
	•	debug headers 改變
	3.	UI 是否反映

⸻

6.2 Staging First-party 驗證

驗：
	1.	POST /api/session/context
	2.	Set-Cookie
	3.	GET /api/me
	4.	context persistence（refresh 後是否維持）

⸻

6.3 Production 驗證

驗：
	•	RBAC
	•	writable
	•	真實使用流程
	•	multi-tenant isolation

⸻

7. 關鍵頁面規範（Critical Routes）

以下頁面必須只走 Railway backend：
	•	/api/me
	•	/api/hr/employees
	•	/api/hr/org-chart
	•	/api/legal/documents
	•	/api/legal/cases

規則：
	•	單一資料來源
	•	不 fallback
	•	failure 必須可見（error state）

⸻

8. 禁止事項（Anti-Patterns）

❌ Preview fallback：

try {
  railway()
} catch {
  supabase()
}

❌ 雙 provider：

const dataA = await railway()
const dataB = await edge()
merge(dataA, dataB)

❌ fake persistence：
	•	localStorage 當 context source
	•	UI state override backend truth

⸻

9. 建議環境變數（Env Design）

Staging

APP_ENV=staging
ALLOW_PREVIEW_ORIGIN=https://readdy.ai
ALLOW_PREVIEW_CONTEXT_OVERRIDE=true
PREVIEW_FORCE_READ_ONLY=true

Production

APP_ENV=production
ALLOW_PREVIEW_CONTEXT_OVERRIDE=false

Demo

APP_ENV=demo
FORCE_READ_ONLY=true
USE_DEMO_DATA=true


⸻

10. 未來擴展（Future Considerations）
	•	preview 可擴展至：
	•	portal
	•	settings
	•	system
	•	multi-tenant isolation 加強：
	•	audit log
	•	context switch trace
	•	feature flags：
	•	rollout 控制 staging → production

⸻

11. 一句話總結

Preview 是「讀測試」，Staging 是「驗機制」，Production 是「跑真實」。
三者不可混用，selected-context 只能有一條真源。
