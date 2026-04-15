preview-context-override-v1.md

1. 文件目的

本文件定義 Lemma HR+ 在 preview 與 first-party 兩種前端驗證模式下的 context 行為策略，目的在於：
	•	讓 readdy.ai 預覽環境可進行 UI 與 read-only smoke 驗證
	•	不因第三方 cookie / cross-origin 限制而阻塞開發流程
	•	不污染正式的 selected-context contract
	•	明確區分 preview 驗證與正式站驗證責任

本文件屬於架構約束文件，優先級高於單次實作 workaround。

⸻

2. 問題背景

Lemma 現有正式 selected-context contract 採用：
	1.	POST /api/session/context
	2.	backend 寫入 lemma_selected_membership_id cookie
	3.	GET /api/me 讀取 cookie，回傳 current_context

這套 contract 在同站或第一方網域情境下可成立。
但在 readdy.ai 預覽環境中，前端與 API 屬於 cross-site：
	•	前端：https://readdy.ai
	•	API：https://<railway-domain>.up.railway.app

在此情境下，第三方 cookie 可能被瀏覽器限制或不穩定處理，因此：

readdy.ai 不應作為 cookie-based selected-context persistence 的最終驗證場。

⸻

3. 核心決策

Lemma 採用 雙模式 context 驗證架構：

3.1 First-Party Mode（正式模式）
	•	適用於：
	•	lemmahr.com
	•	未來同站 staging frontend
	•	其他第一方或同主網域前端
	•	採用正式 contract：
	•	POST /api/session/context
	•	cookie persistence
	•	GET /api/me
	•	可作為 selected-context 最終驗證場

⸻

3.2 Preview Mode（預覽模式）
	•	適用於：
	•	readdy.ai
	•	*.readdy.ai
	•	其他被明確允許的 preview origin
	•	不依賴 cookie persistence
	•	不使用 POST /api/session/context 作為當前 workspace 切換依據
	•	改採 request-scoped context override：
	•	x-preview-context
	•	或 _preview_ctx（若保留 query 兼容）

⸻

4. Preview Mode 定義

4.1 Preview Mode 的角色

Preview 只用於：
	•	UI smoke
	•	API contract smoke
	•	read-only context 切換驗證
	•	非持久狀態下的畫面與資料 scope 驗證

Preview 不用於：
	•	cookie persistence 最終驗證
	•	writable 驗證
	•	selected-context 正式驗證
	•	security boundary 最終驗證

⸻

4.2 Preview Mode 的設計原則
	1.	不寫 cookie
	2.	不更動正式 selected-context persistence
	3.	只對單次 request 生效
	4.	只允許 read-only
	5.	必須可關閉
	6.	不得被 production 視為正式 contract

⸻

5. Preview Context Override Contract

5.1 Header-based override（首選）

Preview 前端可在 request 中帶：

x-preview-context: <membership_id>

backend 在符合 preview 條件時，將該 membership 當作當次 request 的 request-scoped context。

⸻

5.2 Query-based override（可選、非首選）

若歷史相容需要，可保留：

_preview_ctx=<membership_id>

但此方式應視為次要兼容，不應成為主要正式文件推薦方案。

⸻

5.3 生效條件

Preview override 僅在以下條件之一成立時可生效：
	•	request Origin 屬於被允許的 preview origin
	•	或環境變數 ALLOW_PREVIEW_CONTEXT_OVERRIDE=true

若不符合條件，backend 應忽略 preview override，回到正式 context resolve 流程。

⸻

6. Preview Override 的安全邊界

6.1 強制 read-only

在 preview mode 下，所有 context 都應視為：
	•	writable = false

即使 target membership 在正式環境中具備 writable 權限，在 preview request 中也不得承接寫入能力。

⸻

6.2 明確禁止的操作

Preview override 不得用於：
	•	create
	•	update
	•	delete
	•	approve / reject / cancel
	•	upload / import
	•	webhook / inbound ingestion
	•	/api/session/context 自身

這些操作若在 preview 情境下被呼叫，應回：
	•	403
	•	明確錯誤碼，例如 PREVIEW_READ_ONLY

⸻

6.3 Preview 不可提升權限

