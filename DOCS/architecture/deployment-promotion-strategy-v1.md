deployment-promotion-strategy-v1.md

1. 文件目的

本文件定義 Lemma HR+ 在 demo / staging / production 三層環境下的部署推進策略（promotion strategy），避免新功能直接跨層進入正式環境。

⸻

2. 基本原則

2.1 Demo 不追新

Demo 只承接：
	•	已穩定功能
	•	已確認的展示故事
	•	可重播 seed

Demo 不應自動跟隨 staging 最新改動。

⸻

2.2 Staging 先行

所有新功能、API、context、UI 對接，必須先在 staging 完成：
	•	route 存在
	•	response shape 穩定
	•	read path 驗證通過
	•	write path 風險可控

⸻

2.3 Production 漸進承接

Production 不做整包升級，而採「模組白名單 promotion」：
	•	Employee
	•	Attendance
	•	Leave
	•	Legal
	•	Settings
	•	Portal

應逐模組決定是否成熟可上。

⸻

3. Promotion 流程

3.1 Code 流
	1.	功能在 local / sandbox 完成
	2.	進 staging deploy
	3.	跑 staging smoke
	4.	確認 read path / context / auth / fallback 行為
	5.	決定是否：
	•	進 demo
	•	進 production
	•	留在 staging 繼續驗證

⸻

3.2 Demo Promotion

條件：
	•	故事完整
	•	資料可 replay
	•	UI 穩定
	•	不需 writable
	•	不依賴不穩定 API

⸻

3.3 Production Promotion

條件：
	•	staging 已穩定
	•	具 rollback 方案
	•	具 production runbook
	•	資料行為可預測
	•	權限與寫入風險已驗證

⸻

4. 各層允許的內容

類型	Demo	Staging	Production
新功能實驗	❌	✅	❌
API shape 驗證	❌	✅	⚠️ 僅已穩定
敘事 seed	✅	⚠️ 最小 seed	❌
真實客戶寫入	❌	❌/受控	✅
fallback/mock 主鏈	❌	⚠️ 過渡期可見	❌


⸻

5. Deployment 策略

5.1 Demo
	•	建議手動 promote
	•	建議只從穩定 tag 或穩定 commit 部署
	•	不與 staging 自動同步

5.2 Staging
	•	作為主要集成與驗證環境
	•	允許快速 redeploy
	•	允許 canonical route 先落地

5.3 Production
	•	嚴格控管
	•	不得承接未 smoke 的模組
	•	需有 deployment / rollback runbook

⸻

6. 當前建議順序

當前優先級
	1.	demo verification
	2.	staging read-only validation
	3.	最小 staging seed（必要時）
	4.	模組化 production promotion

⸻

7. 當前不建議
	1.	不要讓 demo 與 staging 共用相同 rollout 節奏
	2.	不要讓 production 直接承接 staging 全量功能
	3.	不要在未完成 gating / writable 設計前開放 production 寫入

⸻

8. 模組 promotion 建議

第一梯隊
	•	/api/me
	•	Employee list / detail
	•	Org chart
	•	Attendance logs / summary

第二梯隊
	•	Leave list / detail（read-only 先）
	•	Legal documents / cases

第三梯隊
	•	Leave writable
	•	Attendance sources settings
	•	進一步 workflow 模組

⸻

9. 結語

Lemma HR+ 的部署不應再是單一路徑，而是：
	•	Demo：穩定展示
	•	Staging：快速驗證
	•	Production：漸進承接

這是當前最適合此專案成熟度的 promotion 策略。
