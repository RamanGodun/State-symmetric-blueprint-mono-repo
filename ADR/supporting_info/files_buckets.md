# 📂 Bucket 2 — Reused Core Files (Relative Paths)

Нижче — повний список файлів для **кошика 2 (Reused code)** по треках **AVLSM** та **SCSM**. Це спільні файли (переважно статичні/stateless або такі, що повторно використовуються), які завжди залишаються незмінними між міграціями для всіх трьох треків (включно з базовим).

---

## AVLSM Track

### Feature packages

- packages/features/lib/src/email_verification/data/email_verification_repo_impl.dart
- packages/features/lib/src/email_verification/data/remote_database_contract.dart
- packages/features/lib/src/email_verification/data/remote_database_impl.dart
- packages/features/lib/src/email_verification/domain/email_verification_use_case.dart
- packages/features/lib/src/email_verification/domain/repo_contract.dart
- packages/features/lib/src/profile/data/implementation_of_profile_fetch_repo.dart
- packages/features/lib/src/profile/data/remote_database_contract.dart
- packages/features/lib/src/profile/data/remote_database_impl.dart
- packages/features/lib/src/profile/domain/fetch_profile_use_case.dart
- packages/features/lib/src/profile/domain/repo_contract.dart
- packages/features/lib/src/auth/data/auth_repo_implementations/sign_out_repo_impl.dart
- packages/features/lib/src/auth/domain/use_cases/sign_out.dart

### Shared stateless widgets

- `packages/core/lib/src/shared_presentation_layer/pages_shared/splash_page.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/footer/footer_guard_while_loading.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/footer/inherited_footer_guard.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/loader.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/filled_button.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/submit_button.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/text_button.dart`
- `packages/core/lib/src/base_modules/localization/module_widgets/text_widget.dart`
- `packages/core/lib/src/base_modules/form_fields/form_field_factory.dart`
- `packages/core/lib/src/base_modules/form_fields/widgets/app_form_field.dart`
- `packages/core/lib/src/base_modules/form_fields/widgets/password_visibility_icon.dart`

---

## SCSM Track

### Feature packages

- packages/features/lib/src/auth/data/auth_repo_implementations/sign_in_repo_impl.dart
- packages/features/lib/src/auth/data/auth_repo_implementations/sign_up_repo_impl.dart
- packages/features/lib/src/auth/data/remote_database_contract.dart
- packages/features/lib/src/auth/data/remote_database_impl.dart
- packages/features/lib/src/auth/domain/use_cases/sign_in.dart
- packages/features/lib/src/auth/domain/use_cases/sign_up.dart
- packages/features/lib/src/auth/domain/repo_contracts.dart
- packages/features/lib/src/password_changing_or_reset/data/password_actions_repo_impl.dart
- packages/features/lib/src/password_changing_or_reset/data/remote_database_contract.dart
- packages/features/lib/src/password_changing_or_reset/data/remote_database_impl.dart
- packages/features/lib/src/password_changing_or_reset/domain/password_actions_use_case.dart
- packages/features/lib/src/password_changing_or_reset/domain/repo_contract.dart

### Shared stateless widgets

- `packages/core/lib/src/shared_presentation_layer/pages_shared/splash_page.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/loader.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/filled_button.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/text_button.dart`
- `packages/core/lib/src/base_modules/localization/module_widgets/text_widget.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/app_bar.dart`
- `packages/core/lib/src/shared_presentation_layer/widgets_shared/key_value_text_widget.dart`

---

# 📂 Bucket 3 — SMs code + their initializations

Тут файли, що враховуються при міграції фічі в рамках двох треків для Стейт-Симетричного підходу (адже потрібно замінити файл стейтменеджеру на цільовий стейтменеджер, а також ініціалізувати його)

## AVLSM Track

### Для додатку на блоці (тобто щоб привʼязати кубіти до додатку на кубіту)

