import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/account_identity_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';
import '../../data/local_auth_models.dart';
import '../auth_session_controller.dart';

class AuthPlaceholderScreen extends StatefulWidget {
  const AuthPlaceholderScreen({super.key});

  @override
  State<AuthPlaceholderScreen> createState() => _AuthPlaceholderScreenState();
}

class _AuthPlaceholderScreenState extends State<AuthPlaceholderScreen> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registerNameController =
      TextEditingController();
  final TextEditingController _registerCityController =
      TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();

  bool _isLoginMode = true;
  AccountExperience _registerExperience = AccountExperience.family;
  String? _errorMessage;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerCityController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);
    final options = AppData.experienceOptions;
    final formCard = _isLoginMode
        ? _buildLoginCard(context, auth)
        : _buildRegisterCard(context, auth, options);

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 1040,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 780;

              if (!isWide) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  children: [
                    const _HeroPanel(),
                    const SizedBox(height: 20),
                    _ModeSwitcher(
                      isLoginMode: _isLoginMode,
                      onModeChanged: _setMode,
                    ),
                    const SizedBox(height: 14),
                    formCard,
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 14),
                      _ErrorCard(message: _errorMessage!),
                    ],
                    const SizedBox(height: 18),
                    _DemoPanel(
                      isCompact: false,
                      isBusy: auth.isBusy,
                      onFamilyDemo: () => _submitDemoLogin(
                        email: LocalAuthSeedData.familyEmail,
                      ),
                      onProfessionalDemo: () => _submitDemoLogin(
                        email: LocalAuthSeedData.professionalEmail,
                      ),
                    ),
                  ],
                );
              }

              return SizedBox(
                height: constraints.maxHeight,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 992),
                      child: LayoutBuilder(
                        builder: (context, contentConstraints) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                flex: 6,
                                child: _HeroPanel(),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: contentConstraints.maxHeight,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _ModeSwitcher(
                                        isLoginMode: _isLoginMode,
                                        onModeChanged: _setMode,
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              formCard,
                                              if (_errorMessage != null) ...[
                                                const SizedBox(height: 10),
                                                _ErrorCard(
                                                  message: _errorMessage!,
                                                ),
                                              ],
                                              const SizedBox(height: 10),
                                              _DemoPanel(
                                                isCompact: true,
                                                isBusy: auth.isBusy,
                                                onFamilyDemo: () =>
                                                    _submitDemoLogin(
                                                      email:
                                                          LocalAuthSeedData
                                                              .familyEmail,
                                                    ),
                                                onProfessionalDemo: () =>
                                                    _submitDemoLogin(
                                                      email:
                                                          LocalAuthSeedData
                                                              .professionalEmail,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(
    BuildContext context,
    AuthSessionController auth,
  ) {
    return _FormShell(
      title: 'Iniciar sesión',
      description:
          'Entrá a tu cuenta para continuar con tu experiencia en Mascotify.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AuthField(
            controller: _loginEmailController,
            label: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _AuthField(
            controller: _loginPasswordController,
            label: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _showPasswordHelpDialog(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              ),
              child: const Text('Olvidé mi contraseña'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: auth.isBusy ? null : _submitLogin,
              child: Text(auth.isBusy ? 'Ingresando...' : 'Ingresar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterCard(
    BuildContext context,
    AuthSessionController auth,
    List<ExperienceOption> options,
  ) {
    return _FormShell(
      title: 'Crear cuenta',
      description:
          'Registrate para empezar a usar Mascotify y gestionar tu perfil desde web o mobile.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AuthField(
            controller: _registerNameController,
            label: 'Nombre',
          ),
          const SizedBox(height: 10),
          _AuthField(
            controller: _registerCityController,
            label: 'Ciudad',
          ),
          const SizedBox(height: 10),
          _AuthField(
            controller: _registerEmailController,
            label: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          _AuthField(
            controller: _registerPasswordController,
            label: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 14),
          Text(
            'Elegí tu tipo de cuenta',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...options.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExperienceChoiceCard(
                option: option,
                isSelected: _registerExperience == option.experience,
                onTap: () {
                  setState(() {
                    _registerExperience = option.experience;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: auth.isBusy ? null : _submitRegister,
              child: Text(auth.isBusy ? 'Creando cuenta...' : 'Crear cuenta'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitLogin() async {
    final auth = AuthScope.of(context);
    final error = await auth.login(
      email: _loginEmailController.text,
      password: _loginPasswordController.text,
    );

    if (!mounted) return;
    setState(() {
      _errorMessage = error;
    });
  }

  Future<void> _submitRegister() async {
    final auth = AuthScope.of(context);
    final error = await auth.register(
      ownerName: _registerNameController.text,
      email: _registerEmailController.text,
      city: _registerCityController.text,
      password: _registerPasswordController.text,
      experience: _registerExperience,
    );

    if (!mounted) return;
    setState(() {
      _errorMessage = error;
    });
  }

  Future<void> _submitDemoLogin({required String email}) async {
    _loginEmailController.text = email;
    _loginPasswordController.text = LocalAuthSeedData.demoPassword;
    await _submitLogin();
  }

  void _setMode(bool value) {
    setState(() {
      _isLoginMode = value;
      _errorMessage = null;
    });
  }

  void _showPasswordHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recuperar acceso'),
          content: const Text(
            'Si necesitás ayuda para volver a entrar, podés usar el canal de soporte disponible junto con Mascotify.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.primarySoft,
            AppColors.accentSoft,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.74),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Mascotify',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Gestioná todo lo importante de tu mascota desde un solo lugar',
            style: textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Gestioná perfiles, seguimiento, contactos y herramientas útiles desde una experiencia simple, clara y disponible desde cualquier dispositivo.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          const _BenefitItem(
            title: 'Perfiles y datos siempre a mano',
          ),
          const SizedBox(height: 14),
          const _BenefitItem(
            title: 'Seguimiento y trazabilidad en un solo espacio',
          ),
          const SizedBox(height: 14),
          const _BenefitItem(
            title: 'Acceso simple desde cualquier dispositivo',
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormShell extends StatelessWidget {
  const _FormShell({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({
    required this.isLoginMode,
    required this.onModeChanged,
  });

  final bool isLoginMode;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Iniciar sesión',
              isActive: isLoginMode,
              onTap: () => onModeChanged(true),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ModeButton(
              label: 'Crear cuenta',
              isActive: !isLoginMode,
              onTap: () => onModeChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.dark : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isActive ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoPanel extends StatelessWidget {
  const _DemoPanel({
    this.isCompact = false,
    required this.isBusy,
    required this.onFamilyDemo,
    required this.onProfessionalDemo,
  });

  final bool isCompact;
  final bool isBusy;
  final VoidCallback onFamilyDemo;
  final VoidCallback onProfessionalDemo;

  @override
  Widget build(BuildContext context) {
    final demoButtonStyle = OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 2 : 8),
      minimumSize: Size(0, isCompact ? 30 : 40),
      tapTargetSize: isCompact
          ? MaterialTapTargetSize.shrinkWrap
          : MaterialTapTargetSize.padded,
      visualDensity: isCompact
          ? const VisualDensity(horizontal: -1, vertical: -4)
          : VisualDensity.standard,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 14,
        vertical: isCompact ? 6 : 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acceso demo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: isCompact ? 3 : 8),
          Text(
            'Si querés recorrer la experiencia antes de usar una cuenta propia, podés entrar con uno de estos perfiles de prueba.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: isCompact ? 1.2 : 1.45,
            ),
          ),
          SizedBox(height: isCompact ? 5 : 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final stackButtons = !isCompact && constraints.maxWidth < 340;

              if (stackButtons) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: demoButtonStyle,
                        onPressed: isBusy ? null : onFamilyDemo,
                        child: const Text('Demo familia'),
                      ),
                    ),
                    SizedBox(height: isCompact ? 4 : 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: demoButtonStyle,
                        onPressed: isBusy ? null : onProfessionalDemo,
                        child: const Text('Demo profesional'),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: demoButtonStyle,
                      onPressed: isBusy ? null : onFamilyDemo,
                      child: const Text('Demo familia'),
                    ),
                  ),
                  SizedBox(width: isCompact ? 4 : 10),
                  Expanded(
                    child: OutlinedButton(
                      style: demoButtonStyle,
                      onPressed: isBusy ? null : onProfessionalDemo,
                      child: const Text('Demo profesional'),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExperienceChoiceCard extends StatelessWidget {
  const _ExperienceChoiceCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final ExperienceOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected ? Color(option.accentColorHex) : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.dark : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(option.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              option.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE5E5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC1C1)),
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: AppColors.surfaceAlt,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
