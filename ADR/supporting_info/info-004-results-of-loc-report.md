================================================================================

# SCSM Track (Shared Custom State Models) — Average Migration Cost (RoundTrip/2)

================================================================================

Features: Sign-In, Sign-Up, Change Password, Reset Password

| Scenario         | RP→CB | CB→RP | Avg (RT/2) | %Track |
| ---------------- | ----- | ----- | ---------- | ------ |
| Baseline (Clean) | 2461  | 2288  | 2375       | 83,3%  |
| Symmetric        | 607   | 597   | 602        | 21,1%  |

| Bucket                  | LOC  | %Track |
| ----------------------- | ---- | ------ |
| SAVINGS (per migration) | 1772 | 62,2%  |

| Overhead (1st feature) | 98 | 3,4% |

================================================================================

# AVLSM Track (AsyncValue-Like State Models) — Average Migration Cost (RoundTrip/2)

================================================================================

Features: Profile, Email Verification, Sign Out

| Scenario         | RP→CB | CB→RP | Avg (RT/2) | %Track |
| ---------------- | ----- | ----- | ---------- | ------ |
| Baseline (Clean) | 1513  | 1499  | 1506       | 82,3%  |
| Symmetric        | 237   | 261   | 575        | 31,4%  |

| Bucket                  | LOC | %Track |
| ----------------------- | --- | ------ |
| SAVINGS (per migration) | 931 | 50,8%  |

| Overhead (1st feature) | 326 | 17,8% |

================================================================================

# Summary: Overhead per track (first adoption, context)

================================================================================

| Track (LOC & % of track codebase)    | LOC | % of track |
| ------------------------------------ | --- | ---------- |
| SCSM Track (Custom State Models)     | 98  | 3,4%       |
| AVLSM Track (AsyncValue-Like Models) | 326 | 17,8%      |

================================================================================

# Bucket Breakdown for Validation

================================================================================

=== SCSM Track ===
Core (Domain+Data): 268 LOC
Presentation CB: 1349 LOC
Presentation RP: 1177 LOC
SM+INIT CB: 505 LOC
SM+INIT RP: 504 LOC
State Models (shared): 403 LOC
State Models (baseline, ×4): 607 LOC
Overhead CB: 102 LOC
Overhead RP: 93 LOC
Shared Widgets: 916 LOC
FEATURE TOTAL (for %): 2850 LOC

=== AVLSM Track ===
Core (Domain+Data): 323 LOC
Presentation CB: 460 LOC
Presentation RP: 422 LOC
SM+INIT CB: 237 LOC
SM+INIT RP: 261 LOC
State Models (shared): 151 LOC
State Models (baseline, ×3): 816 LOC
Overhead (one-time, round-trip): 652 LOC
Overhead (averaged): 326 LOC
Shared Widgets: 916 LOC
FEATURE TOTAL (for %): 1831 LOC

================================================================================
Done.
================================================================================H
