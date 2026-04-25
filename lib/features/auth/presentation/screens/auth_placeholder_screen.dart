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
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final pageMaxWidth = viewportWidth >= 900
        ? (viewportWidth - 24).clamp(1100.0, 1680.0).toDouble()
        : 1040.0;

    return Scaffold(
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: pageMaxWidth,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const compactBreakpoint = 760.0;
              const wideBreakpoint = 1120.0;

              final isCompact = constraints.maxWidth < compactBreakpoint;
              final isWide = constraints.maxWidth >= wideBreakpoint;
              final allowsMultiColumnRegister = !isCompact;
              final useDenseDesktop = isWide;
              final auth = AuthScope.of(context);
              final options = AppData.experienceOptions;
              final formCard = _isLoginMode
                  ? _buildLoginCard(context, auth, isDense: useDenseDesktop)
                  : _buildRegisterCard(
                      context,
                      auth,
                      options,
                      allowsMultiColumnLayout: allowsMultiColumnRegister,
                      isDense: useDenseDesktop,
                    );

              if (!isWide) {
                final horizontalPadding = isCompact ? 20.0 : 24.0;
                final sectionSpacing = isCompact ? 18.0 : 20.0;

                return ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    28,
                  ),
                  children: [
                    const _HeroPanel(),
                    SizedBox(height: sectionSpacing),
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
                    SizedBox(height: sectionSpacing),
                    _DemoPanel(
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

              final isExtraWide = constraints.maxWidth >= 1440;
              final horizontalPadding = isExtraWide ? 18.0 : 22.0;
              final columnGap = isExtraWide ? 28.0 : 24.0;
              final heroFlex = isExtraWide ? 4 : 5;
              final authFlex = isExtraWide ? 7 : 6;
              final authMaxWidth = isExtraWide ? 920.0 : 820.0;
              final verticalPadding = isExtraWide ? 16.0 : 18.0;
              final demoGap = isExtraWide ? 8.0 : 10.0;

              return SizedBox(
                height: constraints.maxHeight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    verticalPadding,
                    horizontalPadding,
                    verticalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: heroFlex,
                              child: const _HeroPanel(isDense: true),
                            ),
                            SizedBox(width: columnGap),
                            Expanded(
                              flex: authFlex,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: authMaxWidth,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _ModeSwitcher(
                                        isDense: true,
                                        isLoginMode: _isLoginMode,
                                        onModeChanged: _setMode,
                                      ),
                                      const SizedBox(height: 12),
                                      formCard,
                                      if (_errorMessage != null) ...[
                                        const SizedBox(height: 12),
                                        _ErrorCard(message: _errorMessage!),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: demoGap),
                      _DemoPanel(
                        isDense: true,
                        isBusy: auth.isBusy,
                        onFamilyDemo: () => _submitDemoLogin(
                          email: LocalAuthSeedData.familyEmail,
                        ),
                        onProfessionalDemo: () => _submitDemoLogin(
                          email: LocalAuthSeedData.professionalEmail,
                        ),
                      ),
                    ],
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
    AuthSessionController auth, {
    bool isDense = false,
  }) {
    return _FormShell(
      isDense: isDense,
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
            isDense: isDense,
          ),
          SizedBox(height: isDense ? 10 : 12),
          _AuthField(
            controller: _loginPasswordController,
            label: 'Contraseña',
            obscureText: true,
            isDense: isDense,
          ),
          SizedBox(height: isDense ? 8 : 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _showPasswordHelpDialog(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: isDense ? 4 : 6,
                ),
              ),
              child: const Text('Olvidé mi contraseña'),
            ),
          ),
          SizedBox(height: isDense ? 6 : 8),
          _AuthActionBlock(
            isDense: isDense,
            showAlternative: isDense,
            googleButtonLabel: 'Iniciar sesión con Google',
            onGoogleTap: () => _showGoogleAuthPlaceholder(context),
            primaryButton: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.isBusy ? null : _submitLogin,
                child: Text(auth.isBusy ? 'Ingresando...' : 'Ingresar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterCard(
    BuildContext context,
    AuthSessionController auth,
    List<ExperienceOption> options, {
    required bool allowsMultiColumnLayout,
    bool isDense = false,
  }) {
    return _FormShell(
      isDense: isDense,
      title: 'Crear cuenta',
      description:
          'Registrate para empezar a usar Mascotify y gestionar tu perfil desde web o mobile.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useFieldGrid =
              allowsMultiColumnLayout && constraints.maxWidth >= 520;
          final useChoiceWrap =
              allowsMultiColumnLayout && constraints.maxWidth >= 520;
          final fieldSpacing = isDense ? 8.0 : (useFieldGrid ? 10.0 : 12.0);
          final fieldWidth = useFieldGrid
              ? (constraints.maxWidth - 10) / 2
              : constraints.maxWidth;
          final choiceWidth = useChoiceWrap
              ? (constraints.maxWidth - 10) / 2
              : constraints.maxWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: useFieldGrid ? 10 : 0,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _AuthField(
                      controller: _registerNameController,
                      label: 'Nombre',
                      isDense: isDense,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _AuthField(
                      controller: _registerCityController,
                      label: 'Ciudad',
                      isDense: isDense,
                    ),
                  ),
                ],
              ),
              SizedBox(height: fieldSpacing),
              Wrap(
                spacing: useFieldGrid ? 10 : 0,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _AuthField(
                      controller: _registerEmailController,
                      label: 'Correo electrónico',
                      keyboardType: TextInputType.emailAddress,
                      isDense: isDense,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _AuthField(
                      controller: _registerPasswordController,
                      label: 'Contraseña',
                      obscureText: true,
                      isDense: isDense,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDense ? 12 : (useFieldGrid ? 16 : 18)),
              Text(
                'Elegí tu tipo de cuenta',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: isDense ? 8 : 10),
              if (useChoiceWrap)
                Wrap(
                  spacing: 10,
                  runSpacing: isDense ? 8 : 10,
                  children: options
                      .map(
                        (option) => SizedBox(
                          width: choiceWidth,
                          child: _ExperienceChoiceCard(
                            isDense: isDense,
                            option: option,
                            isSelected:
                                _registerExperience == option.experience,
                            onTap: () {
                              setState(() {
                                _registerExperience = option.experience;
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
                )
              else
                Column(
                  children: options
                      .map(
                        (option) => Padding(
                          padding: EdgeInsets.only(bottom: isDense ? 8 : 10),
                          child: _ExperienceChoiceCard(
                            isDense: isDense,
                            option: option,
                            isSelected:
                                _registerExperience == option.experience,
                            onTap: () {
                              setState(() {
                                _registerExperience = option.experience;
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
              ),
              SizedBox(height: isDense ? 6 : 8),
              _AuthActionBlock(
                isDense: isDense,
                showAlternative: true,
                googleButtonLabel: 'Crear con Google',
                onGoogleTap: () => _showGoogleAuthPlaceholder(context),
                primaryButton: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isBusy ? null : _submitRegister,
                    child: Text(
                      auth.isBusy ? 'Creando cuenta...' : 'Crear cuenta',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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

  void _showGoogleAuthPlaceholder(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Próximamente'),
          content: const Text(
            'El acceso con Google estará disponible una vez que se complete la integración final del proveedor de autenticación.',
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

class _AuthActionBlock extends StatelessWidget {
  const _AuthActionBlock({
    required this.primaryButton,
    required this.googleButtonLabel,
    required this.onGoogleTap,
    required this.showAlternative,
    this.isDense = false,
  });

  final Widget primaryButton;
  final String googleButtonLabel;
  final VoidCallback onGoogleTap;
  final bool showAlternative;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        primaryButton,
        if (showAlternative) ...[
          SizedBox(height: isDense ? 18 : 16),
          _AuthAlternativeSection(
            buttonLabel: googleButtonLabel,
            onGoogleTap: onGoogleTap,
          ),
        ],
      ],
    );

    if (!isDense) {
      return content;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: content,
    );
  }
}

class _AuthAlternativeSection extends StatelessWidget {
  const _AuthAlternativeSection({
    required this.buttonLabel,
    required this.onGoogleTap,
  });

  final String buttonLabel;
  final VoidCallback onGoogleTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'o continuar con',
                style: textStyle,
              ),
            ),
            Expanded(
              child: Divider(
                color: AppColors.border,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              backgroundColor: Colors.white,
              side: BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onGoogleTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: _GoogleLogoMark(size: 18),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    buttonLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleLogoMark extends StatelessWidget {
  const _GoogleLogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  static const _blue = Color(0xFF4285F4);
  static const _red = Color(0xFFEA4335);
  static const _yellow = Color(0xFFFBBC05);
  static const _green = Color(0xFF34A853);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.18;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    void drawArc(Color color, double start, double sweep) {
      paint.color = color;
      canvas.drawArc(rect, start, sweep, false, paint);
    }

    drawArc(_blue, -0.05, 1.08);
    drawArc(_red, -2.95, 1.35);
    drawArc(_yellow, 2.38, 1.02);
    drawArc(_green, 1.55, 0.95);

    final centerY = size.height * 0.52;
    final horizontalStart = Offset(size.width * 0.52, centerY);
    final horizontalEnd = Offset(size.width * 0.92, centerY);

    paint
      ..color = _blue
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(horizontalStart, horizontalEnd, paint);

    paint.strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -0.03,
      0.82,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({this.isDense = false});

  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final panelPadding = isDense ? 16.0 : 22.0;
    final badgeVertical = isDense ? 6.0 : 8.0;
    final badgeHorizontal = isDense ? 10.0 : 12.0;
    final titleGap = isDense ? 14.0 : 22.0;
    final bodyGap = isDense ? 8.0 : 12.0;
    final benefitsGap = isDense ? 14.0 : 24.0;
    final itemGap = isDense ? 8.0 : 14.0;

    return Container(
      padding: EdgeInsets.all(panelPadding),
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
            padding: EdgeInsets.symmetric(
              horizontal: badgeHorizontal,
              vertical: badgeVertical,
            ),
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
          SizedBox(height: titleGap),
          Text(
            'Gestioná todo lo importante de tu mascota desde un solo lugar',
            style: textTheme.headlineLarge,
          ),
          SizedBox(height: bodyGap),
          Text(
            'Gestioná perfiles, seguimiento, contactos y herramientas útiles desde una experiencia simple, clara y disponible desde cualquier dispositivo.',
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: benefitsGap),
          const _BenefitItem(
            title: 'Perfiles y datos siempre a mano',
          ),
          SizedBox(height: itemGap),
          const _BenefitItem(
            title: 'Seguimiento y trazabilidad en un solo espacio',
          ),
          SizedBox(height: itemGap),
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
    this.isDense = false,
  });

  final String title;
  final String description;
  final Widget child;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final shellPadding = isDense ? 14.0 : 16.0;
    final descriptionGap = isDense ? 6.0 : 8.0;
    final contentGap = isDense ? 12.0 : 14.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(shellPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: descriptionGap),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            SizedBox(height: contentGap),
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
    this.isDense = false,
  });

  final bool isLoginMode;
  final ValueChanged<bool> onModeChanged;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDense ? 4 : 6),
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
              isDense: isDense,
              onTap: () => onModeChanged(true),
            ),
          ),
          SizedBox(width: isDense ? 6 : 8),
          Expanded(
            child: _ModeButton(
              label: 'Crear cuenta',
              isActive: !isLoginMode,
              isDense: isDense,
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
    this.isDense = false,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isDense ? 12 : 14,
          vertical: isDense ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
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
    this.isDense = false,
    required this.isBusy,
    required this.onFamilyDemo,
    required this.onProfessionalDemo,
  });

  final bool isDense;
  final bool isBusy;
  final VoidCallback onFamilyDemo;
  final VoidCallback onProfessionalDemo;

  @override
  Widget build(BuildContext context) {
    final verticalPadding = isDense ? 12.0 : 16.0;
    final descriptionGap = isDense ? 5.0 : 8.0;
    final buttonGap = isDense ? 8.0 : 14.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(verticalPadding),
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
          SizedBox(height: descriptionGap),
          Text(
            'Si querés recorrer la experiencia antes de usar una cuenta propia, podés entrar con uno de estos perfiles de prueba.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          SizedBox(height: buttonGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final stackButtons = constraints.maxWidth < 340;

              if (stackButtons) {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: isDense
                            ? OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              )
                            : null,
                        onPressed: isBusy ? null : onFamilyDemo,
                        child: const Text('Demo familia'),
                      ),
                    ),
                    SizedBox(height: isDense ? 6 : 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: isDense
                            ? OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              )
                            : null,
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
                      style: isDense
                          ? OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            )
                          : null,
                      onPressed: isBusy ? null : onFamilyDemo,
                      child: const Text('Demo familia'),
                    ),
                  ),
                  SizedBox(width: isDense ? 8 : 12),
                  Expanded(
                    child: OutlinedButton(
                      style: isDense
                          ? OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            )
                          : null,
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
    this.isDense = false,
  });

  final ExperienceOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompactCard = constraints.maxWidth < 280;
        final padding = isCompactCard
            ? 12.0
            : (isDense ? 14.0 : 16.0);
        final titleHeight = isCompactCard ? 1.2 : 1.3;
        final subtitleHeight = isCompactCard ? 1.25 : (isDense ? 1.32 : 1.4);
        final subtitleSpacing = isCompactCard ? 2.0 : (isDense ? 3.0 : 4.0);

        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(option.accentColorHex)
                  : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? AppColors.dark : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  maxLines: isCompactCard ? 2 : null,
                  overflow: isCompactCard
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: titleHeight,
                  ),
                ),
                SizedBox(height: subtitleSpacing),
                Text(
                  option.subtitle,
                  maxLines: isCompactCard ? 2 : null,
                  overflow: isCompactCard
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: subtitleHeight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    this.isDense = false,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: label,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isDense ? 14 : 16,
          vertical: isDense ? 11 : 16,
        ),
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
