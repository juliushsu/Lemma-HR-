# Lemma-HR-
lemma-hr/
├─ app/                         # Next app / route handlers / BFF
├─ components/                  # 若目前已在 app 內，可先不硬拆
├─ src/                         # 若既有前端主要在 src，先保留現況
├─ contracts/                   # DTO / API shape / canonical contracts
├─ docs/
│  ├─ architecture/
│  ├─ product/
│  ├─ runbooks/
│  ├─ decisions/
│  └─ changelogs/
├─ supabase/
│  ├─ migrations/
│  ├─ policies/
│  ├─ seeds/
│  │  ├─ base/
│  │  ├─ demo/
│  │  └─ staging/
│  └─ functions/
├─ scripts/
│  ├─ seed_demo_reset.sh
│  ├─ seed_staging_write.sh
│  ├─ verify_demo_integrity.sh
│  └─ check_contracts.sh
├─ tests/
│  ├─ smoke/
│  ├─ integration/
│  └─ fixtures/
├─ .github/
│  ├─ pull_request_template.md
│  └─ workflows/
├─ README.md
├─ CONTRIBUTING.md
└─ CHANGELOG.md
