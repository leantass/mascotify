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
        ? (viewportWidth - 48).clamp(1100.0, 1320.0).toDouble()
        : 920.0;
    final softAccent = experience == AccountExperience.family
        ? AppColors.primarySoft
        : AppColors.accentSoft;
    final accentColor = experience == AccountExperience.family
        ? AppColors.primaryDeep
        : AppColors.accentDeep;
    final complementarySoft = experience == AccountExperience.family
        ? AppColors.accentSoft
        : AppColors.primarySoft;
    final icon = experience == AccountExperience.family
        ? Icons.family_restroom_rounded
        : Icons.work_rounded;
    final accountSection = _OnboardingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Como queda pensada la cuenta',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            account.baseSummary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _InfoTile(
            label: 'Cuenta base',
            value: '${account.ownerName} - ${account.email}',
            accentColor: accentColor,
          ),
          const SizedBox(height: 10),
          _InfoTile(
            label: 'Escalabilidad futura',
            value: account.linkedProfilesSummary,
            accentColor: accentColor,
          ),
          const SizedBox(height: 10),
          _InfoTile(
            label: 'Plan activo',
            value: '${account.planName} - ${account.city}',
            accentColor: accentColor,
          ),
        ],
      ),
    );
    final sequenceSection = _OnboardingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Secuencia inicial',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            track.architectureNote,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ...track.steps.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OnboardingStepTile(
                index: entry.key + 1,
                step: entry.value,
                accentColor: AppColors.primaryDeep,
                softColor: AppColors.primarySoft,
              ),
            ),
          ),
        ],
      ),
    );
    final signalsSection = _OnboardingSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Senales del perfil elegido',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: track.supportingHighlights
                .map(
                  (item) => _HighlightChip(
                    label: item,
                    backgroundColor: softAccent,
                    textColor: accentColor,
                  ),
                )
                .toList(),
          ),
          if (experience == AccountExperience.professional &&
              account.professionalProfile != null) ...[
            const SizedBox(height: 16),
            Text(
              'Servicios contemplados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: account.professionalProfile!.services
                  .map((service) => _ServiceChip(label: service))
                  .toList(),
            ),
          ],
        ],
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
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              useWideLayout ? 24 : 20,
              12,
              useWideLayout ? 24 : 20,
              28,
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.surface,
                      softAccent,
                      complementarySoft.withValues(alpha: 0.72),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.08),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(icon, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      track.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'La cuenta ${account.ownerName} ya quedo creada y la sesion esta guardada. Este paso solo termina de alinear el perfil activo con la navegacion actual.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (useWideLayout)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 6, child: accountSection),
                          const SizedBox(width: 18),
                          Expanded(flex: 7, child: sequenceSection),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    signalsSection,
                  ],
                )
              else ...[
                accountSection,
                const SizedBox(height: 16),
                sequenceSection,
                const SizedBox(height: 16),
                signalsSection,
              ],
              SizedBox(height: useWideLayout ? 20 : 16),
              Align(
                alignment: useWideLayout
                    ? Alignment.centerRight
                    : Alignment.center,
                child: SizedBox(
                  width: useWideLayout ? 380 : double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isBusy
                        ? null
                        : () async {
                            await auth.completeOnboarding();
                          },
                    child: Text(auth.isBusy ? 'Guardando...' : track.ctaLabel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSectionCard extends StatelessWidget {
  const _OnboardingSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.45,
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
  });

  final int index;
  final OnboardingStepPreview step;
  final Color accentColor;
  final Color softColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softColor.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.45,
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
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
  const _ServiceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
