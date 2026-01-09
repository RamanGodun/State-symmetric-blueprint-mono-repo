// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> _pl = {
    "buttons": {
      "ok": "OK",
      "submitting": "Wysyłanie...",
      "retry": "Spróbuj ponownie",
      "cancel": "Anuluj",
      "go_to_home": "Na stronę główną",
      "loading": "Ładowanie...",
    },
    "form": {
      "name": "Imię",
      "name_is_empty": "pole nie może być puste",
      "name_is_too_short": "musi mieć co najmniej 3 znaki",
      "email": "Email",
      "email_is_empty": "nie może być puste",
      "email_is_invalid": "nieprawidłowy format emaila",
      "password": "Hasło",
      "password_required": "wymagane jest hasło",
      "password_too_short": "musi mieć co najmniej 6 znaków",
      "confirm_password": "Potwierdź hasło",
      "confirm_password_is_empty": "musisz ponownie wprowadzić hasło",
      "confirm_password_mismatch": "hasła nie są zgodne",
    },
    "theme": {
      "light_enabled": "Obecnie \"Tryb jasny\"",
      "dark_enabled": "Obecnie \"Tryb ciemny\"",
      "amoled_enabled": "Obecnie  \"Amoled Tryb\"",
      "light": "Motyw jasny",
      "dark": "Motyw ciemny",
      "amoled": "Motyw AMOLED",
      "choose_theme": "Wybierz motyw",
    },
    "languages": {
      "switched_to_pl": "Język zmieniono na 🇵🇱 polski",
      "switched_to_en": "Język zmieniono na 🇬🇧 angielski",
      "switched_to_ua": "Język zmieniono na 🇺🇦 ukraiński",
    },
    "errors": {
      "page_not_found_title": "Strony nie znaleziono",
      "page_not_found_message": "Ups! Strona, której szukasz, nie istnieje.",
      "error_dialog": "Wystąpił błąd",
    },
    "failures": {
      "firebase": {
        "generic": "Wystąpił błąd Firebase.",
        "unauthorized": "Nie jesteś autoryzowany. Zaloguj się, proszę.",
        "invalid_credential":
            "Nieprawidłowe dane logowania. Sprawdź poprawność i spróbuj ponownie.",
        "account_exists_with_different_credential":
            "Konto z tym adresem e-mail już istnieje, ale z innymi danymi logowania.",
        "email_already_in_use": "Ten adres e-mail jest już używany.",
        "email_verification_timeout":
            "Weryfikacja e-maila trwała zbyt długo. Spróbuj ponownie później.",
        "user_not_found": "Użytkownik nie został znaleziony.",
        "no_current_user": "Brak aktualnie zalogowanego użytkownika.",
        "doc_missing": "Brak profilu użytkownika.",
        "user_disabled": "Konto zostało dezaktywowane.",
        "operation_not_allowed":
            "Ta operacja nie jest dozwolona przez Firebase.",
        "requires_recent_login":
            "Aby wykonać tę operację, musisz się ponownie zalogować.",
        "too_many_requests": "Zbyt wiele żądań. Spróbuj ponownie później.",
      },
      "network": {
        "no_connection": "Brak połączenia z Internetem.",
        "timeout":
            "Limit czasu połączenia został przekroczony. Spróbuj ponownie później.",
      },
      "api": {"generic": "API error occurred."},
      "plugin_missing":
          "Wykryto brakujący plugin. Skontaktuj się z pomocą techniczną.",
      "format_error": "Otrzymano nieprawidłowy format danych.",
      "cache_error": "Wystąpił błąd pamięci podręcznej.",
      "timeout":
          "Limit czasu żądania został przekroczony. Spróbuj ponownie później.",
      "unknown": "Wystąpił nieoczekiwany błąd. Spróbuj ponownie.",
    },
  };
  static const Map<String, dynamic> _uk = {
    "buttons": {
      "ok": "ОК",
      "submitting": "Надсилання...",
      "retry": "Повторити",
      "cancel": "Скасувати",
      "go_to_home": "На головну",
      "loading": "Загрузка...",
    },
    "form": {
      "name": "Ім'я",
      "name_is_empty": "поле не може бути пустим",
      "name_is_too_short": "щонайменше має бути три символи",
      "email": "Електронна пошта",
      "email_is_empty": "не може бути пустою",
      "email_is_invalid": "некоректний формат",
      "password": "Пароль",
      "password_required": "потрібно вести пароль",
      "password_too_short": "має бути щонайменше 6 символів",
      "confirm_password": "Підтвердження паролю",
      "confirm_password_is_empty": "необхідно ще раз ввести пароль",
      "confirm_password_mismatch": "паролі не співпадають",
    },
    "theme": {
      "light_enabled": "Зараз увімкнено \"Світлу тему\"",
      "dark_enabled": "Зараз увімкнено \"Темну тему\"",
      "amoled_enabled": "Зараз увімкнено  \"Амолед тему\"",
      "light": "Світла тема",
      "dark": "Темна тема",
      "amoled": "AMOLED тема",
      "choose_theme": "Оберіть тему",
    },
    "languages": {
      "switched_to_pl": "Мову змінено на 🇵🇱 польську",
      "switched_to_en": "Мову змінено на 🇬🇧 англійську",
      "switched_to_ua": "Мову змінено на 🇺🇦 українську",
    },
    "errors": {
      "page_not_found_title": "Сторінку не знайдено",
      "page_not_found_message": "Ой! Сторінка, яку ви шукаєте, не існує.",
      "error_dialog": "Сталася помилка",
    },
    "failures": {
      "firebase": {
        "generic": "Сталася помилка Firebase.",
        "unauthorized": "Ви не авторизовані. Будь ласка, увійдіть.",
        "invalid_credential":
            "Некоректні облікові дані. Будь ласка, перевірте введене і спробуйте ще раз.",
        "account_exists_with_different_credential":
            "Обліковий запис з цією поштою вже існує, але з іншими обліковими даними.",
        "email_already_in_use": "Ця електронна адреса вже використовується.",
        "email_verification_timeout":
            "Підтвердження електронної пошти зайняло надто багато часу. Спробуйте пізніше.",
        "user_not_found": "Користувача не знайдено.",
        "no_current_user": "Немає поточного авторизованого користувача.",
        "doc_missing": "Профіль користувача відсутній.",
        "user_disabled": "Обліковий запис деактивовано.",
        "operation_not_allowed": "Цю дію заборонено налаштуваннями Firebase.",
        "requires_recent_login":
            "Для виконання цієї дії потрібно нещодавно увійти до системи.",
        "too_many_requests": "Забагато запитів. Спробуйте пізніше.",
      },
      "network": {
        "no_connection": "Немає підключення до Інтернету.",
        "timeout": "Час очікування перевищено. Спробуйте пізніше.",
      },
      "api": {"generic": "API error occurred."},
      "plugin_missing": "Виявлено відсутній плагін. Зверніться до підтримки.",
      "format_error": "Отримано некоректний формат даних.",
      "cache_error": "Виникла помилка кешування.",
      "timeout": "Час очікування запиту вичерпано. Спробуйте ще раз пізніше.",
      "unknown": "Сталася непередбачувана помилка. Спробуйте пізніше.",
    },
  };
  static const Map<String, dynamic> _en = {
    "buttons": {
      "ok": "OK",
      "submitting": "Submitting...",
      "retry": "Retry",
      "cancel": "Cancel",
      "go_to_home": "To Home Page",
      "loading": "Loading...",
    },
    "form": {
      "name": "Name",
      "name_is_empty": "field cannot be empty",
      "name_is_too_short": "must be at least 3 characters",
      "email": "Email",
      "email_is_empty": "cannot be empty",
      "email_is_invalid": "invalid email format",
      "password": "Password",
      "password_required": "password is required",
      "password_too_short": "must be at least 6 characters",
      "confirm_password": "Confirm Password",
      "confirm_password_is_empty": "need to re-enter the password",
      "confirm_password_mismatch": "passwords do not match",
    },
    "theme": {
      "light_enabled": "now is  \"Light Mode\"",
      "dark_enabled": "now is  \"Dark Mode\"",
      "amoled_enabled": "now is  \"Amoled Mode\"",
      "light": "Light theme",
      "dark": "Dark theme ",
      "amoled": "Amoled theme",
      "choose_theme": "Choose theme",
    },
    "languages": {
      "switched_to_pl": "Language switched to 🇵🇱 Polish",
      "switched_to_en": "Language switched to 🇬🇧 English",
      "switched_to_ua": "Language switched to 🇺🇦 Ukrainian",
    },
    "errors": {
      "page_not_found_title": "Page Not Found",
      "page_not_found_message":
          "Oops! The page you’re looking for does not exist.",
      "error_dialog": "An error occurred",
    },
    "failures": {
      "firebase": {
        "generic": "A Firebase error occurred.",
        "unauthorized": "You are not authorized. Please sign in.",
        "invalid_credential":
            "Invalid credentials. Please check your input and try again.",
        "account_exists_with_different_credential":
            "An account with this email already exists but with different credentials.",
        "email_already_in_use": "This email address is already in use.",
        "email_verification_timeout":
            "Email verification took too long. Please try again later.",
        "user_not_found": "User not found.",
        "no_current_user": "No current user signed in.",
        "doc_missing": "User profile is missing.",
        "user_disabled": "Account has been disabled.",
        "operation_not_allowed": "Operation not allowed by Firebase.",
        "requires_recent_login":
            "You need to reauthenticate to perform this action.",
        "too_many_requests": "Too many requests. Please try again later.",
      },
      "network": {
        "no_connection": "No internet connection.",
        "timeout": "Connection timed out. Please try again later.",
      },
      "api": {"generic": "API error occurred."},
      "plugin_missing": "Missing plugin detected. Please contact support.",
      "format_error": "Invalid data format received.",
      "cache_error": "A cache error occurred.",
      "timeout": "The request timed out. Please try again later.",
      "unknown": "An unexpected error occurred. Please try again.",
    },
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "pl": _pl,
    "uk": _uk,
    "en": _en,
  };
}
