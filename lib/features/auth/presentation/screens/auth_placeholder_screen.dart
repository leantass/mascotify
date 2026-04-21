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
          maxWidth: 860,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 760;

              if (!isWide) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _HeroCard(isBusy: auth.isBusy),
                    const SizedBox(height: 20),
                    _ModeSwitcher(
                      isLoginMode: _isLoginMode,
                      onModeChanged: (value) {
                        setState(() {
                          _isLoginMode = value;
                          _errorMessage = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    formCard,
                    const SizedBox(height: 16),
                    _DemoCard(
                      isBusy: auth.isBusy,
                      onFamilyDemo: () => _submitDemoLogin(
                        email: LocalAuthSeedData.familyEmail,
                      ),
                      onProfessionalDemo: () => _submitDemoLogin(
                        email: LocalAuthSeedData.professionalEmail,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _ErrorCard(message: _errorMessage!),
                    ],
                  ],
                );
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroCard(isBusy: auth.isBusy),
                            const SizedBox(height: 20),
                            _ModeSwitcher(
                              isLoginMode: _isLoginMode,
                              onModeChanged: (value) {
                                setState(() {
                                  _isLoginMode = value;
                                  _errorMessage = null;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _DemoCard(
                              isBusy: auth.isBusy,
                              onFamilyDemo: () => _submitDemoLogin(
                                email: LocalAuthSeedData.familyEmail,
                              ),
                              onProfessionalDemo: () => _submitDemoLogin(
                                email: LocalAuthSeedData.professionalEmail,
                              ),
                            ),
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 16),
                              _ErrorCard(message: _errorMessage!),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(flex: 4, child: formCard),
                    ],
                  ),
                ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inicia sesion',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Tu sesion queda guardada localmente para que vuelvas a entrar sin perder el perfil activo.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _AuthField(
              controller: _loginEmailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _AuthField(
              controller: _loginPasswordController,
              label: 'Contrasena',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.isBusy ? null : _submitLogin,
                child: Text(auth.isBusy ? 'Entrando...' : 'Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterCard(
    BuildContext context,
    AuthSessionController auth,
    List<ExperienceOption> options,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crea tu cuenta base',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'El registro crea una cuenta real local con un perfil inicial y deja lista la sesion persistida.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _AuthField(controller: _registerNameController, label: 'Nombre'),
            const SizedBox(height: 12),
            _AuthField(controller: _registerCityController, label: 'Ciudad'),
            const SizedBox(height: 12),
            _AuthField(
              controller: _registerEmailController,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _AuthField(
              controller: _registerPasswordController,
              label: 'Contrasena',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Text(
              'Perfil inicial',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.isBusy ? null : _submitRegister,
                child: Text(auth.isBusy ? 'Creando cuenta...' : 'Crear cuenta'),
              ),
            ),
          ],
        ),
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
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.isBusy});

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              isBusy ? 'Auth trabajando' : 'Auth real local',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Entrar de forma real, simple y local.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Mascotify ahora arranca con registro, login, sesion persistida y recuperacion del perfil activo sin romper la arquitectura de cuenta base + perfiles.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(
                child: _HeroMetric(
                  label: 'Cuenta base',
                  value: 'Una sola identidad',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  label: 'Sesion',
                  value: 'Persistida localmente',
                ),
              ),
            ],
          ),
        ],
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
              label: 'Login',
              isActive: isLoginMode,
              onTap: () => onModeChanged(true),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ModeButton(
              label: 'Registro',
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

class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.isBusy,
    required this.onFamilyDemo,
    required this.onProfessionalDemo,
  });

  final bool isBusy;
  final VoidCallback onFamilyDemo;
  final VoidCallback onProfessionalDemo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transicion clara desde la base mock',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Mantuvimos dos cuentas demo reales y persistidas para entrar rapido sin volver al bypass mock. Ambas usan la contrasena ${LocalAuthSeedData.demoPassword}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isBusy ? null : onFamilyDemo,
                    child: const Text('Demo familia'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: isBusy ? null : onProfessionalDemo,
                    child: const Text('Demo profesional'),
                  ),
                ),
              ],
            ),
          ],
        ),
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
          color: isSelected ? Color(option.accentColorHex) : AppColors.surfaceAlt,
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
        labelText: label,
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

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
