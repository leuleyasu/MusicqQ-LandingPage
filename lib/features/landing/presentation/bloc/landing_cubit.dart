import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum LandingSection {
  hero,
  features,
  operations,
  payments,
  events,
  analytics,
  ai,
  credibility,
}

enum OnboardingStep {
  registerVenue,
  configureStaff,
  liveSync,
}

class LandingState extends Equatable {
  const LandingState({
    required this.activeSection,
    required this.onboardingStep,
  });

  final LandingSection activeSection;
  final OnboardingStep onboardingStep;

  @override
  List<Object?> get props => [activeSection, onboardingStep];

  LandingState copyWith({
    LandingSection? activeSection,
    OnboardingStep? onboardingStep,
  }) {
    return LandingState(
      activeSection: activeSection ?? this.activeSection,
      onboardingStep: onboardingStep ?? this.onboardingStep,
    );
  }
}

class LandingCubit extends Cubit<LandingState> {
  LandingCubit()
      : super(
          const LandingState(
            activeSection: LandingSection.hero,
            onboardingStep: OnboardingStep.configureStaff,
          ),
        );

  void setActiveSection(LandingSection section) {
    if (state.activeSection == section) return;
    emit(state.copyWith(activeSection: section));
  }

  void setOnboardingStep(OnboardingStep step) {
    if (state.onboardingStep == step) return;
    emit(state.copyWith(onboardingStep: step));
  }
}

