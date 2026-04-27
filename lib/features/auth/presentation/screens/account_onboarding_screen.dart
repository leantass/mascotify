import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../auth_session_controller.dart';

class AccountOnboardingScreen extends StatelessWidget {
  const AccountOnboardingScreen({super.key, required this.experience});

  final AccountExperience experience;

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final track = AppData.trackFor(experience);
    final account = auth.accountFor(experience);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final useWideLayout = viewportWidth >= 1100;
    final pageMaxWidth = useWideLayout
        ? (viewportWidth - 32).clamp(1140.0, 1440.0).toDouble()
        : 920.0;
    final isDense = useWideLayout;
    final softAccent = experience == AccountExperience.family
        ? AppColors.primarySoft
        : AppColors.accentSoft;
    final accentColor = experience == AccountExperience.family
        ? AppColors.primaryDeep
        : AppColors.accentDeep;
    final icon = experience == AccountExperience.family
        ? Icons.family_restroom_rounded
        : Icons.work_rounded;
    final accountSection = _OnboardingSectionCard(
      isDense: isDense,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Como queda pensada la cuenta',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: isDense ? 4 : 8),
          Text(
            account.baseSummary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: isDense ? 6 : 16),
          _InfoTile(
            label: 'Cuenta base',
            value: '${account.ownerName} - ${account.email}',
            accentColor: accentColor,
            isDense: isDense,
          ),
          SizedBox(height: isDense ? 4 : 10),
          _InfoTile(
            label: 'Escalabilidad futura',
            value: account.linkedProfilesSummary,
            accentColor: accentColor,
            isDense: isDense,
          ),
          SizedBox(height: isDense ? 4 : 10),
          _InfoTile(
            label: 'Plan activo',
            value: '${account.planName} - ${account.city}',
            accentColor: accentColor,
            isDense: isDense,
          ),
        ],
      ),
    );
    final sequenceSection = _OnboardingSectionCard(
      isDense: isDense,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Secuencia inicial',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: isDense ? 4 : 8),
          Text(
            track.architectureNote,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: isDense ? 6 : 16),
          ...track.steps.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key == track.steps.length - 1
                    ? 0
                    : (isDense ? 4 : 12),
              ),
              child: _OnboardingStepTile(
                index: entry.key + 1,
                step: entry.value,
                accentColor: AppColors.primaryDeep,
                softColor: AppColors.primarySoft,
                isDense: isDense,
              ),
            ),
          ),
        ],
      ),
    );
    final signalsSection = _OnboardingSectionCard(
      isDense: isDense,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Senales del perfil elegido',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: isDense ? 6 : 12),
          Wrap(
            spacing: isDense ? 6 : 10,
            runSpacing: isDense ? 6 : 10,
            children: track.supportingHighlights
                .map(
                  (item) => _HighlightChip(
                    label: item,
                    backgroundColor: softAccent,
                    textColor: accentColor,
                    isDense: isDense,
                  ),
                )
                .toList(),
          ),
          if (experience == AccountExperience.professional &&
              account.professionalProfile != null) ...[
            SizedBox(height: isDense ? 6 : 16),
            Text(
              'Servicios contemplados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: isDense ? 6 : 10),
            Wrap(
              spacing: isDense ? 6 : 10,
              runSpacing: isDense ? 6 : 10,
              children: account.professionalProfile!.services
                  .map(
                    (service) => _ServiceChip(label: service, isDense: isDense),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
    final heroIcon = Container(
      width: useWideLayout ? 36 : 56,
      height: useWideLayout ? 36 : 56,
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(useWideLayout ? 14 : 18),
      ),
      child: Icon(icon, color: Colors.white),
    );
    final heroCopy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(track.title, style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(height: useWideLayout ? 4 : 10),
        Text(
          'La cuenta ${account.ownerName} ya quedo creada y la sesion esta guardada. Este paso solo termina de alinear el perfil activo con la navegacion actual.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: useWideLayout ? 1.24 : 1.5,
          ),
        ),
      ],
    );
    final heroSection = Container(
      padding: EdgeInsets.all(useWideLayout ? 10 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            AppColors.accentSoft,
            AppColors.surface,
            Color(0xFFEAFBFF),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(useWideLayout ? 24 : 32),
        border: Border.all(color: const Color(0xFFCFEFF5)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: useWideLayout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heroIcon,
                const SizedBox(width: 10),
                Expanded(child: heroCopy),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heroIcon, const SizedBox(height: 16), heroCopy],
            ),
    );
    final ctaButton = SizedBox(
      width: useWideLayout ? 360 : double.infinity,
      child: ElevatedButton(
        style: useWideLayout
            ? ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              )
            : null,
        onPressed: auth.isBusy
            ? null
            : () async {
                await auth.completeOnboarding();
              },
        child: Text(auth.isBusy ? 'Guardando...' : track.ctaLabel),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Text('Onboarding inicial'),
      ),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: pageMaxWidth,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (!useWideLayout) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  children: [
                    heroSection,
                    const SizedBox(height: 16),
                    accountSection,
                    const SizedBox(height: 16),
                    sequenceSection,
                    const SizedBox(height: 16),
                    signalsSection,
                    const SizedBox(height: 16),
                    Align(alignment: Alignment.center, child: ctaButton),
                  ],
                );
              }

              final desktopChildren = <Widget>[
                heroSection,
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: accountSection),
                    const SizedBox(width: 14),
                    Expanded(flex: 7, child: sequenceSection),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: signalsSection),
                    const SizedBox(width: 14),
                    Align(alignment: Alignment.bottomRight, child: ctaButton),
                  ],
                ),
              ];

              const desktopPadding = EdgeInsets.fromLTRB(14, 4, 14, 4);
              final hasNormalDesktopHeight =
                  constraints.hasBoundedHeight &&
                  constraints.maxHeight.isFinite &&
                  constraints.maxHeight >= 660;

              if (!hasNormalDesktopHeight) {
                return ListView(
                  padding: desktopPadding,
                  children: desktopChildren,
                );
              }

              return Padding(
                padding: desktopPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: desktopChildren,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingSectionCard extends StatelessWidget {
  const _OnboardingSectionCard({required this.child, this.isDense = false});

  final Widget child;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      child: Padding(padding: EdgeInsets.all(isDense ? 8 : 20), child: child),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.accentColor,
    this.isDense = false,
  });

  final String label;
  final String value;
  final Color accentColor;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDense ? 7 : 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isDense ? 3 : 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: isDense ? 1.22 : 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingStepTile extends StatelessWidget {
  const _OnboardingStepTile({
    required this.index,
    required this.step,
    required this.accentColor,
    required this.softColor,
    this.isDense = false,
  });

  final int index;
  final OnboardingStepPreview step;
  final Color accentColor;
  final Color softColor;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDense ? 7 : 16),
      decoration: BoxDecoration(
        color: softColor.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isDense ? 26 : 34,
            height: isDense ? 26 : 34,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(isDense ? 8 : 10),
            ),
            child: Center(
              child: Text(
                '$index',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: isDense ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: isDense ? 2 : 4),
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: isDense ? 1.22 : 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightChip extends StatelessWidget {
  const _HighlightChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.isDense = false,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDense ? 9 : 14,
        vertical: isDense ? 5 : 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: textColor.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.label, this.isDense = false});

  final String label;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDense ? 9 : 14,
        vertical: isDense ? 5 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.accentDeep,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
