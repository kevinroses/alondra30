import 'dart:io';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/Favourite/UpdateFavProvider.dart';
import 'package:eshop_multivendor/Provider/NotificationProvider.dart';
import 'package:eshop_multivendor/Provider/ProductProvider.dart';
import 'package:eshop_multivendor/Provider/Search/SearchProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Provider/explore_provider.dart';
import 'package:eshop_multivendor/Provider/authenticationProvider.dart';
import 'package:eshop_multivendor/Provider/myWalletProvider.dart';
import 'package:eshop_multivendor/Provider/paymentProvider.dart';
import 'package:eshop_multivendor/Screen/SplashScreen/Splash.dart';
import 'package:eshop_multivendor/cubits/appSettingsCubit.dart';
import 'package:eshop_multivendor/cubits/brandsListCubit.dart';
import 'package:eshop_multivendor/cubits/languageCubit.dart';
import 'package:eshop_multivendor/cubits/makeMeOnlineCubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eshop_multivendor/cubits/loadCountryCodeCubit.dart';
import 'package:eshop_multivendor/cubits/personalConverstationsCubit.dart';
import 'package:eshop_multivendor/cubits/predefinesReturnReasonCubit.dart';
import 'package:eshop_multivendor/repository/brandsRepository.dart';
import 'package:eshop_multivendor/repository/chatRepository.dart';
import 'package:eshop_multivendor/repository/hiveRepository.dart';
import 'package:eshop_multivendor/repository/predefinedReturnReasonRepository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/String.dart';
import 'Screen/Language/Demo_Localization.dart';
import 'Provider/FaqsProvider.dart';
import 'Provider/Favourite/FavoriteProvider.dart';
import 'Provider/ManageAddressProvider.dart';
import 'Provider/Order/OrderProvider.dart';
import 'Provider/Order/UpdateOrderProvider.dart';
import 'Provider/addressProvider.dart';
import 'Provider/chatProvider.dart';
import 'Provider/customerSupportProvider.dart';
import 'Provider/homePageProvider.dart';
import 'Provider/productDetailProvider.dart';
import 'Provider/ReviewGallleryProvider.dart';
import 'Provider/ReviewPreviewProvider.dart';
import 'Provider/Theme.dart';
import 'Provider/SettingProvider.dart';
import 'Provider/faqProvider.dart';
import 'Provider/productListProvider.dart';
import 'Provider/promoCodeProvider.dart';
import 'Provider/pushNotificationProvider.dart';
import 'Provider/sellerDetailProvider.dart';
import 'Provider/systemProvider.dart';
import 'Provider/userWalletProvider.dart';
import 'Provider/writeReviewProvider.dart';
import 'Provider/DiscountProvider.dart';
import 'Screen/Dashboard/Dashboard.dart';
import 'firebase_options.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

// Variable global para acceder a SettingProvider sin context
SettingProvider? globalSettingsProvider;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // No glow effect
  }
}