1. apps/app_on_bloc/lib/app_bootstrap/di_container/global_di_container.dart
2. apps/app_on_bloc/lib/app_bootstrap/di_container/di_container_init.dart
3. apps/app_on_bloc/lib/app_bootstrap/di_container/modules/email_verification.dart
4. apps/app_on_bloc/lib/app_bootstrap/di_container/modules/profile_module.dart
5. apps/app_on_bloc/lib/app_bootstrap/di_container/modules/warmup_module.dart
   Далі стейт менеджери
6. apps/app_on_bloc/lib/features/auth/sign_out/sign_out_cubit/sign_out_cubit.dart
7. apps/app_on_bloc/lib/features/email_verification/email_verification_cubit/email_verification_cubit.dart
8. apps/app_on_bloc/lib/features/profile/cubit/profile_page_cubit.dart

### Для додатку на ріверподі

1. apps/app_on_riverpod/lib/app_bootstrap/di_config_sync.dart
   Далі провайдери для шарів Data/Domain, що знаходяться у відповідних теках
2. packages/riverpod_adapter/lib/src/features/features_providers/email_verification/data_layer_providers/data_layer_providers.dart
3. packages/riverpod_adapter/lib/src/features/features_providers/email_verification/domain_layer_providers/use_case_provider.dart
4. packages/riverpod_adapter/lib/src/features/features_providers/profile/data_layers_providers/data_layer_providers.dart
5. packages/riverpod_adapter/lib/src/features/features_providers/profile/domain_layer_providers/use_case_provider.dart
   Далі самі провайдери шару презентації
6. apps/app_on_riverpod/lib/features/auth/sign_out/sign_out_provider.dart
7. apps/app_on_riverpod/lib/features/email_verification/provider/email_verification_provider.dart
8. apps/app_on_riverpod/lib/features/profile/providers/profile_page_provider.dart

---

## SCSM Track

### Для додатку на блоці

1. apps/app_on_bloc/lib/app_bootstrap/di_container/global_di_container.dart
2. apps/app_on_bloc/lib/app_bootstrap/di_container/di_container_init.dart
3. apps/app_on_bloc/lib/app_bootstrap/di_container/modules/password_module.dart
   Далі стейт менеджери
4. apps/app_on_bloc/lib/features/auth/sign_in/cubit/form_fields_cubit.dart
5. apps/app_on_bloc/lib/features/auth/sign_in/cubit/sign_in_cubit.dart
6. apps/app_on_bloc/lib/features/auth/sign_up/cubit/form_fields_cubit.dart
7. apps/app_on_bloc/lib/features/auth/sign_up/cubit/sign_up_cubit.dart
8. apps/app_on_bloc/lib/features/password_changing_or_reset/change_password/cubit/change_password_cubit.dart
9. apps/app_on_bloc/lib/features/password_changing_or_reset/change_password/cubit/form_fields_cubit.dart
10. apps/app_on_bloc/lib/features/password_changing_or_reset/reset_password/cubits/form_fields_cubit.dart
11. apps/app_on_bloc/lib/features/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart

### Для додатку на ріверподі

1. apps/app_on_riverpod/lib/app_bootstrap/di_config_sync.dart
   Далі провайдери для шарів Data/Domain , що знаходяться у відповідних теках
2. packages/riverpod_adapter/lib/src/features/features_providers/auth/data_layer_providers/data_layer_providers.dart
3. packages/riverpod_adapter/lib/src/features/features_providers/auth/domain_layer_providers/use_cases_providers.dart
4. packages/riverpod_adapter/lib/src/features/features_providers/password_changing_or_reset/data_layer_providers/data_layer_providers.dart
5. packages/riverpod_adapter/lib/src/features/features_providers/password_changing_or_reset/domain_layer_providers/use_cases_provider.dart
   Далі самі провайдери шару презентації
