environment-topology-v2.md

1. 文件目的

本文件定義 Lemma HR+ 當前正式採用的三層環境拓樸，作為後續 UI 語意、API rollout、seed 管理、帳號權限與部署策略的唯一架構依據。

本文件取代舊有「staging-first 但 UI/資料/部署語意混用」的暫時狀態，正式進入：
	•	demo
	•	staging
	•	production

三層明確分治。

⸻

2. 總覽

環境	性質	是否可寫	資料特性	主要用途
demo	敘事展示層	❌ 不可寫	固定 seed / 可重播	業務展示、教學、產品敘事
staging	驗證開發層	⚠️ 受控	可空、可最小 seed、可實驗	新功能驗證、API 串接、內部測試
production	正式營運層	✅ 嚴格控管	真實正式資料	客戶使用、正式寫入


⸻

3. 三層定義

3.1 Demo Environment

Demo 是「Narrative Layer」。

特性：
	•	只讀
	•	受保護 seed
	•	可 reset / replay
	•	不承接新功能實驗
	•	不允許一般測試資料混入

用途：
	•	對外展示
	•	業務簡報
	•	新成員教育
	•	固定產品故事驗證

原則：
	•	Demo 不等於 staging
	•	Demo 不等於 mock fallback
	•	Demo 必須獨立於 writable flow

⸻

3.2 Staging Environment

Staging 是「Validation Layer」。

特性：
	•	內部驗證主環境
	•	selected context / canonical API / 新模組先落這裡
	•	可 read-only、也可在受控條件下開 writable
	•	可為空環境，也可掛最小 seed
	•	必須受 beta lock / allowlist 管控

用途：
	•	開發驗證
	•	API / UI 對接
	•	smoke test
	•	內部夥伴試用

原則：
	•	staging 可以變動
	•	staging 不能替代 demo
	•	staging 不是 production 的直接同義詞

⸻

3.3 Production Environment

Production 是「Live Operations Layer」。

特性：
	•	僅承接已驗證穩定模組
	•	正式客戶資料
	•	正式寫入路徑
	•	嚴格 rollback 與 release 控管

用途：
	•	客戶正式使用
	•	穩定營運

原則：
	•	production 不接受未驗證模組直接進入
	•	不應與 demo/staging 共用語意
	•	必須有獨立部署、明確 runbook 與 rollback 策略

⸻

4. 當前系統現況（v2 起點）

目前 Railway 已建立三個 deployment environment：
	•	demo
	•	staging
	•	production

這代表 Lemma HR+ 正式具備三層部署拓樸，不再只是語意上的環境區分。

但各層完整度仍不同：

環境	部署狀態	說明
demo	已建立	待補 demo runtime / reset /驗證鏈
staging	已建立且主用	當前主要驗證環境
production	已建立	待逐模組正式承接


⸻

5. 資料層原則

5.1 Org / Company 分離

每個環境應對應獨立的 org / company 空間，不得混用。

5.2 Seed 分離

Seed 必須維持三層分離：
	•	base
	•	demo
	•	staging

Production 不應靠 seed 初始化業務資料。

5.3 Reset 分離
	•	demo：可 reset
	•	staging：可清理 / 重灌
	•	production：不得用 demo/staging reset 思維處理

⸻

6. 帳號與存取原則

6.1 Demo
	•	demo account
	•	read-only
	•	不進 writable pool

6.2 Staging
	•	beta lock / allowlist 控制
	•	分 read-only 與 writable 預備帳號
	•	writable 必須是顯式開通，不可隱式取得

6.3 Production
	•	僅正式授權帳號
	•	不共享 staging beta lock 邏輯

⸻

7. UI 顯示原則

7.1 UI 必須忠實反映真實環境

只有當 deployment / policy / data topology 真的對應時，UI 才能顯示該環境名稱。

7.2 過渡語意

在舊語意未完全清除前，可暫用 Primary 作為過渡 label，但最終目標是 UI 直接對齊：
	•	Demo
	•	Staging
	•	Production

⸻

8. 不可違反規則
	1.	不得將 demo 視為 staging 子集
	2.	不得將 staging 視為 production 別名
	3.	不得讓 production 承接未驗證模組
	4.	不得將 demo narrative seed 混入 staging
	5.	不得以 UI 文案取代真實 deployment 拓樸

⸻

9. 下一步
	1.	補 deployment-promotion-strategy-v1.md
	2.	驗證 demo environment 是否可承接 demo runtime
	3.	補 demo reset / verification checklist
	4.	將 staging 作為新功能唯一驗證入口
	5.	採模組白名單方式逐步推 production
