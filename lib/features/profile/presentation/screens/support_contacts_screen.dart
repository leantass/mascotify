import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../theme/app_colors.dart';
import '../../data/support_contact_channels.dart';

class SupportContactsScreen extends StatelessWidget {
  const SupportContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SupportScaffold(title: 'Contactos', child: _ContactsBody());
  }
}

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: mascotifySupportChannels.email,
      queryParameters: {'subject': 'Soporte Mascotify'},
    ).toString();
    final launched = await launchUrlString(uri);
    if (!context.mounted || launched) return;
    _showMessage(context, 'No pudimos abrir el cliente de email.');
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final phone = mascotifySupportChannels.whatsAppPhone;
    if (phone == null || phone.isEmpty) {
      _showMessage(context, 'WhatsApp de soporte pendiente de configurar.');
      return;
    }

    final launched = await launchUrlString('https://wa.me/$phone');
    if (!context.mounted || launched) return;
    _showMessage(context, 'No pudimos abrir WhatsApp.');
  }

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Soporte al cliente',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _IntroCard(
            icon: Icons.support_agent_rounded,
            title: 'Soporte al cliente',
            body:
                'Si necesitás ayuda con Mascotify, podés comunicarte con soporte o reportar un problema desde esta sección.',
          ),
          const SizedBox(height: 14),
          _SupportActionCard(
            key: const ValueKey('support-email-action'),
            icon: Icons.email_outlined,
            title: 'Enviar email a soporte',
            subtitle: mascotifySupportChannels.email,
            onTap: () => _openEmail(context),
          ),
          const SizedBox(height: 10),
          _SupportActionCard(
            key: const ValueKey('support-whatsapp-action'),
            icon: Icons.chat_outlined,
            title: 'Contactar por WhatsApp',
            subtitle: mascotifySupportChannels.hasWhatsApp
                ? 'Canal configurado'
                : 'WhatsApp de soporte: ${mascotifySupportChannels.whatsAppLabel}',
            onTap: () => _openWhatsApp(context),
          ),
          const SizedBox(height: 10),
          _SupportActionCard(
            key: const ValueKey('support-report-action'),
            icon: Icons.bug_report_outlined,
            title: 'Reportar un problema',
            subtitle: 'Enviar un reporte local para revisión.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ReportProblemScreen(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _SupportActionCard(
            key: const ValueKey('support-faq-action'),
            icon: Icons.quiz_outlined,
            title: 'Ver preguntas frecuentes',
            subtitle: 'Consultar respuestas rápidas sobre Mascotify.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SupportFaqScreen()),
            ),
          ),
          const SizedBox(height: 14),
          const _WarningCard(
            text:
                'No compartas contraseñas, códigos ni datos sensibles por canales no oficiales.',
          ),
        ],
      ),
    );
  }
}

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _contactController = TextEditingController();
  String _problemType = 'Error en la app';
  bool _submitted = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Reportar un problema',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _IntroCard(
              icon: Icons.feedback_outlined,
              title: 'Reporte local/demo',
              body:
                  'Este formulario deja preparada la experiencia local. La conexión con backend de soporte queda pendiente para producción.',
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              key: const ValueKey('support-report-type-field'),
              initialValue: _problemType,
              isExpanded: true,
              decoration: _fieldDecoration('Tipo de problema'),
              items: const [
                DropdownMenuItem(
                  value: 'Error en la app',
                  child: Text('Error en la app'),
                ),
                DropdownMenuItem(
                  value: 'Problema con mi cuenta',
                  child: Text('Problema con mi cuenta'),
                ),
                DropdownMenuItem(
                  value: 'Mascota, QR o reporte',
                  child: Text('Mascota, QR o reporte'),
                ),
                DropdownMenuItem(value: 'Otro', child: Text('Otro')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _problemType = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('support-report-description-field'),
              controller: _descriptionController,
              minLines: 4,
              maxLines: 8,
              decoration: _fieldDecoration('Descripción'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es requerida.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const ValueKey('support-report-contact-field'),
              controller: _contactController,
              keyboardType: TextInputType.emailAddress,
              decoration: _fieldDecoration('Email/contacto opcional'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const ValueKey('support-report-submit-button'),
              onPressed: _submit,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Enviar reporte'),
            ),
            if (_submitted) ...[
              const SizedBox(height: 14),
              const _SuccessCard(
                text: 'Gracias. Registramos tu reporte para revisión.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SupportFaqScreen extends StatelessWidget {
  const SupportFaqScreen({super.key});

  static const _items = [
    (
      'Cómo cargar una mascota',
      'Entrá en Mascotas y usá la acción para agregar un perfil con datos básicos, foto y ubicación.',
    ),
    (
      'Cómo reportar una mascota perdida',
      'Desde Mascotas perdidas podés publicar un aviso local/demo con zona, descripción y contacto visible.',
    ),
    (
      'Cómo funciona el QR',
      'El QR conecta el perfil público de la mascota con trazabilidad y acciones de contacto seguro.',
    ),
    (
      'Qué pasa si alguien escanea el QR',
      'La app puede registrar señales de escaneo y guiar a quien encontró la mascota hacia el perfil público.',
    ),
    (
      'Cómo funcionan los planes Free/Plus/Pro',
      'Los planes muestran límites y beneficios dentro de la app; los pagos reales no están activos en esta build.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _SupportScaffold(
      title: 'Ayuda / Preguntas frecuentes',
      child: Column(
        children: [
          for (final item in _items) ...[
            _FaqTile(question: item.$1, answer: item.$2),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ContactsBody extends StatelessWidget {
  const _ContactsBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _IntroCard(
          icon: Icons.contact_support_outlined,
          title: 'Contactos',
          body:
              'Encontrá canales de ayuda, reportes y recursos oficiales de Mascotify desde un solo lugar.',
        ),
        const SizedBox(height: 14),
        _SupportActionCard(
          key: const ValueKey('contacts-customer-support-action'),
          icon: Icons.support_agent_rounded,
          title: 'Soporte al cliente',
          subtitle: 'Email, WhatsApp y acciones de ayuda.',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CustomerSupportScreen(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _SupportActionCard(
          key: const ValueKey('contacts-report-problem-action'),
          icon: Icons.bug_report_outlined,
          title: 'Reportar un problema',
          subtitle: 'Formulario local/demo pendiente de backend.',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ReportProblemScreen(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _SupportActionCard(
          key: const ValueKey('contacts-faq-action'),
          icon: Icons.quiz_outlined,
          title: 'Ayuda / Preguntas frecuentes',
          subtitle: 'Respuestas simples para tareas comunes.',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const SupportFaqScreen()),
          ),
        ),
        const SizedBox(height: 10),
        _InfoCard(
          icon: Icons.public_outlined,
          title: 'Canales oficiales',
          lines: [
            'Email: ${mascotifySupportChannels.email}',
            'WhatsApp de soporte: ${mascotifySupportChannels.whatsAppLabel}',
            'Sitio web: ${mascotifySupportChannels.websiteLabel}',
          ],
        ),
      ],
    );
  }
}

class _SupportScaffold extends StatelessWidget {
  const _SupportScaffold({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth >= 900
                ? 760.0
                : double.infinity;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _IconBadge(icon: icon),
              const SizedBox(width: 14),
              Expanded(
                child: _TitleSubtitle(title: title, subtitle: subtitle),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _InfoSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: _TitleSubtitle(title: title, subtitle: body),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return _InfoSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final line in lines) ...[
                  Text(
                    line,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _InfoSurface(
      color: AppColors.supportSoft,
      child: Row(
        children: [
          const Icon(Icons.privacy_tip_outlined, color: AppColors.textPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _InfoSurface(
      color: AppColors.accentSoft,
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return _InfoSurface(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(question),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSurface extends StatelessWidget {
  const _InfoSurface({required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColors.primaryDeep),
    );
  }
}

class _TitleSubtitle extends StatelessWidget {
  const _TitleSubtitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