x-preview-context 只能在使用者原本可讀的 membership 範圍內切換。
不得因 preview override 而產生越權讀取。

⸻

7. 與正式 contract 的關係

7.1 正式 contract 保持不變

以下仍為正式 selected-context 標準：
	1.	POST /api/session/context
	2.	Set-Cookie: lemma_selected_membership_id
	3.	GET /api/me 讀回 current_context

⸻

7.2 Preview contract 不可取代正式 contract

Preview override 只是開發與驗證輔助機制，不可：
	•	被正式站依賴
	•	被文件誤寫成 selected-context 正式標準
	•	取代 first-party persistence 驗證

⸻

8. 建議的 backend 實作邊界

8.1 最小接入點

backend 最小 patch 應集中於：
	•	app/api/_selected_context.ts
	•	HR / Legal 共用 scope resolver
	•	GET /api/me

而不是全面重構所有 route。

⸻

8.2 Route 支援範圍

Preview override 應先支援：
	•	GET /api/me
	•	HR read routes
	•	Legal read routes
	•	必要的 Portal / read-only summary routes

不應先擴到 mutation 或 persistence 類 route。

⸻

9. 建議的 frontend 實作邊界

9.1 Preview 模式下

前端切換 context 時：
	•	不呼叫 POST /api/session/context
	•	只更新 preview-local selected membership
	•	後續 request 自動帶 x-preview-context
	•	重新抓取 GET /api/me

⸻

9.2 非 Preview 模式下

維持正式鏈：
	•	POST /api/session/context
	•	cookie persistence
	•	GET /api/me

⸻

10. 環境變數建議

建議引入以下環境變數：

10.1 ALLOW_PREVIEW_ORIGIN

指定允許 preview override 的 origin，例如：

https://readdy.ai


⸻

10.2 ALLOW_PREVIEW_CONTEXT_OVERRIDE

布林值：
	•	true：允許 preview override
	•	false：完全關閉 preview override

⸻

10.3 PREVIEW_FORCE_READ_ONLY

布林值：
	•	true：preview 一律 read-only
	•	false：不建議在現階段使用

⸻

11. CORS 與 Header 要求

若 preview override 走 header，backend 必須允許：
	•	x-preview-context

CORS 設定需包含：
	•	Access-Control-Allow-Origin: <exact origin>
	•	Access-Control-Allow-Credentials: true
	•	Access-Control-Allow-Headers 包含 x-preview-context

⸻

12. 驗證責任分界

12.1 在 Preview 可驗的項目
	•	UI 是否隨 context 改變
	•	GET /api/me 是否回正確 current_context
	•	HR / Legal read routes 是否跟著 context 改變
	•	preview mutation 是否被正確阻擋

⸻

12.2 不應在 Preview 驗的項目
	•	cookie persistence
	•	selected-context 真正持久化
	•	writable 安全性
	•	正式站 rollout 行為
	•	production 級 session 驗證

⸻

12.3 應在 First-Party 驗的項目
	•	POST /api/session/context
	•	cookie persistence
	•	refresh 後 context 是否維持
	•	writable boundary
	•	final acceptance

⸻

13. 不可違反規則
	1.	不得為了 preview 而改壞正式 selected-context contract
	2.	不得把 preview override 文件寫成正式標準
	3.	不得讓 preview 成為 writable
	4.	不得讓 preview override 越權讀取
	5.	不得以 preview 驗證結果取代正式站驗證結果

⸻

14. 當前執行策略

目前建議採：

Phase 1
	•	frontend preview patch
	•	backend preview read-only override
	•	HR / Legal read path 驗證

Phase 2
	•	demo runtime 救回
	•	preview 用於 demo UI / narrative smoke

Phase 3
	•	first-party staging frontend 驗 selected-context persistence
	•	再談 writable acceptance

⸻

15. 結語

Preview 不是正式站，也不應被強行修成正式站。

正確策略是：

讓 Preview 成為受控的 read-only context 驗證場，
讓 First-Party 成為 selected-context 最終驗證場。

這樣才能同時維持：
	•	開發流程順暢
	•	正式 contract 不被污染
	•	環境治理清楚
