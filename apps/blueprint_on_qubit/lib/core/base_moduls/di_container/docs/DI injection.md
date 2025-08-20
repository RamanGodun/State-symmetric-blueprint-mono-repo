📦 Dependency Injection Best Practices in Professional Flutter Apps

🚀 Overview

This manual summarizes best practices for dependency injection (DI) and service registration in scalable, maintainable Flutter apps—covering both Riverpod and Bloc/Cubit architectures.

It reflects the architectural patterns used by top Flutter teams and community leaders, ensuring your codebase remains:
• 🧼 Clean
• 🔄 Easily testable
• 🧩 Decoupled
• ⚡️ Ready for growth and refactoring

⸻

1. Why Explicit DI is a Must

“Explicit dependencies = explicit control and testability”
— Very Good Ventures, Felix Angelov

    •	Never create dependencies directly inside your Cubit, Bloc, or UseCase.
    •	All business logic, repositories, data sources, and external clients must be injected.
    •	This enables easy mocking, swapping, and testing—keeping code composable and scalable.

⸻

2. Riverpod: Everything is a Provider
   • Each dependency (Repo, UseCase, DataSource, clients) is a separate provider.
   • Composability: Compose complex trees by injecting providers into each other.
   • All dependencies are visible in the dependency graph and hot reload works out-of-the-box.

Example:

final repoProvider = Provider<IProfileRepo>((ref) => ProfileRepoImpl(...));
final useCaseProvider = Provider((ref) => GetProfileUseCase(ref.watch(repoProvider)));

⸻

3. Bloc/Cubit: Everything is Registered in DI (GetIt/Injectable)
   • Register all dependencies in a DI container—no singletons or new inside your logic classes.
   • Inject dependencies via constructor—never hardcode them inside Cubit/BLoC/UseCase.

Example:

// DI Registration
GetIt.I.registerLazySingleton(() => ProfileRepoImpl(...));
GetIt.I.registerLazySingleton(() => GetProfileUseCase(GetIt.I()));
GetIt.I.registerLazySingleton(() => ProfileCubit(GetIt.I()));

// BlocProvider
BlocProvider.value(value: GetIt.I<ProfileCubit>())

⸻

4. Service Graph Consistency
   • Do not create repositories, use cases, or data sources inside logic classes.
   • Compose your graph from top to bottom, and keep your layers thin:
   • Cubit/BLoC -> UseCase -> Repo -> DataSource -> External API
   • This ensures modularity and full testability.

⸻

5. FAQ: Professional Team Recommendations

Q: Should UseCase, Repo, DataSource always be injected, even if trivial?
• Yes. Injection means you can easily test, mock, and swap implementations.

Q: Should you inject low-level clients (Firebase, Dio, etc)?
• Yes. This future-proofs your architecture and enables flexible testing.

Q: Can you create dependencies locally if you’re in a rush?
• No. Start clean, even for “quick” code—tech debt grows fast.

⸻

6. Recommended Patterns

Bloc/Cubit Example (GetIt)

// Registration
GetIt.I.registerLazySingleton(() => ProfileRepoImpl(...));
GetIt.I.registerLazySingleton(() => GetProfileUseCase(GetIt.I()));
GetIt.I.registerLazySingleton(() => ProfileCubit(GetIt.I()));

// Usage
MultiBlocProvider(
providers: [
BlocProvider.value(value: GetIt.I<ProfileCubit>()),
// ...
],
child: MyApp(),
)

Riverpod Example

final repoProvider = Provider<IProfileRepo>((ref) => ProfileRepoImpl(...));
final useCaseProvider = Provider((ref) => GetProfileUseCase(ref.watch(repoProvider)));
final profileProvider = NotifierProvider<Profile, AsyncValue<UserEntity>>(...);

⸻

7. TL;DR & Expert Quotes
   • Always inject dependencies, never create them inside logic classes.
   • Keep architecture explicit, decoupled, and testable.
   • Riverpod: Everything is a provider. Bloc/Cubit: Everything is registered in DI.

“In professional, scalable Flutter apps, never create dependencies inside your Cubit/BLoC or UseCase. Always inject via constructor and register in DI. Riverpod = the same, but via providers.”
— Felix Angelov (Very Good Ventures, Bloc)

“Explicit, visible dependency graphs are the only way to keep big Flutter apps maintainable.”
— Remi Rousselet (Riverpod creator)

⸻

8. Bonus: Testing & Flexibility
   • Need to test your Cubit? Just pass a mock dependency to its constructor.
   • Want to switch repo implementation (REST → Firebase)? Just change the DI/providing code.

⸻

9. References
   • Bloc Library Docs
   • Riverpod Docs
   • Very Good Ventures Open Source
   • Felix Angelov Twitter
   • Remi Rousselet Twitter

⸻

Adapted for professional Flutter development teams.
