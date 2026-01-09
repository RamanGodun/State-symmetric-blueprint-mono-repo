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
    "app": {"title": "Aplikacja na Cubicie"},
    "pages": {
      "home": "     Strona główna",
      "home_message": "Możesz przejść do profilu i zmienić ustawienia",
      "profile": "Profil",
      "change_password": "Zmień hasło",
      "reset_password": "Zresetuj hasło",
      "verify_email": "Weryfikacja e-maila",
      "sign_in": "Zaloguj się do konta",
      "sign_up": "Dołącz do nas!",
      "reauthentication": "Ponowna autoryzacja",
    },
    "profile": {
      "name": "👤 Imię:       ",
      "id": "🆔 ID:           ",
      "email": "📧 Email:     ",
      "points": "📊 Punkty:   ",
      "rank": "🏆 Ranga:    ",
      "error": "Ups!\nCoś poszło nie tak.",
    },
    "reset_password": {
      "header": "Zresetuj swoje hasło",
      "sub_header": "Wyślemy Ci e-mail z linkiem do resetowania.",
      "success": "E-mail resetujący hasło został wysłany",
      "remember": "Pamiętasz hasło?   ",
    },
    "change_password": {
      "title": "Zmień hasło",
      "warning": "Jeśli zmienisz hasło,",
      "prefix": "zostaniesz ",
      "signed_out": "wylogowany!",
      "password_updated": "Пароль успішно оновлено",
      "success": "Pomyślnie uwierzytelniono ponownie",
    },
    "sign_in": {
      "header": "Witaj ponownie!",
      "sub_header": "Zaloguj się, aby kontynuować.",
      "forgot_password": "Nie pamiętasz hasła?",
      "not_member": "Nie masz konta?",
      "button": "Zaloguj się",
      "success": "Logowanie zakończone pomyślnie",
    },
    "sign_up": {
      "sub_header": "Utwórz konto, aby rozpocząć.",
      "already_have_account": "Masz już konto?",
      "button": "Zarejestruj się",
      "success": "Konto zostało pomyślnie zarejestrowane",
    },
    "reauth": {
      "label": "Ponowna autoryzacja",
      "description":
          "To operacja wymagająca bezpieczeństwa — musisz być ostatnio zalogowany!",
      "redirect_note": "Lub możesz przejść do     ",
      "page": "   strony",
    },
    "verify_email": {
      "sent": "E-mail weryfikacyjny został wysłany do",
      "not_found": "Jeśli nie widzisz wiadomości,",
      "check_prefix": "Sprawdź folder ",
      "spam": "SPAM",
      "check_suffix": ".",
      "ensure_correct": "Upewnij się, że Twój e-mail jest poprawny.",
      "unknown": "Nieznany",
      "or": "LUB",
    },
    "buttons": {
      "ok": "OK",
      "sign_in": "Zaloguj się",
      "sign_up": "Zarejestruj się",
      "sign_out": "Log",
      "submitting": "Wysyłanie...",
      "retry": "Spróbuj ponownie",
      "redirect_to_sign_up": "Nie masz konta?   ",
      "redirect_to_sign_in": "Masz już konto?   ",
      "cancel": "Anuluj",
      "go_to_home": "Na stronę główną",
      "reset_password": "Zresetuj hasło",
      "resend_email": "Wyślij ponownie e-mail weryfikacyjny",
      "loading": "Ładowanie...",
    },
  };
  static const Map<String, dynamic> _uk = {
    "app": {"title": "Додаток на Кубіту"},
    "pages": {
      "home": "     Головна сторінка",
      "home_message":
          "Ви можете перейти на сторінку профілю і зробити налаштування",
      "profile": "Профіль",
      "change_password": "Зміна пароля",
      "reset_password": "Скинути пароль",
      "verify_email": "Підтвердження електронної пошти",
      "sign_in": "Увійдіть до свого акаунту",
      "sign_up": "Приєднуйтесь до нас!",
      "reauthentication": "Повторна аутентифікація",
    },
    "profile": {
      "name": "👤 Ім'я:       ",
      "id": "🆔 ID:          ",
      "email": "📧 Пошта:  ",
      "points": "📊 Бали:     ",
      "rank": "🏆 Ранг:      ",
      "error": "Ой! Щось пішло не так.",
    },
    "reset_password": {
      "header": "Скидання пароля",
      "sub_header": "Ми надішлемо вам лист для скидання пароля.",
      "success": "Лист для скидання пароля надіслано",
      "remember": "Згадали пароль?   ",
    },
    "change_password": {
      "title": "Зміна пароля",
      "warning": "Якщо ви зміните пароль,",
      "prefix": "ви будете ",
      "signed_out": "вилогінені з системи!",
      "password_updated": "Пароль успішно оновлено",
      "success": "Успішна повторна аутентифікація",
    },
    "sign_in": {
      "header": "З поверненням!",
      "sub_header": "Увійдіть, щоб продовжити.",
      "forgot_password": "Забули пароль?",
      "not_member": "Ще не зареєстровані?",
      "button": "Увійти",
      "success": "Авторизація успішна",
    },
    "sign_up": {
      "sub_header": "Створіть акаунт, щоб почати.",
      "already_have_account": "Вже маєте акаунт?",
      "button": "Зареєструватися",
      "success": "Акаунт успішно зареєстровано",
    },
    "reauth": {
      "label": "Повторна аутентифікація",
      "description":
          "Це операція, чутлива до безпеки, ви повинні нещодавно увійти!",
      "redirect_note": "Або ви можете перейти на     ",
      "page": "   сторінку",
    },
    "verify_email": {
      "sent": "Лист з підтвердженням надіслано на",
      "not_found": "Якщо ви не знайшли листа,",
      "check_prefix": "Перевірте папку ",
      "spam": "СПАМ",
      "check_suffix": " .",
      "ensure_correct": "Переконайтесь, що електронна адреса правильна.",
      "unknown": "Невідомо",
      "or": "АБО",
    },
    "buttons": {
      "ok": "ОК",
      "sign_in": "Увійти",
      "sign_up": "Зареєструватися",
      "sign_out": "Входу",
      "submitting": "Надсилання...",
      "retry": "Повторити",
      "redirect_to_sign_up": "Ще не маєте акаунту?  ",
      "redirect_to_sign_in": "Вже маєте акаунт?   ",
      "cancel": "Скасувати",
      "go_to_home": "На головну",
      "reset_password": "Скинути пароль",
      "resend_email": "Повторно надіслати лист верефікації",
      "loading": "Загрузка...",
    },
  };
  static const Map<String, dynamic> _en = {
    "app": {"title": "App on Riverpod"},
    "pages": {
      "home": "     Home Page",
      "home_message": "You can go to profile page and make some settings",
      "profile": "Profile",
      "change_password": "Change Password",
      "reset_password": "Reset Password",
      "verify_email": "Email Verification",
      "sign_in": "Sign in to your account",
      "sign_up": "Join Us!",
      "reauthentication": "Reauthentication",
    },
    "profile": {
      "name": "👤 Name:   ",
      "id": "🆔 ID:         ",
      "email": "📧 Email:    ",
      "points": "📊 Points:  ",
      "rank": "🏆 Rank:    ",
      "error": "Oops!\nSomething went wrong.",
    },
    "reset_password": {
      "header": "Reset your password",
      "sub_header": "We will send you an email to reset it.",
      "success": "Password reset email has been sent",
      "remember": "Remember password?    ",
    },
    "change_password": {
      "title": "Change Password",
      "warning": "If you change your password,",
      "prefix": "you will be ",
      "signed_out": "signed out!",
      "password_updated": "password updating succeed",
      "success": "Successfully reauthenticated",
    },
    "sign_in": {
      "header": "Welcome Back!",
      "sub_header": "Please sign in to continue.",
      "forgot_password": "Forgot Password?",
      "not_member": "Not a member?",
      "button": "Sign In",
      "success": "Login successful",
    },
    "sign_up": {
      "sub_header": "Create an account to get started.",
      "already_have_account": "Already have an account?",
      "button": "Sign Up",
      "success": "Account successfully registered",
    },
    "reauth": {
      "label": "Reauthenticate",
      "description":
          "This is a security-sensitive operation, you must have recently signed in!",
      "redirect_note": "Or you can go     ",
      "page": "   page",
    },
    "verify_email": {
      "sent": "Verification email has been sent to",
      "not_found": "If you cannot find the email,",
      "check_prefix": "Please check ",
      "spam": "SPAM",
      "check_suffix": " folder.",
      "ensure_correct": "Ensure your email is correct.",
      "unknown": "Unknown",
      "or": "OR",
    },
    "buttons": {
      "ok": "OK",
      "sign_in": "Sign In",
      "sign_up": "Sign Up",
      "sign_out": "Sign in",
      "submitting": "Submitting...",
      "retry": "Retry",
      "redirect_to_sign_up": "Not a member?   ",
      "redirect_to_sign_in": "Already a member?  ",
      "cancel": "Cancel",
      "go_to_home": "To Home Page",
      "reset_password": "Reset Password",
      "resend_email": "Resend verification email",
      "loading": "Loading...",
    },
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "pl": _pl,
    "uk": _uk,
    "en": _en,
  };
}
