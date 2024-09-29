
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';






class AppRoutes{
  static pushReplacement(context, {required page, type})    => Navigator.pushReplacement(context, PageTransition(type: type ?? PageTransitionType.fade, duration: const Duration(milliseconds: 400),child: page));
  static push(context, {required page, type})               => Navigator.push(context, PageTransition(type: type ?? PageTransitionType.fade, duration: const Duration(milliseconds: 400),child: page));
  static pushAndRemoveUntil(context, {required page, type}) => Navigator.pushAndRemoveUntil(context, PageTransition(type: type ?? PageTransitionType.fade, duration: const Duration(milliseconds: 400),child: page), (route) => false);
  static pop(context)                                       => Navigator.pop(context);
}

// final routerConfig = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const SplashScreen(),
//     ),
//     GoRoute(
//       // path: '/',
//       path: '/sign-in',
//       builder: (context, state) => SignInPage(),
//     ),
//     GoRoute(
//       path: '/buildingSetup',
//       builder: (context, state) => BuildingSetup(),
//     ),
//     GoRoute(
//       path: '/buildingUpdate',
//       builder: (context, state) {
//         // Safely cast the extra data to BuildingModel? (nullable)
//         final buildingData = state.extra as BuildingModel?;
//
//         return BuildingUpdate(model: buildingData);
//       },
//     ),
//
//     GoRoute(
//       path: '/buildingView',
//       builder: (context, state) => BuildingView(),
//     ),
//
//     // GoRoute(
//     //   // path: '/',
//     //   path: '/buildingSaleSetup',
//     //   builder: (context, state) => const BuildingSaleSetup(),
//     // ),
//     GoRoute(
//       // path: '/',
//       path: '/saleBuildingListView',
//       builder: (context, state) => const SaleBuildingListView(),
//     ),
//     GoRoute(
//       path: '/entry-point',
//       builder: (context, state) => const EntryPoint(),
//     ),
//
//     // GoRoute(
//     //   path: '/forgot-password',
//     //   builder: (context, state) => const ForgotPasswordScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/password-confirmation/:email',
//     //   builder: (context, state) {
//     //     final email = state.pathParameters['email'];
//     //     if (email == null) {
//     //       throw Exception('Recipe ID is missing');
//     //     }
//     //     return PasswordConfirmationForm(email: email);
//     //   },
//     // ),
//     // GoRoute(
//     //   path: '/resend-email-verification',
//     //   builder: (context, state) => const EmailResendScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/user-confirmation/:email',
//     //   builder: (context, state) {
//     //     final email = state.pathParameters['email'];
//     //     if (email == null) {
//     //       throw Exception('Recipe ID is missing');
//     //     }
//     //     return UserConfirmationForm(email: email);
//     //   },
//     // ),
//     // GoRoute(
//     //   path: '/favorite',
//     //   builder: (context, state) => const FavoriteScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/recipe/:id',
//     //   builder: (context, state) {
//     //     final id = state.pathParameters['id'];
//     //     if (id == null) {
//     //       throw Exception('Recipe ID or Favorite state is missing');
//     //     }
//     //     return RecipeDetailsScreen(
//     //       id: id,
//     //     );
//     //   },
//     // ),
//     // GoRoute(
//     //   path: '/profile',
//     //   builder: (context, state) => const ProfileScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/edit-profile',
//     //   builder: (context, state) => const EditProfileScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/all-recipes',
//     //   builder: (context, state) => const AllRecipesScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/search-recipes',
//     //   builder: (context, state) => const SearchScreen(),
//     // ),
//     // GoRoute(
//     //   path: '/notifications',
//     //   builder: (context, state) => const NotificationsScreen(),
//     // ),
//   ],
// );
