import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/nighttrack_colors.dart';
import '../../../../core/ui/glass_card.dart';
import '../bloc/landing_cubit.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LandingCubit>(
      create: (_) => LandingCubit(),
      child: const _LandingView(),
    );
  }
}

class _LandingView extends StatefulWidget {
  const _LandingView();

  @override
  State<_LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<_LandingView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Scaffold(
      backgroundColor: NightTrackColors.bg,
      body: Stack(
        children: [
          const _NightBackdrop(),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: NightTrackColors.bg.withValues(alpha: 0.78),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: const _TopDividerGlow(),
                titleSpacing: 18,
                title: _TopNav(isWide: isWide),
                actions: isWide
                    ? null
                    : [
                        IconButton(
                          tooltip: 'Menu',
                          onPressed: () => showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const _MobileMenu(),
                          ),
                          icon: const Icon(Icons.menu_rounded),
                        ),
                        const SizedBox(width: 8),
                      ],
              ),
              const SliverToBoxAdapter(child: _HeroSection()),
              const SliverToBoxAdapter(child: _OnboardingSection()),
              const SliverToBoxAdapter(child: _FeaturesSection()),
              const SliverToBoxAdapter(child: _AISection()),
              const SliverToBoxAdapter(child: _Footer()),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Nav ───────────────────────────────────────────────────────────────────

class _TopNav extends StatelessWidget {
  const _TopNav({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _Brand(),
        if (isWide) ...[
          const Spacer(),
          const _TopNavLinkRow(),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'Log In',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: NightTrackColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _TopPillButton(
            label: 'Create Account',
            onTap: () => context.go(AppRoutes.createOrgAccount),
          ),
        ],
      ],
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: NightTrackColors.primary,
            boxShadow: [
              BoxShadow(
                color: NightTrackColors.primary.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.music_note_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'MusicQ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
            color: NightTrackColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TopNavLinkRow extends StatelessWidget {
  const _TopNavLinkRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TopLink(label: 'Features'),
        _TopLink(label: 'Dashboard'),
        _TopLink(label: 'Solutions'),
        _TopLink(label: 'Analytics'),
      ],
    );
  }
}

class _TopLink extends StatelessWidget {
  const _TopLink({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: NightTrackColors.textSecondary,
        ),
      ),
    );
  }
}

class _TopPillButton extends StatelessWidget {
  const _TopPillButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: NightTrackColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'NightTrack',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              _MenuItem(
                label: 'How it works',
                onTap: () => context.go(AppRoutes.howItWorks),
              ),
              _MenuItem(
                label: 'Create account',
                onTap: () => context.go(AppRoutes.createOrgAccount),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

// ─── Hero ──────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, isWide ? 100 : 64, 18, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _HeroBadge()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 24),
              _HeroHeadline(isWide: isWide)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'The first comprehensive operating system designed specifically for night clubs, bars, and live venues. Sync your staff, sound, and sales in real-time.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: NightTrackColors.textSecondary,
                    height: 1.6,
                    letterSpacing: 0.1,
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
              const SizedBox(height: 48),
              Wrap(
                spacing: 22,
                runSpacing: 14,
                alignment: WrapAlignment.center,
                children: [
                  _HeroPrimaryButton(
                    label: 'Create Organization',
                    onTap: () => context.go(AppRoutes.createOrgAccount),
                  ),
                  _HeroSecondaryButton(
                    label: 'See Pricing',
                    onTap: () => context.go(AppRoutes.howItWorks),
                  ),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        (isWide
                ? Theme.of(context).textTheme.displayLarge
                : Theme.of(context).textTheme.headlineLarge)
            ?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: -1.8,
            );

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: baseStyle?.copyWith(color: NightTrackColors.textPrimary),
            children: [
              const TextSpan(text: 'Ready to Own\n'),
              TextSpan(
                text: 'the After Hours.',
                style: TextStyle(
                  color: NightTrackColors.primary,
                  shadows: [
                    Shadow(
                      color: NightTrackColors.primary.withValues(alpha: 0.4),
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: NightTrackColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: NightTrackColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: NightTrackColors.primary,
                  shape: BoxShape.circle,
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                duration: 1.seconds,
                begin: const Offset(1, 1),
                end: const Offset(1.5, 1.5),
                curve: Curves.easeInOut,
              )
              .fadeOut(),
          const SizedBox(width: 10),
          Text(
            'NOW IN PRIVATE BETA',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NightTrackColors.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroPrimaryButton extends StatelessWidget {
  const _HeroPrimaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: NightTrackColors.textPrimary,
        foregroundColor: NightTrackColors.bg,
        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: NightTrackColors.bg,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _HeroSecondaryButton extends StatelessWidget {
  const _HeroSecondaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: NightTrackColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 24),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

// ─── Onboarding ────────────────────────────────────────────────────────────

class _OnboardingSection extends StatelessWidget {
  const _OnboardingSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 340, child: _OnboardingLeft()),
                    SizedBox(width: 24),
                    Expanded(child: _OnboardingRight()),
                  ],
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OnboardingLeft(),
                    SizedBox(height: 20),
                    _OnboardingRight(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _OnboardingLeft extends StatelessWidget {
  const _OnboardingLeft();

  @override
  Widget build(BuildContext context) {
    final h = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Go Live in',
          style: h.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            color: NightTrackColors.textPrimary.withValues(alpha: 0.72),
          ),
        ),
        Text(
          'Minutes.',
          style: h.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            color: NightTrackColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        const _OnboardingStepTile(
          step: OnboardingStep.registerVenue,
          title: 'Register Venue',
          subtitle: 'Define your floor plan, VIP zones, and DJ stations.',
          icon: Icons.place_rounded,
        ),
        const SizedBox(height: 12),
        const _OnboardingStepTile(
          step: OnboardingStep.configureStaff,
          title: 'Configure Staff',
          subtitle: 'Assign roles for door staff, bouncers, and managers.',
          icon: Icons.verified_user_rounded,
        ),
        const SizedBox(height: 12),
        const _OnboardingStepTile(
          step: OnboardingStep.liveSync,
          title: 'Live Sync',
          subtitle: 'Connect sound system and POS for real-time tracking.',
          icon: Icons.wifi_tethering_rounded,
        ),
      ],
    );
  }
}

class _OnboardingStepTile extends StatelessWidget {
  const _OnboardingStepTile({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final OnboardingStep step;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingCubit, LandingState>(
      buildWhen: (p, n) => p.onboardingStep != n.onboardingStep,
      builder: (context, state) {
        final selected = state.onboardingStep == step;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.read<LandingCubit>().setOnboardingStep(step),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: selected
                  ? NightTrackColors.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              border: Border.all(
                color: selected
                    ? NightTrackColors.primary.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: selected
                        ? NightTrackColors.primary
                        : Colors.white.withValues(alpha: 0.05),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: NightTrackColors.primary.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? Colors.white
                        : NightTrackColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: selected
                                  ? NightTrackColors.textPrimary
                                  : NightTrackColors.textPrimary.withValues(
                                      alpha: 0.6,
                                    ),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                          color: NightTrackColors.textSecondary.withValues(
                            alpha: selected ? 0.9 : 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: NightTrackColors.primary,
                  ).animate().fadeIn().slideX(begin: -0.5, end: 0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingRight extends StatelessWidget {
  const _OnboardingRight();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandingCubit, LandingState>(
      buildWhen: (p, n) => p.onboardingStep != n.onboardingStep,
      builder: (context, state) {
        final data = _onboardingPreview(state.onboardingStep);

        return GlassCard(
              padding: EdgeInsets.zero,
              borderRadius: 28,
              child: Container(
                height: 480,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      NightTrackColors.surface,
                      NightTrackColors.surface.withValues(alpha: 0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: NightTrackColors.primary.withValues(
                            alpha: 0.05,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'LIVE STATUS',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: NightTrackColors.textSecondary,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.more_horiz_rounded,
                                color: NightTrackColors.textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _PreviewIcon(icon: data.icon),
                                const SizedBox(height: 32),
                                Text(
                                  data.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: NightTrackColors.textPrimary,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  data.subtitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: NightTrackColors.textSecondary,
                                        height: 1.5,
                                      ),
                                ),
                                const SizedBox(height: 40),
                                _MockChart(step: state.onboardingStep),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const _PreviewFooter(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate(key: ValueKey(state.onboardingStep))
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.02, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _PreviewIcon extends StatelessWidget {
  const _PreviewIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: NightTrackColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NightTrackColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Icon(icon, color: NightTrackColors.primary, size: 32),
    );
  }
}

class _MockChart extends StatelessWidget {
  const _MockChart({required this.step});
  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(12, (index) {
          final height = (index % 3 + 2) * 15.0;
          return Container(
            width: 8,
            height: height,
            decoration: BoxDecoration(
              color: index == 7
                  ? NightTrackColors.primary
                  : NightTrackColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _PreviewFooter extends StatelessWidget {
  const _PreviewFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: NightTrackColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '60% Ready',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: NightTrackColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Features ──────────────────────────────────────────────────────────────

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isWide = w >= 980;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Built for the',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: NightTrackColors.textPrimary.withValues(alpha: 0.55),
                  letterSpacing: -0.8,
                ),
              ),
              Text(
                'Night Economy.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: NightTrackColors.primary.withValues(alpha: 0.80),
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text(
                  'Everything you need to run a modern entertainment venue from a single interface.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NightTrackColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = isWide ? 3 : (w >= 700 ? 2 : 1);
                  const spacing = 16.0;
                  final tileWidth =
                      (constraints.maxWidth - spacing * (columns - 1)) /
                      columns;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (final item in _featureItems)
                        SizedBox(
                          width: tileWidth,
                          child: _FeatureTile(
                            icon: item.icon,
                            title: item.title,
                            body: item.body,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: NightTrackColors.surface.withValues(alpha: 0.60),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: NightTrackColors.primary.withValues(alpha: 0.12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: NightTrackColors.primary.withValues(alpha: 0.90),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: NightTrackColors.textPrimary.withValues(alpha: 0.90),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: NightTrackColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AI Section ────────────────────────────────────────────────────────────

class _AISection extends StatelessWidget {
  const _AISection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 100,
                left: -100,
                child:
                    Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: NightTrackColors.primary.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(
                          begin: -20,
                          end: 20,
                          duration: 4.seconds,
                          curve: Curves.easeInOut,
                        ),
              ),
              GlassCard(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64 : 24,
                  vertical: isWide ? 80 : 48,
                ),
                borderRadius: 48,
                child: isWide
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _AICopy()),
                          SizedBox(width: 80),
                          SizedBox(width: 440, child: _AIChatPanel()),
                        ],
                      )
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _AICopy(),
                          SizedBox(height: 64),
                          _AIChatPanel(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AICopy extends StatelessWidget {
  const _AICopy();

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: -1.2,
      height: 1.1,
      color: NightTrackColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: NightTrackColors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: NightTrackColors.teal.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            'INTELLIGENT INSIGHTS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: NightTrackColors.teal,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: headStyle,
            children: [
              const TextSpan(text: 'AI Assistant for\n'),
              TextSpan(
                text: 'Smart Hosting.',
                style: TextStyle(
                  color: NightTrackColors.primary,
                  shadows: [
                    Shadow(
                      color: NightTrackColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          "Predict demand, automate queue messaging, and let our AI handle dynamic pricing for VIP requests. NightTrack AI learns your venue's rhythm to maximize revenue.",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: NightTrackColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        const _AIInfoCard(
          icon: Icons.trending_up_rounded,
          title: 'Dynamic Pricing Engine',
          body: 'Automatically adjusts pricing based on capacity and demand.',
        ),
        const SizedBox(height: 16),
        const _AIInfoCard(
          icon: Icons.auto_graph_rounded,
          title: 'Predictive Staffing',
          body:
              'Anticipate rushes before they happen with historical modeling.',
        ),
      ],
    );
  }
}

class _AIInfoCard extends StatelessWidget {
  const _AIInfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withValues(alpha: 0.05),
          ),
          child: Icon(icon, size: 20, color: NightTrackColors.primary),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: NightTrackColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: NightTrackColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AIChatPanel extends StatelessWidget {
  const _AIChatPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color(0xFF0F0E24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: NightTrackColors.primary,
                child: Icon(Icons.auto_awesome, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MusicQ AI',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: NightTrackColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Active Now',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: NightTrackColors.teal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _ChatBubble(
            isAI: false,
            text: "What's the outlook for tonight's peak hours?",
          ),
          const SizedBox(height: 16),
          _ChatBubble(
            isAI: true,
            text:
                "Based on pre-bookings, expect a 25% surge at 11:30 PM. I've prepared a dynamic pricing update for VIP entry.",
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Type a command...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NightTrackColors.textSecondary.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.send_rounded,
                  size: 18,
                  color: NightTrackColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.isAI, required this.text});
  final bool isAI;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isAI
              ? NightTrackColors.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isAI ? 4 : 16),
            bottomRight: Radius.circular(isAI ? 16 : 4),
          ),
          border: Border.all(
            color: isAI
                ? NightTrackColors.primary.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isAI
                ? NightTrackColors.textPrimary
                : NightTrackColors.textSecondary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─── Footer ────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Divider(color: Colors.white.withValues(alpha: 0.08)),
              const SizedBox(height: 28),
              if (isWide)
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _FooterBrand()),
                    SizedBox(width: 40),
                    Expanded(
                      child: _FooterLinks(
                        title: 'Product',
                        items: [
                          'Venue Manager',
                          'Live Requests',
                          'Queue Monitor',
                          'AI Assistant',
                        ],
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _FooterLinks(
                        title: 'Resources',
                        items: [
                          'Case Studies',
                          'Partner Program',
                          'Developer API',
                          'Privacy Policy',
                        ],
                      ),
                    ),
                  ],
                )
              else
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterBrand(),
                    SizedBox(height: 24),
                    _FooterLinks(
                      title: 'Product',
                      items: [
                        'Venue Manager',
                        'Live Requests',
                        'Queue Monitor',
                        'AI Assistant',
                      ],
                    ),
                    SizedBox(height: 24),
                    _FooterLinks(
                      title: 'Resources',
                      items: [
                        'Case Studies',
                        'Partner Program',
                        'Developer API',
                        'Privacy Policy',
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 34),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
              const SizedBox(height: 22),
              if (isWide)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '© ${DateTime.now().year} NIGHTTRACK OS. ALL RIGHTS RESERVED.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: NightTrackColors.textSecondary.withValues(
                            alpha: 0.60,
                          ),
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'ENGINEERED FOR THE AFTER HOURS.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: NightTrackColors.textSecondary.withValues(
                          alpha: 0.60,
                        ),
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  '© ${DateTime.now().year} NIGHTTRACK OS. ALL RIGHTS RESERVED.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: NightTrackColors.textSecondary.withValues(
                      alpha: 0.60,
                    ),
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Brand(),
        const SizedBox(height: 16),
        Text(
          'Transforming the nightlife experience through elegant technology and seamless real-time engagement.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: NightTrackColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _SocialDot(onTap: () {}, icon: Icons.alternate_email_rounded),
            const SizedBox(width: 10),
            _SocialDot(onTap: () {}, icon: Icons.language_rounded),
            const SizedBox(width: 10),
            _SocialDot(onTap: () {}, icon: Icons.linked_camera_rounded),
          ],
        ),
      ],
    );
  }
}

class _SocialDot extends StatelessWidget {
  const _SocialDot({required this.onTap, required this.icon});
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withValues(alpha: 0.06),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(icon, size: 17, color: NightTrackColors.textSecondary),
      ),
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({required this.title, required this.items});
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: NightTrackColors.textPrimary.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 14),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: NightTrackColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Background ────────────────────────────────────────────────────────────

class _TopDividerGlow extends StatelessWidget {
  const _TopDividerGlow();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              NightTrackColors.primary.withValues(alpha: 0.30),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _NightBackdrop extends StatelessWidget {
  const _NightBackdrop();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(color: NightTrackColors.bg),
          const _Glow(
            alignment: Alignment(-0.7, -0.6),
            size: 500,
            color: NightTrackColors.primary,
            opacity: 0.12,
          ),
          const _Glow(
            alignment: Alignment(0.75, -0.45),
            size: 400,
            color: NightTrackColors.accent,
            opacity: 0.10,
          ),
          const _Glow(
            alignment: Alignment(0.5, 0.8),
            size: 500,
            color: NightTrackColors.primary,
            opacity: 0.08,
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.alignment,
    required this.size,
    required this.color,
    required this.opacity,
  });
  final Alignment alignment;
  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ───────────────────────────────────────────────────────────────

_OnboardingPreviewData _onboardingPreview(OnboardingStep step) {
  switch (step) {
    case OnboardingStep.registerVenue:
      return const _OnboardingPreviewData(
        icon: Icons.place_rounded,
        title: 'Register Venue',
        subtitle: 'Define your floor plan, VIP zones, and DJ stations.',
      );
    case OnboardingStep.configureStaff:
      return const _OnboardingPreviewData(
        icon: Icons.verified_user_rounded,
        title: 'Configure Staff',
        subtitle: 'Assign roles for door staff, bouncers, and managers.',
      );
    case OnboardingStep.liveSync:
      return const _OnboardingPreviewData(
        icon: Icons.wifi_tethering_rounded,
        title: 'Live Sync',
        subtitle: 'Connect your sound system and POS for real-time tracking.',
      );
  }
}

class _OnboardingPreviewData {
  const _OnboardingPreviewData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
}

const _featureItems = <_FeatureItem>[
  _FeatureItem(
    icon: Icons.music_note_rounded,
    title: 'Live Music Requests',
    body:
        'Let guests request their favorite tracks directly from their phones with integrated tipping.',
  ),
  _FeatureItem(
    icon: Icons.bar_chart_rounded,
    title: 'Revenue Analytics',
    body:
        'Monitor real-time sales, drink trends, and ticket revenue with visual heatmaps.',
  ),
  _FeatureItem(
    icon: Icons.groups_2_rounded,
    title: 'Queue Management',
    body:
        'Efficiently track guest check-ins, VIP entries, and door traffic in real time.',
  ),
  _FeatureItem(
    icon: Icons.local_activity_rounded,
    title: 'VIP Access Control',
    body:
        'Coordinate premium entry flows, bottle service requests, and table status from one panel.',
  ),
  _FeatureItem(
    icon: Icons.badge_rounded,
    title: 'Staff Orchestration',
    body:
        'Keep security, hosts, and floor managers aligned with live assignments and clear handoffs.',
  ),
  _FeatureItem(
    icon: Icons.bolt_rounded,
    title: 'Demand Signals',
    body:
        'Spot spikes in traffic early and adjust pricing, staffing, and guest messaging before lines build.',
  ),
];

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}
