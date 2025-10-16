⸻

📱 Cubit/BLoC Demo App

✨ Overview
• Що це за апка: повністю функціональна демо-апка, яка демонструє State-Symmetric architecture.
• Основний акцент: ~85–90% кодової бази спільні з Riverpod-версією, різниця тільки у тонких адаптерах.
• Чому саме Cubit: показати, як Cubit інтегрується з core/features/adapters без втрати крос-SM симетрії.

⸻

🚀 Getting Started
• Як запустити (через Melos, VSCode/AS).
• Flavors (development/staging).
• Короткі команди для запуску.

### ⚙️ Firebase Configuration

- Firebase is configured via `.env` + `flutter_dotenv`
- Use the provided `.env` files or create your own. In the latter case:

1. ```bash
   flutterfire configure --project=<your_project_id>
   ```
2. After configuration, put the following into the created `.env.dev` and/or `.env.staging` files:

```env
FIREBASE_API_KEY=...
FIREBASE_APP_ID=...
FIREBASE_PROJECT_ID=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_STORAGE_BUCKET=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_IOS_BUNDLE_ID=...
```

⸻

🧠 Files Structure
• Дерево папок саме апки (тільки app_on_bloc/lib/), без усього монорепо.
• Виділити ключові папки: app_bootstrap/, core/, features_presentation/.
• Пояснити роль кожної:
• app_bootstrap/ → ініціалізація, DI (GetIt), entrypoint.
• core/ → базові модулі (навігація, локалізація, оверлеї, теми, анімації, errors).
• features_presentation/ → UI + Cubit-логіка (фічі).

⸻

🔐 Features
• Показати, що всі фічі умовно групуються у дві великі категорії: 1. Auth-flows (Sign-In/Up, Password flows, Sign-Out) → шви однакові (submission side-effects, error handling). 2. Profile + Email Verification → інші шви (асинхронний state glue, AsyncValue аналоги).
• Зафіксувати, що це зроблено навмисно: щоб продемонструвати дві різні категорії seam contracts у симетричній архітектурі.

⸻

🛠️ Infrastructure

Коротко пояснити, як підключені базові сервіси:
• 🌐 Локалізація (EasyLocalization + AppLocalizer)
• 🧭 Навігація (GoRouter + Auth-aware redirects)
• 🎨 Тема (dark/light/amoled)
• 🪟 Оверлеї (централізований overlay manager)
• ⚠️ Error handling (єдиний pipeline для UI/domain)
• 🛠 Form Fields (кастомна валідація + локалізація)
• 🔥 Firebase (через firebase_adapter, ізольований шар)

⸻

🧩 How This App Fits the Monorepo
• Це одна з двох симетричних апок (Cubit/BLoC vs Riverpod).
• Вона працює на тому ж shared-коді (core, features, firebase_adapter), але з’єднує їх через bloc_adapter.
• Пояснити, що це втілює State-Symmetric стиль: shared kernel + thin adapters.

⸻

🧪 Testing
• Тести у цьому демо не були головною метою (див. root README).
• Однак структура вже готова під very_good test runner.
• Приклад запуску з Melos.

⸻

📚 Additional Docs
• Посилання на ADR (особливо ADR-001, ADR-002, ADR-003).
• Посилання на пакети (core, bloc_adapter, firebase_adapter).
