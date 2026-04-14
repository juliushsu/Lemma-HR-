Demo Narrative Layer v1 (CTO 定版)

1. 文件目的

本文件定義 Lemma 系統中 Demo Layer（示範敘事層） 的正式定位、邊界與治理原則。

此文件屬於 CTO 層級的架構約束文件（Architectural Constraint Document），具有以下效力：
	•	作為 Demo 資料與行為的最高準則
	•	約束未來 seed、UI、API、reset 機制的設計方向
	•	防止 staging-first 演進過程中 Demo 層被侵蝕或誤用

⸻

2. Demo Layer 定義

Demo Layer = 可重現（replayable）、不可污染（immutable）、敘事驅動（narrative-driven）的產品展示環境

它不是測試資料，也不是 staging 的副本，而是：
	•	用於展示產品能力
	•	用於銷售與對外說明
	•	用於教育與 onboarding
	•	用於驗證完整產品流程（非單一 API）

⸻

3. 系統三層結構（現行架構）

層級	名稱	性質	是否可寫	是否有資料	用途
L1	Demo Layer	敘事層	❌ 不可寫（或受控寫入）	✅ 必須有	展示 / 教學 / Pitch
L2	Primary Layer（現 staging）	驗證層	⚠️ 受控（目前多為 read-only）	❌ 可為空	開發 / 串接驗證
L3	Production Layer（未完全啟用）	真實營運層	✅ 可寫	✅ 真資料	客戶使用


⸻

4. Demo Layer 核心特性

4.1 Immutable（不可污染）
	•	禁止任何一般使用者寫入
	•	不允許 staging / primary 操作影響 demo 資料
	•	所有變更必須透過：
	•	seed 重播
	•	或 controlled reset

⸻

4.2 Replayable（可重播）

Demo 必須能回到「標準故事狀態」，透過：
	•	seed 檔（source of truth）
	•	reset 機制（未來 function / script）

目標：

任意時間可將 demo 還原成「一致的展示狀態」

⸻

4.3 Narrative-driven（敘事驅動）

Demo 資料不是隨機，而是「有劇本的」。

每一組資料應對應一段產品能力，例如：
	•	HR onboarding 完整流程
	•	請假 → 審核 → 駁回案例
	•	法務風險管理案例
	•	出勤異常分析

⸻

5. Demo Seed 設計原則

5.1 必須符合
	•	有明確故事（誰、做什麼、發生什麼）
	•	可以完整跑一個流程（非孤立資料）
	•	不依賴 staging runtime 狀態

⸻

5.2 禁止事項
	•	❌ 不得將 staging 真資料 copy 進 demo
	•	❌ 不得使用隨機假資料填充
	•	❌ 不得混入 debug / 測試資料
	•	❌ 不得與 Primary Layer 共用 org / company

⸻

5.3 結構要求

Demo seed 必須：
	•	可獨立 replay
	•	不依賴外部狀態
	•	可被 reset script 完整覆蓋

⸻

6. Demo 與 Primary 的嚴格分離

6.1 組織層（Org / Company）
	•	Demo 必須使用獨立 org / company
	•	不得與 Primary 共用任何資料空間

⸻

6.2 Membership 層
	•	demo account（例：demo.admin@lemma.local）
	•	不應同時存在於 staging writable context

⸻

6.3 Context 層
	•	Demo context 必須被標記為：
	•	read_only_demo
	•	並在 backend 層強制禁止寫入

⸻

7. Demo Runtime 行為

7.1 Read 行為
	•	所有 read API 應可正常回傳資料
	•	不應出現空資料（除非該故事設計如此）

⸻

7.2 Write 行為
	•	一律禁止（或強制 reject）
	•	回傳明確錯誤（非 silent fail）

⸻

7.3 UI 行為
	•	必須明確標示為 Demo（避免誤判為真資料）
	•	未來應提供清楚的切換入口（Demo / Primary）

⸻

8. Demo Reset 機制（未完成項目）

未來必須補齊：

8.1 Reset Function

例如：
	•	reset_demo_org_v1()
	•	verify_demo_org_integrity_v1()

⸻

8.2 Reset 行為要求
	•	可完全覆蓋 demo 資料
	•	不影響 staging / primary
	•	可用於：
	•	demo 前重置
	•	QA 驗證
	•	銷售展示

⸻

9. 當前風險（CTO 判定）

目前 Demo Layer 狀態：
	•	✅ seed 存在
	•	✅ data topology 存在
	•	✅ API contract 存在
	•	⚠️ UI 切換入口未驗證
	•	⚠️ reset function 未落地
	•	⚠️ end-to-end demo 驗證未近期執行

判定：

Demo Layer 為「存在但未被 actively 驗證的狀態」

⸻

10. 強制約束（不可違反）

以下為 CTO 層級不可違反規則：
	1.	不得將 Demo 視為 staging 測試資料
	2.	不得將 Demo 與 Primary 合併
	3.	不得讓 Demo 被寫入污染
	4.	不得在未驗證 Demo 完整性前移除其 seed
	5.	不得讓 Demo 成為 fallback/mock 的替代品

⸻

11. 未來演進方向

Demo Layer 應隨產品成長：
	•	增加更多敘事模組（HR / Legal / AI / ESG）
	•	支援多故事版本（basic / advanced / enterprise）
	•	支援快速切換不同 demo scenario
	•	成為產品標準展示資產

⸻

12. 結語（CTO 指令）

Demo Layer 是：

產品的一部分，而不是測試副產品。

在 staging-first 架構下：
	•	Primary 是「可變動的實驗場」
	•	Demo 是「穩定的展示基準」

兩者必須同時存在，且嚴格隔離。