Future<void> initializedDownload() async {
  if (!kIsWeb) {
    await FlutterDownloader.initialize(
      debug: false,
      ignoreSsl: true,
    );
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización correcta de Firebase para Web, Android e iOS
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar Hive
  await Hive.initFlutter();
  await HiveRepository.init();

  // Inicializar FlutterDownloader
  await initializedDownload();


  // Configuración de SystemChrome
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Permitir certificados SSL inválidos (solo para desarrollo)
  HttpOverrides.global = MyHttpOverrides();

  // Manejo de errores en release mode
  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) => Center(
      child: Text(
        flutterErrorDetails.toString(),
      ),
    );
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {
          String? theme = prefs.getString(APP_THEME);

          if (theme == DARK) {
            ISDARK = 'true';
          } else if (theme == LIGHT) {
            ISDARK = 'false';
          }

          if (theme == null || theme == '' || theme == DEFAULT_SYSTEM) {
            prefs.setString(APP_THEME, DEFAULT_SYSTEM);
            var brightness =
                SchedulerBinding.instance.platformDispatcher.platformBrightness;
            ISDARK = (brightness == Brightness.dark).toString();

            return ThemeNotifier(ThemeMode.system);
          }

          return ThemeNotifier(theme == LIGHT ? ThemeMode.light : ThemeMode.dark);
        },
      ),
      Provider<SettingProvider>(
        create: (context) => SettingProvider(prefs),
      ),
      ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
      ChangeNotifierProvider<HomePageProvider>(
          create: (context) => HomePageProvider()),
      ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider()),
      ChangeNotifierProvider<ProductDetailProvider>(
          create: (context) => ProductDetailProvider()),
      ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider()),
      ChangeNotifierProvider<OrderProvider>(create: (context) => OrderProvider()),
      ChangeNotifierProvider<CartProvider>(create: (context) => CartProvider()),
      ChangeNotifierProvider<ExploreProvider>(
          create: (context) => ExploreProvider()),
      ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider()),
      ChangeNotifierProvider<FaqsProvider>(create: (context) => FaqsProvider()),
      ChangeNotifierProvider<PromoCodeProvider>(
          create: (context) => PromoCodeProvider()),
      ChangeNotifierProvider<SystemProvider>(
          create: (context) => SystemProvider()),
      ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
      ChangeNotifierProvider<ProductListProvider>(
          create: (context) => ProductListProvider()),
      ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider()),
      ChangeNotifierProvider<FaQProvider>(create: (context) => FaQProvider()),
      ChangeNotifierProvider<ReviewGallaryProvider>(
          create: (context) => ReviewGallaryProvider()),
      ChangeNotifierProvider<ReviewPreviewProvider>(
          create: (context) => ReviewPreviewProvider()),
      ChangeNotifierProvider<UpdateFavProvider>(
          create: (context) => UpdateFavProvider()),
      ChangeNotifierProvider<UserTransactionProvider>(
          create: (context) => UserTransactionProvider()),
      ChangeNotifierProvider<DiscountProvider>(
          create: (context) => DiscountProvider()),
      ChangeNotifierProvider<MyWalletProvider>(
          create: (context) => MyWalletProvider()),
      ChangeNotifierProvider<PaymentProvider>(
          create: (context) => PaymentProvider()),
      ChangeNotifierProvider<SellerDetailProvider>(
          create: (context) => SellerDetailProvider()),
      ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider()),
      ChangeNotifierProvider<PushNotificationProvider>(
          create: (context) => PushNotificationProvider()),
      ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider()),
      ChangeNotifierProvider<ManageAddrProvider>(
          create: (context) => ManageAddrProvider()),
      ChangeNotifierProvider<UpdateOrdProvider>(
          create: (context) => UpdateOrdProvider()),
      ChangeNotifierProvider<WriteReviewProvider>(
          create: (context) => WriteReviewProvider()),
      ChangeNotifierProvider<AddressProvider>(
          create: (context) => AddressProvider()),
      ChangeNotifierProvider<CustomerSupportProvider>(
          create: (context) => CustomerSupportProvider()),
      ChangeNotifierProvider<ChatProvider>(create: (context) => ChatProvider()),
      BlocProvider<PersonalConverstationsCubit>(
          create: (context) => PersonalConverstationsCubit(ChatRepository())),
      BlocProvider<BrandsListCubit>(
        create: (context) => BrandsListCubit(
          brandsRepository: BrandsRepository(),
        ),
      ),
      BlocProvider<AppSettingsCubit>(
        create: (context) => AppSettingsCubit(),
      ),
      BlocProvider<CountryCodeCubit>(
        create: (context) => CountryCodeCubit(),
      ),
      BlocProvider<PredefinedReturnReasonListCubit>(
        create: (context) => PredefinedReturnReasonListCubit(
            predefinedReasonRepository: PredefinedReasonRepository()),
      ),
      BlocProvider(
        create: (context) => LanguageCubit(),
      ),
      BlocProvider(create: (context) => MakeMeOnlineCubit(ChatRepository()))
    ],
    child: MyApp(sharedPreferences: prefs),
  ));
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    globalSettingsProvider = SettingProvider(widget.sharedPreferences);
    context.read<LanguageCubit>().loadCurrentLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return MaterialApp(
          locale: (languageState is LanguageLoader)
              ? Locale(languageState.languageCode)
              : Locale(defaultLanguageCode),
          supportedLocales: appLanguages
              .map(
                  (language) => getLocaleFromLanguageCode(language.languageCode))
              .toList(),
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          navigatorKey: navigatorKey,
          title: appName,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const Splash(),
            '/home': (context) => Dashboard(
              key: Dashboard.dashboardScreenKey,
            ),
          },
          themeMode: themeNotifier.getThemeMode(),
          theme: ThemeData(
            useMaterial3: false,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: colors.primary_app,
            ).copyWith(
              secondary: colors.darkIcon,
              brightness: Brightness.light,
            ),
            canvasColor: Theme.of(context).colorScheme.lightWhite,
            cardColor: Theme.of(context).colorScheme.white,
            fontFamily: 'ubuntu',
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: false,
            brightness: Brightness.dark,
            canvasColor: colors.darkColor,
            cardColor: colors.darkColor2,
            fontFamily: 'ubuntu',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: colors.primary_app,
            ).copyWith(
              secondary: colors.darkIcon,
              brightness: Brightness.dark,
            ),
          ),
        );
      },
    );
  }
}
