# 📄 Migration Cost Report — State-Symmetric Architecture

This report contains **raw migration cost measurements** collected from the showcase monorepo using `melos loc:report`.

Each section represents a **feature track**, measured as a **round-trip average** `(RP→CB + CB→RP) / 2`, showing the relative effort required to migrate feature code between Riverpod and Cubit state managers.

## Report Structure

- **Baseline (Clean)** — migration effort with no shared adapters or state symmetry
- **Symmetric** — migration effort when shared seams and state models are reused
- **Savings** — difference between baseline and symmetric migration costs
- **Overhead** — one-time adapter cost for the first feature on the track

All percentages (**%Track**) are computed relative to the total feature codebase of each track.

Results are grouped by track type:

- **SCSM Track**: Shared Custom State Models (Auth-related features)
- **AVLSM Track**: AsyncValue-Like State Models (Async/data-driven features)

---

## SCSM Track (Shared Custom State Models)

**Features:** Sign-In, Sign-Up, Change Password, Reset Password (N=4)

### Average Migration Cost (RoundTrip/2)

| Scenario         | RP→CB | CB→RP | Avg (RT/2) | %Track |
| ---------------- | ----- | ----- | ---------- | ------ |
| Baseline (Clean) | 2257  | 2084  | 2171       | 76.5%  |
| Symmetric        | 665   | 640   | 653        | 23.0%  |

### Savings & Overhead

| Bucket                  | LOC  | %Track |
| ----------------------- | ---- | ------ |
| SAVINGS (per migration) | 1518 | 53.5%  |
| Overhead (1st feature)  | 148  | 5.2%   |
| Savings per feature     | 379  | 13.4%  |

---

## AVLSM Track (AsyncValue-Like State Models)

**Features:** Profile, Email Verification (N=2)

### Average Migration Cost (RoundTrip/2)

| Scenario         | RP→CB | CB→RP | Avg (RT/2) | %Track |
| ---------------- | ----- | ----- | ---------- | ------ |
| Baseline (Clean) | 903   | 878   | 891        | 51.0%  |
| Symmetric        | 589   | 603   | 596        | 34.1%  |

### Savings & Overhead

| Bucket                  | LOC | %Track |
| ----------------------- | --- | ------ |
| SAVINGS (per migration) | 294 | 16.8%  |
| Overhead (1st feature)  | 377 | 21.6%  |
| Savings per feature     | 147 | 8.4%   |

---

## Summary: Overhead per Track

| Track (LOC & % of track codebase)    | LOC | % of track |
| ------------------------------------ | --- | ---------- |
| SCSM Track (Custom State Models)     | 148 | 5.2%       |
| AVLSM Track (AsyncValue-Like Models) | 377 | 21.6%      |

---

## Bucket Breakdown for Validation

### SCSM Track

```
Core (Domain+Data):         268 LOC
Presentation CB:            1349 LOC
Presentation RP:            1177 LOC
SM+INIT CB:                 505 LOC
SM+INIT RP:                 504 LOC
State Models (shared):      403 LOC
State Models (baseline):    403 LOC
Overhead CB:                160 LOC
Overhead RP:                136 LOC
Overhead (averaged):        148 LOC
Shared Widgets:             904 LOC
FEATURE TOTAL (for %):      2838 LOC
Number of features:         4
Savings per feature:        379 LOC
```

### AVLSM Track

```
Core (Domain+Data):         292 LOC
Presentation CB:            419 LOC
Presentation RP:            380 LOC
SM+INIT CB (raw):           212 LOC
SM+INIT RP (raw):           226 LOC
State Models (shared):      151 LOC
State Models (baseline):    272 LOC
Overhead (one-time):        753 LOC
Overhead (averaged):        377 LOC
Shared Widgets:             904 LOC
FEATURE TOTAL (for %):      1746 LOC
Number of features:         2
Savings per feature:        147 LOC
```

---

## How to Reproduce

Run the following command in the monorepo root:

```bash
melos loc:report
```

This executes `scripts/loc_report.sh`, which:

1. Counts non-generated, non-comment LOC using `ripgrep`
2. Aggregates by feature track (SCSM, AVLSM)
3. Computes round-trip averages and amortization tables

For methodology details, see **[info-002-methodology.md](info-002-methodology.md)**.
