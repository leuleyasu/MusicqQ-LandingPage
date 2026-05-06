import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/nighttrack_colors.dart';
import '../../../../core/ui/glass_card.dart';

class CreateOrganizationAccountPage extends StatefulWidget {
  const CreateOrganizationAccountPage({super.key});

  @override
  State<CreateOrganizationAccountPage> createState() =>
      _CreateOrganizationAccountPageState();
}

class _CreateOrganizationAccountPageState
    extends State<CreateOrganizationAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _orgNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  var _venueType = _VenueType.club;
  var _isSubmitting = false;
  var _passwordVisible = false;

  void updateVenueType(_VenueType v) {
    setState(() => _venueType = v);
  }

  void togglePasswordVisibility() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  @override
  void dispose() {
    _orgNameCtrl.dispose();
    _emailCtrl.dispose();
    _cityCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    TextInput.finishAutofillContext();
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NightTrackColors.surface,
        content: const Text('Organization created (demo). Next: connect API.'),
        action: SnackBarAction(
          label: 'How it works',
          textColor: NightTrackColors.accent,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    return Scaffold(
      appBar: AppBar(title: const Text('Create organization')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: _OnboardingSide()),
                      const SizedBox(width: 16),
                      Expanded(child: _FormCard(state: this)),
                    ],
                  )
                : ListView(
                    children: [
                      const _OnboardingSide(),
                      const SizedBox(height: 14),
                      _FormCard(state: this),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.state});

  final _CreateOrganizationAccountPageState state;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 26,
      child: Form(
        key: state._formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create your organization',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will create your venue workspace and admin account.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: NightTrackColors.textSecondary.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 18),
              _Field(
                label: 'Venue / Organization name',
                hint: 'E.g. Club Nova',
                controller: state._orgNameCtrl,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.organizationName],
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'Enter a venue name';
                  if (t.length < 3) return 'Name is too short';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _Dropdown<_VenueType>(
                label: 'Venue type',
                value: state._venueType,
                items: _VenueType.values,
                itemLabel: (v) => v.label,
                onChanged: state._isSubmitting
                    ? null
                    : (v) => state.updateVenueType(v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _Field(
                      label: 'City',
                      hint: 'E.g. Accra',
                      controller: state._cityCtrl,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.addressCity],
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return 'Enter a city';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Field(
                      label: 'Admin email',
                      hint: 'you@venue.com',
                      controller: state._emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return 'Enter an email';
                        if (!t.contains('@') || !t.contains('.')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _Field(
                label: 'Create password',
                hint: 'Minimum 8 characters',
                controller: state._passwordCtrl,
                obscureText: !state._passwordVisible,
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  tooltip:
                      state._passwordVisible ? 'Hide password' : 'Show password',
                  onPressed: state._isSubmitting
                      ? null
                      : state.togglePasswordVisibility,
                  icon: Icon(
                    state._passwordVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: NightTrackColors.textSecondary.withValues(alpha: 0.9),
                  ),
                ),
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.length < 8) return 'Use at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: state._isSubmitting ? null : state._submit,
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            NightTrackColors.primary.withValues(alpha: 0.88),
                        foregroundColor: NightTrackColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state._isSubmitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Continue',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'By continuing you agree to basic platform terms (placeholder).',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NightTrackColors.textSecondary.withValues(alpha: 0.75),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSide extends StatelessWidget {
  const _OnboardingSide();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    final titleStyle = (isWide
            ? Theme.of(context).textTheme.displaySmall
            : Theme.of(context).textTheme.headlineLarge)
        ?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: -0.8,
      height: 1.05,
    );

    return Padding(
      padding: EdgeInsets.only(top: isWide ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Go live in minutes.',
            style: titleStyle?.copyWith(
              color: NightTrackColors.textPrimary.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Create your venue workspace, invite staff, and start accepting live music requests tonight.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NightTrackColors.textSecondary.withValues(alpha: 0.9),
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 16),
          const _Perk(
            icon: Icons.verified_user_rounded,
            title: 'Role-based access',
            body: 'DJ, admin, and staff roles out of the box.',
          ),
          const SizedBox(height: 12),
          const _Perk(
            icon: Icons.queue_music_rounded,
            title: 'Requests + queue',
            body: 'Real-time queue, moderation, and activity tracking.',
          ),
          const SizedBox(height: 12),
          const _Perk(
            icon: Icons.insights_rounded,
            title: 'Analytics ready',
            body: 'Track performance and revenue trends from day one.',
          ),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  const _Perk({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: NightTrackColors.surfaceAlt.withValues(alpha: 0.22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Icon(
            icon,
            size: 18,
            color: NightTrackColors.primary.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                body,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: NightTrackColors.textSecondary.withValues(alpha: 0.9),
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofillHints,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      autofillHints: autofillHints,
      obscureText: obscureText,
      enableSuggestions: !obscureText,
      autocorrect: !obscureText,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: NightTrackColors.surfaceAlt.withValues(alpha: 0.30),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: NightTrackColors.primary.withValues(alpha: 0.6),
            width: 1.2,
          ),
        ),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: NightTrackColors.textSecondary.withValues(alpha: 0.9),
            ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: NightTrackColors.textSecondary.withValues(alpha: 0.6),
            ),
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final decoration = InputDecoration(
      labelText: label,
      filled: true,
      fillColor: NightTrackColors.surfaceAlt.withValues(alpha: 0.30),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: NightTrackColors.primary.withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: NightTrackColors.textSecondary.withValues(alpha: 0.9),
          ),
    );

    return InputDecorator(
      decoration: decoration,
      isEmpty: false,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: NightTrackColors.surface,
          iconEnabledColor: NightTrackColors.textSecondary.withValues(alpha: 0.9),
          onChanged: enabled ? onChanged : null,
          items: [
            for (final it in items)
              DropdownMenuItem<T>(
                value: it,
                child: Text(itemLabel(it)),
              ),
          ],
        ),
      ),
    );
  }
}

enum _VenueType {
  club('Club'),
  lounge('Lounge'),
  bar('Bar'),
  restaurant('Restaurant'),
  eventSpace('Event space');

  const _VenueType(this.label);
  final String label;
}

