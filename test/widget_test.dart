import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:senas_app/app.dart';
import 'package:senas_app/controllers/app_controller.dart';
import 'package:senas_app/models/app_models.dart';
import 'package:senas_app/repositories/sign_repository.dart';
import 'package:senas_app/repositories/translation_repository.dart';
import 'package:senas_app/repositories/user_repository.dart';
import 'package:senas_app/routes/app_router.dart';
import 'package:senas_app/shared/widgets/lsc70_player.dart';
import 'package:senas_app/views/access_screens.dart';
import 'package:senas_app/views/core_screens.dart';
import 'package:senas_app/views/management_screens.dart';
import 'package:senas_app/views/profile_screens.dart';

void main() {
  for (final (path, fallback, screen) in <(String, String, Widget)>[
    ('/register', '/login', const RegisterScreen()),
    ('/forgot-password', '/login', const ForgotPasswordScreen()),
    ('/not-found', '/translate', const WordNotFoundScreen()),
    ('/spelling', '/translate', const SpellingScreen()),
    ('/history', '/profile', const HistoryScreen()),
    ('/settings', '/profile', const SettingsScreen()),
    ('/premium', '/home', const PremiumScreen()),
    ('/admin/users', '/admin', const AdminUsersScreen()),
    ('/admin/dictionary', '/admin', const DictionaryManagementScreen()),
  ]) {
    testWidgets('$path muestra Volver en acceso directo', (tester) async {
      final controller = AppController(
        signRepository: _EmptyCatalogRepository(),
        userRepository: _FakeUserRepository(const []),
      );
      addTearDown(controller.dispose);
      final router = GoRouter(
        initialLocation: path,
        routes: [
          GoRoute(path: path, builder: (_, _) => screen),
          GoRoute(
            path: fallback,
            builder: (_, _) => const Scaffold(body: Text('Destino de regreso')),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: controller,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
      expect(router.canPop(), isFalse);
      expect(find.byTooltip('Volver'), findsOneWidget);
      await tester.tap(find.byTooltip('Volver'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, fallback);
      expect(find.text('Destino de regreso'), findsOneWidget);
    });
  }

  testWidgets('muestra splash y avanza al primer paso del onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppController(),
        child: const SenasApp(),
      ),
    );
    expect(find.text('SeñasApp'), findsOneWidget);
    expect(find.textContaining('Conectando personas'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();
    expect(
      find.text('Traduce texto a Lengua de Señas Colombiana'),
      findsOneWidget,
    );
    expect(find.text('Siguiente'), findsOneWidget);
  });

  testWidgets('consulta la seña de Hola en el catálogo inyectado', (
    tester,
  ) async {
    final controller = AppController(
      signRepository: _FirestoreSignRepository(),
    );
    addTearDown(controller.dispose);
    final router = createAppRouter(controller)..go('/translate');
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Hola');
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    expect(controller.currentTranslation?.originalText, 'Hola');
    expect(controller.currentTranslation?.signs.single.animationKey, 'hola');
    expect(controller.currentTranslation?.spelling, isEmpty);
    expect(router.routeInformationProvider.value.uri.path, '/translate');
    expect(find.byType(Lsc70Player), findsOneWidget);
    expect(
      find.text('Algunas señas todavía no tienen un recurso visual publicado.'),
      findsOneWidget,
    );
    expect(find.text('DEMO'), findsNothing);
  });

  testWidgets('las secciones conservan el texto y Deletreo vuelve al origen', (
    tester,
  ) async {
    final controller = AppController(signRepository: _EmptyCatalogRepository());
    addTearDown(controller.dispose);
    final router = createAppRouter(controller)..go('/home');
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Palabra sin seña');
    await tester.tap(find.text('Diccionario'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/dictionary');
    await tester.tap(find.text('Inicio'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField).first, findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Palabra sin seña',
    );

    await tester.tap(find.text('Traducir a LSC'));
    await tester.pumpAndSettle();
    expect(find.text('Deletreo'), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, '/spelling');
    expect(router.canPop(), isTrue);
    expect(find.byTooltip('Volver'), findsOneWidget);
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/home');
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Palabra sin seña',
    );
  });

  testWidgets('enlace directo a Deletreo sin resultado abre Traducir', (
    tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    final router = createAppRouter(controller)..go('/spelling');
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/translate');
    expect(find.text('Traducción'), findsOneWidget);
  });

  testWidgets('detalle del diccionario cabe en lienzo y pantalla estrecha', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.reset);
    final controller = AppController(
      signRepository: _PublishedCatalogRepository(),
    );
    addTearDown(controller.dispose);
    final router = createAppRouter(controller)..go('/dictionary');
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hola').first);
    await tester.pumpAndSettle();
    final sheetSurface = find
        .descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(Material),
        )
        .first;
    expect(tester.getRect(sheetSurface).width, lessThanOrEqualTo(430));

    router.pop();
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hola').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Traducir este término').hitTestable(), findsOneWidget);
  });

  testWidgets('Deletreo conserva regreso y jerarquía en tamaños móviles', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final controller = AppController(signRepository: _EmptyCatalogRepository());
    addTearDown(controller.dispose);
    await controller.translateRoute('D');
    final router = createAppRouter(controller)..go('/spelling');
    addTearDown(router.dispose);

    for (final size in [
      const Size(320, 640),
      const Size(390, 844),
      const Size(430, 844),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: controller,
          child: MaterialApp.router(
            routerConfig: router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.3)),
              child: child!,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Pantalla $size');
      expect(find.byTooltip('Volver').hitTestable(), findsOneWidget);
      expect(find.text('Letra 1 de 1'), findsOneWidget);
    }
  });

  testWidgets(
    'el panel administrador navega sin menú lateral y permite volver',
    (tester) async {
      final controller = AppController(
        translationRepository: _FakeDashboardRepository(),
      );
      addTearDown(controller.dispose);
      final router = GoRouter(
        initialLocation: '/admin',
        routes: [
          GoRoute(
            path: '/admin',
            builder: (_, _) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (_, _) => const Scaffold(body: Text('Destino personas')),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, _) => const Scaffold(body: Text('Destino perfil')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: controller,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Drawer), findsNothing);
      expect(find.byTooltip('Abrir menú'), findsNothing);
      expect(find.text('Gestionar personas'), findsOneWidget);
      expect(find.text('Gestionar diccionario'), findsOneWidget);

      await tester.tap(find.text('Gestionar personas'));
      await tester.pumpAndSettle();
      expect(find.text('Destino personas'), findsOneWidget);
      expect(router.canPop(), isTrue);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('Panel Administrador'), findsOneWidget);

      await tester.tap(find.byTooltip('Volver'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/profile');
    },
  );

  testWidgets('las métricas caben en anchos móviles y texto ampliado', (
    tester,
  ) async {
    final controller = AppController(
      translationRepository: _FakeDashboardRepository(),
    );
    addTearDown(controller.dispose);
    for (final width in [320.0, 390.0, 430.0]) {
      for (final scale in [1.0, 1.8]) {
        await tester.binding.setSurfaceSize(Size(width, 640));
        await tester.pumpWidget(
          ChangeNotifierProvider.value(
            value: controller,
            child: MaterialApp(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: const AdminDashboardScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$width px a $scale×');
        expect(find.text('Personas'), findsOneWidget);
      }
    }
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });

  testWidgets('Gestionar diccionario vuelve al panel al abrirse desde él', (
    tester,
  ) async {
    final controller = AppController(signRepository: _EmptyCatalogRepository());
    addTearDown(controller.dispose);
    final router = GoRouter(
      initialLocation: '/admin',
      routes: [
        GoRoute(
          path: '/admin',
          builder: (_, _) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/dictionary',
          builder: (_, _) => const DictionaryManagementScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gestionar diccionario'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/admin/dictionary');
    expect(find.byTooltip('Volver'), findsOneWidget);
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/admin');
    expect(find.text('Panel Administrador'), findsOneWidget);
  });

  testWidgets('validación masiva confirma solo señas LSC70 con medio', (
    tester,
  ) async {
    final signs = _BulkValidationRepository();
    final controller = AppController(signRepository: signs);
    addTearDown(controller.dispose);
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(home: DictionaryManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Validar todas (2)'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Validar todas (2)'));
    await tester.pumpAndSettle();
    final dialogMaterial = find.ancestor(
      of: find.text('Validar todas las señas'),
      matching: find.byWidgetPredicate(
        (widget) => widget is Material && widget.type == MaterialType.card,
      ),
    ).first;
    final dialogRect = tester.getRect(dialogMaterial);
    expect(dialogRect.width, lessThanOrEqualTo(288));
    expect(dialogRect.left, greaterThanOrEqualTo(16));
    expect(dialogRect.right, lessThanOrEqualTo(304));
    expect(find.textContaining('Se publicarán 2 señas'), findsOneWidget);
    expect(find.textContaining('1 sin recurso visual'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(signs.validatedIds, isEmpty);

    await tester.tap(find.text('Validar todas (2)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Validar y publicar'));
    await tester.pumpAndSettle();
    expect(signs.validatedIds, ['hola', 'a']);
    expect(find.text('2 señas validadas y publicadas.'), findsOneWidget);
  });

  testWidgets('diálogo Validar todas conserva el lienzo móvil en escritorio', (
    tester,
  ) async {
    final controller = AppController(
      signRepository: _BulkValidationRepository(),
    );
    addTearDown(controller.dispose);
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(home: DictionaryManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Validar todas (2)'));
    await tester.pumpAndSettle();

    final dialogMaterial = find.ancestor(
      of: find.text('Validar todas las señas'),
      matching: find.byWidgetPredicate(
        (widget) => widget is Material && widget.type == MaterialType.card,
      ),
    ).first;
    final dialogRect = tester.getRect(dialogMaterial);
    expect(dialogRect.width, lessThanOrEqualTo(430));
    expect(dialogRect.center.dx, 720);
    expect(tester.takeException(), isNull);
  });

  testWidgets('una sesión invitada no puede abrir rutas de administración', (
    tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    final router = createAppRouter(controller);
    addTearDown(router.dispose);
    router.go('/login');

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    router.go('/admin/users');
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/login');
    expect(find.text('Qué gusto verte'), findsOneWidget);
  });

  testWidgets('administrador puede abrir la creación de cuentas y elegir rol', (
    tester,
  ) async {
    final controller = AppController(
      userRepository: _FakeUserRepository([
        const AppUserProfile(
          id: 'person-1',
          displayName: 'Ana Persona',
          email: 'ana@example.test',
          role: AppRole.individual,
        ),
        const AppUserProfile(
          id: 'admin-1',
          displayName: 'Admin Uno',
          email: 'admin@example.test',
          role: AppRole.admin,
        ),
      ]),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: const MaterialApp(home: AdminUsersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ana Persona'), findsOneWidget);
    expect(find.text('Persona'), findsOneWidget);
    expect(find.text('Admin Uno'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Crear persona o administrador'), findsOneWidget);

    await tester.tap(find.text('Crear persona o administrador'));
    await tester.pumpAndSettle();
    expect(find.text('Contraseña inicial'), findsOneWidget);
    expect(
      find.text(
        'Se enviará un correo para verificar la cuenta. La sesión actual no se cerrará.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byType(DropdownButtonFormField<AppRole>));
    await tester.pumpAndSettle();
    expect(find.text('Persona'), findsWidgets);
    expect(find.text('Administrador'), findsOneWidget);
  });
}

class _FakeUserRepository extends UserRepository {
  _FakeUserRepository(this.profiles);

  final List<AppUserProfile> profiles;

  @override
  Stream<List<AppUserProfile>> watchUsers() => Stream.value(profiles);
}

class _FakeDashboardRepository extends TranslationRepository {
  @override
  Future<AdminDashboardStats> getDashboardStats() async =>
      const AdminDashboardStats(
        people: 2,
        translations: 29,
        draftSigns: 0,
        untranslatedWords: 13,
      );
}

class _FirestoreSignRepository extends SignRepository {
  @override
  Future<List<SignEntry>> getPublishedSigns() async => const [
    SignEntry(
      term: 'Hola',
      category: 'Saludos',
      animationKey: 'hola',
      validated: true,
      active: true,
    ),
  ];
}

class _EmptyCatalogRepository extends SignRepository {
  @override
  Future<List<SignEntry>> getPublishedSigns() async => const [];

  @override
  Stream<List<SignEntry>> watchPublishedSigns() =>
      Stream.value(const <SignEntry>[]);

  @override
  Stream<List<SignEntry>> watchAllSigns() => Stream.value(const <SignEntry>[]);

  @override
  Stream<List<SignCategory>> watchCategories({bool includeDrafts = false}) =>
      Stream.value(const <SignCategory>[]);
}

class _BulkValidationRepository extends SignRepository {
  List<String> validatedIds = [];

  static const _media = SignMedia(
    frameUrls: ['https://res.cloudinary.com/senasapp/image/upload/hola.jpg'],
    subset: 'LSC70W',
    sourceLabel: 'Hello',
    participantId: 'Per01',
    attribution: 'LSC70 v2 · CC BY 4.0',
  );

  @override
  Stream<List<SignEntry>> watchAllSigns() => Stream.value(const [
    SignEntry(
      id: 'hola',
      term: 'Hola',
      category: 'LSC70',
      animationKey: 'hola',
      media: _media,
    ),
    SignEntry(
      id: 'a',
      term: 'A',
      category: 'Alfabeto',
      animationKey: 'a',
      media: _media,
      kind: SignKind.letter,
    ),
    SignEntry(
      id: 'sin-medio',
      term: 'Sin medio',
      category: 'Otros',
      animationKey: 'sin_medio',
    ),
    SignEntry(
      id: 'publicada',
      term: 'Publicada',
      category: 'LSC70',
      animationKey: 'publicada',
      media: _media,
      validated: true,
      active: true,
    ),
  ]);

  @override
  Stream<List<SignCategory>> watchCategories({bool includeDrafts = false}) =>
      Stream.value(const []);

  @override
  Future<int> validateSigns(List<String> ids) async {
    validatedIds = ids;
    return ids.length;
  }
}

class _PublishedCatalogRepository extends SignRepository {
  static const signs = <SignEntry>[
    SignEntry(
      id: 'hola',
      term: 'Hola',
      category: 'Saludos',
      animationKey: 'hola',
      validated: true,
      active: true,
    ),
  ];

  @override
  Stream<List<SignEntry>> watchPublishedSigns() => Stream.value(signs);

  @override
  Stream<List<SignCategory>> watchCategories({bool includeDrafts = false}) =>
      Stream.value(const [SignCategory(id: 'saludos', name: 'Saludos')]);
}
