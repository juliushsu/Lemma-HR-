demo-layer-verification-checklist-v1.md

1. 文件目的

本文件定義 Lemma HR+ Demo Layer 的驗證清單，目的不是測試新功能，而是確認：
	•	Demo 層仍存在
	•	Demo seed 仍可被正確讀取
	•	Demo account / membership / context 仍可進入
	•	Demo 仍維持 read-only protected narrative layer
	•	Demo 不被 staging-first 改造意外破壞

⸻

2. 驗證範圍

本清單只驗證 Demo Layer，不驗證：
	•	staging writable
	•	production rollout
	•	新功能開發進度
	•	performance optimization

⸻

3. 驗證前提

在執行本清單前，應確認：
	1.	demo environment 已存在於 Railway
	2.	demo org / company / membership 已存在
	3.	demo seed 已存在於 repo 的 supabase/seeds/demo/
	4.	demo account 可登入
	5.	demo context 應為 read-only

⸻

4. 驗證目標

Demo 驗證必須回答五個問題：
	1.	Demo account 能否進入 Demo context？
	2.	Demo 主要故事模組是否有資料？
	3.	Demo 是否明確與 Primary / staging 分離？
	4.	Demo 是否確實不可寫？
	5.	Demo 是否仍可作為展示敘事層？

⸻

5. 驗證帳號

建議主驗帳號：
	•	demo.admin@lemma.local

如有其他 demo reviewer 帳號，應另列於 access matrix，但不應與 staging beta lock 名單混用。

⸻

6. 驗證步驟

⸻

Step A — 確認 Demo context 可進入

A-1. 登入
使用 demo account 登入。

A-2. 檢查 /api/me
確認 response 具備 demo context，至少應能辨識：
	•	environment_type = demo
	•	或 access_mode = read_only_demo
	•	current org / company 為 demo 對應空間

A-3. 若系統支援 selected context
確認可切換到 demo membership，且切換後：
	•	current_context 正確
	•	current_org / current_company 對應 demo

驗證結果
	•	✅ Pass：可進入 demo context
	•	❌ Fail：無法切入 demo，或被誤導到 Primary / staging

⸻

Step B — 驗證 Demo 與 Primary / staging 分離

確認畫面與 API 不會混入其他環境資料。

檢查項目
	•	org 名稱是否為 demo 專用
	•	company 名稱是否為 demo 專用
	•	不是 Primary / staging org
	•	不會顯示 staging 內部空資料頁

驗證結果
	•	✅ Pass：資料明顯屬於 demo 敘事層
	•	❌ Fail：混到 staging 或顯示空驗證頁

⸻

Step C — 驗證 HR 敘事資料

C-1. 員工名單
頁面：
	•	/hr/employees

確認：
	•	不為空
	•	至少有 demo 員工資料
	•	不是 fallback/mock 的臨時假資料

C-2. 組織圖
頁面：
	•	/hr/org-chart

確認：
	•	有部門 / 職位 / 上下層結構
	•	非空白頁
	•	非 error state

C-3. 出勤相關
頁面：
	•	/hr/attendance-logs
	•	/hr/attendance-summary

確認：
	•	有 demo attendance 基線資料
	•	非 0 筆且非 placeholder

驗證結果
	•	✅ Pass：HR 基礎敘事完整
	•	❌ Fail：空頁、error、或資料缺漏

⸻

Step D — 驗證 Onboarding 敘事資料

頁面：
	•	/hr/onboarding

確認：
	•	有 demo onboarding invitation / stage 資料
	•	可看到流程進度、狀態、或至少一筆可說故事的案例
	•	非完全空白頁

驗證結果
	•	✅ Pass：onboarding narrative 可展示
	•	❌ Fail：沒有資料或無法讀取

⸻

Step E — 驗證 Leave 敘事資料（若已接 demo runtime）

頁面：
	•	/hr/leave
	•	/hr/leave-policy

確認：
	•	至少有可展示的請假 / 規則敘事
	•	不應只是 Primary 的空驗證頁
	•	若目前 canonical route 尚未接入 demo，可標記為「待補」

驗證結果
	•	✅ Pass：可展示 leave 敘事
	•	⚠️ Partial：資料存在但路徑未完整
	•	❌ Fail：完全不可讀

⸻

Step F — 驗證 Legal / LC+ 敘事資料

頁面：
	•	/legal
	•	/legal/contracts
	•	/legal/cases

確認：
	•	有 legal documents / case narrative
	•	至少一頁可被展示
	•	非 placeholder

驗證結果
	•	✅ Pass：legal narrative 存在
	•	❌ Fail：資料缺失或 route 不通

⸻

Step G — 驗證 Demo 為 read-only

這是最重要的保護驗證。

操作
嘗試：
	•	新增員工
	•	修改資料
	•	審批流程
	•	提交表單

預期
	•	明確 disabled
	•	或後端拒絕
	•	或顯示 read-only 提示

驗證結果
	•	✅ Pass：寫入被阻擋
	•	❌ Fail：demo 可寫

⸻

Step H — 驗證 Demo 非 fallback/mock 假象

確認 demo 不是因為錯誤才 fallback 出來的假資料。

檢查
	•	是否有「示範資料 — 無法連線資料庫」這類 fallback banner
	•	是否是靜態 placeholder
	•	是否 API 正常讀取 demo context 資料

驗證結果
	•	✅ Pass：是真正的 demo narrative data
	•	❌ Fail：只是 mock / fallback 假象

⸻

7. 驗證結果分類

A. 完整可用

Demo context 可進、故事資料完整、read-only 正確、可作展示。

B. 部分可用

Demo 仍存在，但有部分模組缺資料或尚未接好。

C. 不可用

無法切入 demo、主要故事模組為空、或 demo 可寫。

⸻

8. 最低通過標準（Minimum Pass Criteria）

要判定 Demo Layer 為「仍可用」，至少必須同時滿足：
	1.	Demo context 可進入
	2.	HR 基礎資料非空
	3.	至少一條 onboarding / legal 敘事可展示
	4.	demo 明確不可寫
	5.	非 fallback/mock 假象

若未達成以上條件，應判定：

Demo Layer 存在於 repo，但尚未通過 runtime 驗證

⸻

9. 驗證後續動作

若通過
	•	保持 demo seed 為 protected replay only
	•	可進一步補 demo reset function
	•	可開始規劃 demo UI 切換入口

若部分通過
	•	補齊缺漏模組
	•	修正 route / context / data source
	•	再跑一次 checklist

若失敗
	•	立即停止 Primary 最小 seed 規劃
	•	先修 demo 層完整性
	•	避免 Demo Layer 在 staging-first 演進中失活

⸻

10. 建議紀錄格式

每次驗證建議輸出：
	•	驗證日期
	•	驗證環境
	•	驗證帳號
	•	通過頁面
	•	失敗頁面
	•	是否有寫入風險
	•	是否仍可作為業務展示層
