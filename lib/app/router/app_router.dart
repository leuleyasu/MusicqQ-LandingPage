import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/onboarding/presentation/pages/create_organization_account_page.dart';
import '../../features/onboarding/presentation/pages/how_it_works_page.dart';
import 'app_routes.dart';

GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.landing,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: AppRoutes.howItWorks,
        builder: (context, state) => const HowItWorksPage(),
      ),
      GoRoute(
        path: AppRoutes.createOrgAccount,
        builder: (context, state) => const CreateOrganizationAccountPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text(
          state.error?.toString() ?? 'Route not found',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