6. apps/app_on_riverpod/lib/features/auth/sign_in/providers/input_form_fields_provider.dart
7. apps/app_on_riverpod/lib/features/auth/sign_in/providers/sign_in\_\_provider.dart
8. apps/app_on_riverpod/lib/features/auth/sign_up/providers/input_form_fields_provider.dart
9. apps/app_on_riverpod/lib/features/auth/sign_up/providers/sign_up\_\_provider.dart
10. apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/providers/change_password\_\_provider.dart
11. apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/providers/input_fields_provider.dart
12. apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/providers/input_fields_provider.dart
13. apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/providers/reset_password\_\_provider.dart

---

# 📂 Bucket 4 — State Models

Тут файли, що показують які стейт моделі використовуються. Для оцінки вартості в рамках базового підходу потрібно буде допускати написання моделей для кожної фічі (це має бути включено в обєм переписаного нового шару презентації), тобто потрібно врахувати async_value_for_bloc.dart для AVLSM треку тричі (використовується в трьох фічах), а для SCSM треку submission_state.dart - чотири рази (використовується для чотирьох фіч).
Для треків Стейт-симетричного підходу відповідні моделі враховуються лише при оцінці вартості міграції фічі, причому враховуються лише один раз (!), адже в цьому і особливість, що використовуються спільні стейт моделі

## AVLSM Track

### Для додатку на блоці

1. packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_value_for_bloc.dart
2. packages/bloc_adapter/lib/src/core/presentation_shared/cubits/async_state_base_cubit.dart (цей базовий кубіт іде в пакеті з моделю)
3. packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_state_introspection_bloc.dart (хелпер для стейт моделі)

### Для додатку на ріверподі

1. Немає, адже використовується готова AsyncValue стейт модель
2. packages/riverpod_adapter/lib/src/core/shared_presentation/async_state/async_state_introspection.dart (хелпер для стейт моделі)

---

## SCSM Track

### Для додатку на блоці

1. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/sign_in.dart
2. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/sign_up.dart
3. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/reset_password.dart
4. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/change_password.dart
5. packages/core/lib/src/shared_presentation_layer/shared_states/submission_state.dart

### Для додатку на ріверподі

1. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/sign_in.dart
2. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/sign_up.dart
3. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/reset_password.dart
4. packages/core/lib/src/base_modules/form_fields/shared_form_fields_states/change_password.dart
5. packages/core/lib/src/shared_presentation_layer/shared_states/submission_state.dart

---

# 📂 Bucket 5 — Overhead

Тут файли, що складають оверхед треків Стейт-симетричного підходу в порівнянні з треками базового сценарію на чистій архітектурі. Для AVLSM одноразово (!) враховується весь оверхед і далі ділиться на 2, щоб отримати усереднене значення. Для SCSM враховується лише оверхед лише поточного менеджера (в режимі "Laxy parity" паритетний адаптер пишеться лише коли він потрібен і відповідно уже враховується у вартості міграції)

## AVLSM Track

### Незалежно чи фіча написана на блоціб чи на ріверподі, разово додаємо оверхед і далі вільно користуємося (тобто для усередненого оверхеду, потрібно ці файли поділити на 2)

1. packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_value_for_bloc.dart
2. packages/bloc_adapter/lib/src/core/presentation_shared/cubits/async_state_base_cubit.dart (цей базовий кубіт іде в пакеті з моделю)
3. packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_state_introspection_bloc.dart (хелпер для стейт моделі AsynValueForBloc)
4. packages/riverpod_adapter/lib/src/core/shared_presentation/async_state/async_state_introspection.dart (хелпер для стейт моделі AsynValue)
5. packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/adapter_for_async_value_flow.dart
6. packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/adapter_for_async_value_flow.dart
7. packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/adapter_for_footer_guard.dart
8. packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/adapter_for_submit_button.dart
9. packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/adapter_for_footer_guard.dart
10. packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/adapter_for_submit_button.dart

