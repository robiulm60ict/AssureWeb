import 'package:assure_apps/model/buliding_model.dart';
import 'package:assure_apps/view/building/building_update/building_update.dart';

import '../view/building/building_setup/building_setup.dart';
import '../view/building/building_view/building_view.dart';
import '../view/building_sale/building_sale_setup/building_sale_setup.dart';
import '../view/building_sale/sale_building_list/building_view/sale_building_view.dart';
import '../view/entry_point.dart';
import '../view/sign_in_page/sign_in_page.dart';
import 'package:go_router/go_router.dart';

import '../view/splash/splash_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      // path: '/',
      path: '/sign-in',
      builder: (context, state) => SignInPage(),
    ),
    GoRoute(
      path: '/buildingSetup',
      builder: (context, state) => BuildingSetup(),
    ),
    GoRoute(
      path: '/buildingUpdate',
      builder: (context, state) {
        // Safely cast the extra data to BuildingModel? (nullable)
        final buildingData = state.extra as BuildingModel?;

        return BuildingUpdate(model: buildingData);
      },
    ),

    GoRoute(
      path: '/buildingView',
      builder: (context, state) => BuildingView(),
    ),

    // GoRoute(
    //   // path: '/',
    //   path: '/buildingSaleSetup',
    //   builder: (context, state) => const BuildingSaleSetup(),
    // ),
    GoRoute(
      // path: '/',
      path: '/saleBuildingListView',
      builder: (context, state) => const SaleBuildingListView(),
    ),
    GoRoute(
      path: '/entry-point',
      builder: (context, state) => const EntryPoint(),
    ),

    // GoRoute(
    //   path: '/forgot-password',
    //   builder: (context, state) => const ForgotPasswordScreen(),
    // ),
    // GoRoute(
    //   path: '/password-confirmation/:email',
    //   builder: (context, state) {
    //     final email = state.pathParameters['email'];
    //     if (email == null) {
    //       throw Exception('Recipe ID is missing');
    //     }
    //     return PasswordConfirmationForm(email: email);
    //   },
    // ),
    // GoRoute(
    //   path: '/resend-email-verification',
    //   builder: (context, state) => const EmailResendScreen(),
    // ),
    // GoRoute(
    //   path: '/user-confirmation/:email',
    //   builder: (context, state) {
    //     final email = state.pathParameters['email'];
    //     if (email == null) {
    //       throw Exception('Recipe ID is missing');
    //     }
    //     return UserConfirmationForm(email: email);
    //   },
    // ),
    // GoRoute(
    //   path: '/favorite',
    //   builder: (context, state) => const FavoriteScreen(),
    // ),
    // GoRoute(
    //   path: '/recipe/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id'];
    //     if (id == null) {
    //       throw Exception('Recipe ID or Favorite state is missing');
    //     }
    //     return RecipeDetailsScreen(
    //       id: id,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: '/profile',
    //   builder: (context, state) => const ProfileScreen(),
    // ),
    // GoRoute(
    //   path: '/edit-profile',
    //   builder: (context, state) => const EditProfileScreen(),
    // ),
    // GoRoute(
    //   path: '/all-recipes',
    //   builder: (context, state) => const AllRecipesScreen(),
    // ),
    // GoRoute(
    //   path: '/search-recipes',
    //   builder: (context, state) => const SearchScreen(),
    // ),
    // GoRoute(
    //   path: '/notifications',
    //   builder: (context, state) => const NotificationsScreen(),
    // ),
  ],
);
