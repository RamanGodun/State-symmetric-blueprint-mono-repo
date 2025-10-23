---
---

## ⏱ Lifecycle Cost Model (Hours/Budget)

**Core metrics**

- **ΔLOC:** use **RT/2 per bucket**.
- **CS:** change surface (0–1).

**Development effort**

```
H_dev = Σ(ΔLOC_bucket_i × dev_rate_i)
```

Reference **dev rates** (h/100 LOC):

| Bucket Type             | Rate (h/100 LOC) | Rationale                     |
| ----------------------- | ---------------- | ----------------------------- |
| SM+INIT                 | 2.0–3.5          | Wiring, minimal logic         |
| Presentation (stateful) | 3.0–5.0          | UI integration, state binding |
| Adapters/Seams (OH)     | 3.0–4.0          | Thin facades, careful design  |

**Test coverage cost**

```
H_tests = Σ(ΔLOC_bucket_i × test_impact_factor_i)
```

| Bucket Type    | Test Factor (h/100 LOC) | Coverage | Notes                        |
| -------------- | ----------------------- | -------- | ---------------------------- |
| SM+INIT        | +0.8–1.2                | 85–95%   | State transitions, DI wiring |
| Presentation   | +1.5–2.5                | 70–85%   | Widget/integration, goldens  |
| Adapters/Seams | +1.0–1.8                | 90–100%  | Symmetry contract across SMs |

**Additional components**

```
H_e2e       = scenarios × platforms × (0.8–1.2 h)
H_CI_fixed  = 0.5–2.0 h per PR
H_review_PM = H_dev × (0.15–0.25)
```

**Totals & budget**

```
H_total = H_dev + H_tests + H_e2e + H_CI_fixed + H_review_PM
Cost    = H_total × blended_hourly_rate
```

---

## 🔄 Maintenance Tax Model

```
Annual_Maintenance_Baseline  = N_changes × CS_baseline × K_change × hourly_rate
Annual_Maintenance_Symmetric = N_changes × CS_symmetric × K_change × hourly_rate
```

Typical ranges: `CS_baseline ≈ 0.4–0.6`, `CS_symmetric ≈ 0.1–0.2`.

**Example**

```
Baseline:  10 changes/yr × 0.5 × 4h × $100 = $2,000/yr
Symmetric: 10 changes/yr × 0.15 × 4h × $100 = $600/yr
Annual Savings: $1,400 per feature
```

---

## 🛡️ Insurance Model (Break‑Even)

All quantities below use **RT/2** units.

**Premium (what we pay)**

```
OH_avg_LOC = (OH_RP + OH_CB) / 2
OH_hours   = OH_avg_LOC × (rate_OH + test_OH) / 100
OH_hours_effective (for N features) = OH_hours / N
```

**Payout (what we gain)**

```
S_mig   = Σ_b (RT_BASE_b − RT_SYM_b) × (rate_b + test_b) / 100
S_maint = (CS_baseline − CS_symmetric) × K_change × N_changes_per_year × Y
S_total = S_mig + S_maint
```

**Break‑even probability (per feature)**

```
R* = OH_hours_effective / S_total
```

Steady‑state (OH already paid): set `OH_hours_effective = 0`.

**Equivalent compact form (% of track):**

```
R* = o / (p_clean − a)
```

where `o` is overhead as % of track, `p_clean` is Baseline migration cost % of track, `a` is symmetric cost % of track.

**Planning helpers**

```
N* = OH_hours / (R_target × S_total)

effective_overhead = overhead_paid / features_using_it
break_even_R       = effective_overhead / migration_savings
```

> Maintenance costs for sleeping adapters are already reflected via `CS_symmetric` and the ≤5% CI/test overhead; **do not** add a separate annual premium.

---

## Practical Guidance

- Use RT/2 for all migration and OH numbers (balanced mean per leg).
- Treat OH as a **one‑time premium** and amortize across features on the same track.
- When roadmap suggests multiple reuses, symmetry pays off; otherwise a clean single‑SM implementation may be preferable for that track.

**Track heuristics (planning expectations):**

- **SCSM:** Overhead 15–25% (first feature); savings 40–60% per migration; break‑even around 3–5 features or ≥20–35% reuse probability.
- **AVLSM:** Overhead 25–35% (first feature); savings 20–30% per migration; break‑even around 5–8 features or ≥26–43% reuse probability.

---

## Placeholders for Measurements

> After running the corrected `scripts/loc_report.sh`, fill in the tables below (all **RT/2** and normalized to `% of track`):

- **SCSM Track (Shared Custom State Models)** — Features: Sign‑In, Sign‑Up, Change Password, Reset Password
  Baseline vs Symmetric; Savings; Overhead (first feature)

- **AVLSM Track (AsyncValue‑Like State Models)** — Features: Profile, Email Verification, Sign Out
  Baseline vs Symmetric; Savings; Overhead (first feature)