---

## SCSM Track

### Для додатку на блоці (тобто коли пишемо фічу на кубіту, а відповідні адаптери для ріверподу - у "Lazy parity mode')

1. packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/adapter_for_submission_flow.dart
2. packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/adapter_for_footer_guard.dart
3. packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/adapter_for_submit_button.dart

### Для додатку на ріверподі (тобто коли пишемо фічу на ріверподі, а відповідні адаптери для кубіту - у "Lazy parity mode')

1. packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/adapter_for_submission_flow.dart
2. packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/adapter_for_footer_guard.dart
3. packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/adapter_for_submit_button.dart

---

# 📂 Bucket 6 — Presentation Layer Files (Relative Paths)

Тут список файлів, що мають бути враховані в шарі презентації, відповідно у вартості міграції фіч в рамках треків базового сценарію, а також при оцінці всього обєму коду для кожного треку

---

## AVLSM Track

### Для додатку на блоці

- `apps/app_on_bloc/lib/features/email_verification/email_verification_page.dart`
- `apps/app_on_bloc/lib/features/email_verification/widgets_for_email_verification_page.dart`
- `apps/app_on_bloc/lib/features/auth/sign_out/sign_out_widgets.dart`
- `apps/app_on_bloc/lib/features/profile/profile_page.dart`
- `apps/app_on_bloc/lib/features/profile/widgets_for_profile_page.dart`

### Для додатку на ріверподі

- `apps/app_on_riverpod/lib/features/email_verification/email_verification_page.dart`
- `apps/app_on_riverpod/lib/features/email_verification/widgets_for_email_verification_page.dart`
- `apps/app_on_riverpod/lib/features/auth/sign_out/sign_out_widgets.dart`
- `apps/app_on_riverpod/lib/features/profile/profile_page.dart`
- `apps/app_on_riverpod/lib/features/profile/widgets_for_profile_page.dart`

---

## SCSM Track

### Для додатку на блоці

- `apps/app_on_bloc/lib/features/auth/sign_in/sign_in__page.dart`
- `apps/app_on_bloc/lib/features/auth/sign_in/widgets_for_sign_in_page.dart`
- `apps/app_on_bloc/lib/features/auth/sign_up/sign_up__page.dart`
- `apps/app_on_bloc/lib/features/auth/sign_up/sign_up_input_fields.dart`
- `apps/app_on_bloc/lib/features/auth/sign_up/widgets_for_sign_up_page.dart`
- `apps/app_on_bloc/lib/features/password_changing_or_reset/change_password/change_password_page.dart`
- `apps/app_on_bloc/lib/features/password_changing_or_reset/change_password/widgets_for_change_password.dart`
- `apps/app_on_bloc/lib/features/password_changing_or_reset/reset_password/reset_password__page.dart`
- `apps/app_on_bloc/lib/features/password_changing_or_reset/reset_password/widgets_for_reset_password_page.dart`
- `packages/core/lib/src/shared_presentation_layer/side_effects_listeneres/submission_side_effects_config.dart`

### Для додатку на ріверподі

- `apps/app_on_riverpod/lib/features/auth/sign_in/sign_in__page.dart`
- `apps/app_on_riverpod/lib/features/auth/sign_in/widgets_for_sign_in_page.dart`
- `apps/app_on_riverpod/lib/features/auth/sign_up/sign_up__page.dart`
- `apps/app_on_riverpod/lib/features/auth/sign_up/sign_up_input_fields.dart`
- `apps/app_on_riverpod/lib/features/auth/sign_up/widgets_for_sign_up_page.dart`
- `apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/change_password_page.dart`
- `apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/widgets_for_change_password.dart`
- `apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/reset_password__page.dart`
- `apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/widgets_for_reset_password_page.dart`
- `packages/core/lib/src/shared_presentation_layer/side_effects_listeneres/submission_side_effects_config.dart`

---
