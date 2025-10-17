### Appendix - Results of 'melos loc:report'

Next was copied from terminal:

```sh
...
romangodun@Mac app_on_bloc % melos loc:report
melos run loc:report
  └> bash scripts/loc_report.sh
     └> RUNNING


================================================================================
# FEATURE: AUTH (Sign-In/Up) — core (domain+data) + app-level presentation (NO adapters)
================================================================================

| Bucket                     |       BLoC |   Riverpod |      Total |
|----------------------------|------------|------------|------------|
| Core (domain+data)         |        400 |        400 |        400 |
| App presentation (per app) |         67 |         67 |        134 |
| TOTAL per app (no adapters) |        467 |        467 |          - |


================================================================================
# AUTH Overhead (thin facade-adapters ONLY)
================================================================================

| Bucket                     |       BLoC |   Riverpod |      Total |
|----------------------------|------------|------------|------------|
| Side-effects/submit/footer |        300 |        206 |        506 |


================================================================================
# COST to add the SECOND SM for AUTH (State-Symmetric vs Baseline)
================================================================================

Assume BLoC-first:
| Bucket                               |        LOC |
|--------------------------------------|------------|
| Add Riverpod (Adapters + Providers)  |        285 |
| Baseline: rewrite RP presentation    |         67 |
| Savings vs baseline                  |       -218 |

Assume Riverpod-first:
| Bucket                               |        LOC |
|--------------------------------------|------------|
| Add BLoC (Adapters only)             |        300 |
| Baseline: rewrite BLoC presentation  |         67 |
| Savings vs baseline                  |       -233 |


================================================================================
# FEATURE: PROFILE (+ Email Verification) — core (domain+data) + app-level presentation (NO adapters)
================================================================================

| Bucket                     |       BLoC |   Riverpod |      Total |
|----------------------------|------------|------------|------------|
| Core (domain+data)         |        185 |        185 |        185 |
| App presentation (per app) |         67 |         67 |        134 |
| TOTAL per app (no adapters) |        252 |        252 |          - |


================================================================================
# PROFILE Overhead (thin facade-adapters ONLY)
================================================================================

| Bucket                     |       BLoC |   Riverpod |      Total |
|----------------------------|------------|------------|------------|
| Async facades + errors listener |        237 |        153 |        390 |


================================================================================
# COST to add the SECOND SM for PROFILE (+ EmailV)
================================================================================

Assume BLoC-first:
| Bucket                               |        LOC |
|--------------------------------------|------------|
| Add Riverpod (Adapters + Providers)  |        238 |
| Baseline: rewrite RP presentation    |         67 |
| Savings vs baseline                  |       -171 |

Assume Riverpod-first:
| Bucket                               |        LOC |
|--------------------------------------|------------|
| Add BLoC (Adapters only)             |        237 |
| Baseline: rewrite BLoC presentation  |         67 |
| Savings vs baseline                  |       -170 |


================================================================================
# SANITY CHECK: whole adapter packages (non-generated)
================================================================================

===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 Dart                   23         1323          821          337          165
-------------------------------------------------------------------------------
 Markdown                4          530            0          343          187
 |- Dart                 3          153          133            9           11
 (Total)                            683          133          352          198
===============================================================================
 Total                  27         1853          821          680          352
===============================================================================

===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 Dart                   38         1581          786          610          185
===============================================================================
 Total                  38         1581          786          610          185
===============================================================================

================================================================================
Done.
================================================================================

melos run loc:report
  └> bash scripts/loc_report.sh
     └> SUCCESS
romangodun@Mac app_on_bloc %
...
```
