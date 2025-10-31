# ADR-00X: Application Throttling & Lifecycle Backpressure — SSA-сумісна стратегія

## 1. 🎯 Context (Problem & Goals)

Коротко: чому потрібні throttling/debounce/backpressure/lifecycle-паузи; які ризики без цього; вимоги SSA (симетрія між Bloc/Riverpod, context-free DI, передбачуваний UX).

## 2. ✅ Decisions

- **Architecture**: Lifecycle Orchestrator у core; політики throttling/debounce/batch/retry як чистий Dart; тонкі адаптери у `bloc_adapter`/`riverpod_adapter`.
- **Policies (defaults)**: typing/search debounce; collapse duplicates; background pausing; retry з backoff; batching для телеметрії.
- **Contracts**: публічні порти/фасади без `BuildContext`; конфіг через DI (ADR-002); інтеграція з помилками (ADR-005) та навігацією (ADR-003).
- **Observability**: мінімальні лічильники/трейси; дані — без PII.

## 3. 🧨 Consequences

**Positive**: консистентний UX, менше 429/timeout, економія даних/CPU, простий A/B.
**Negative**: додаткові фасади й тести; ризик надмірного throttling (потрібні whitelist/override).

## 4. 💡 Success Criteria & Alternatives

**Success Criteria**: цільові дельти для RPS↓, timeouts↓, p95 latency ≤ +5%, дані/CPU↓; вимірювано на обох демо-апках.
**Alternatives Considered**: локальні debounce у віджетах (відхилено); платформа-специфічні BG-сервіси як основа (відхилено для демо); прийняте core-центроване рішення.

## 5. 📌 Summary

Придатний до продакшн мінімум: централізовані політики у core + симетричні тонкі адаптери → збереження SSA та перевірювані вигоди.

## 6. 🔗 Related Info

- ADR-001 (SSA), ADR-002 (DI), ADR-003 (Navigation), ADR-005 (Errors), ADR-006 (Overlays)
- Supporting info: `ADR/supporting_info/info-00X-throttling-benchmarks.md`, `.../info-00X-api-examples.md`
