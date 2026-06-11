import 'package:flutter/material.dart';

import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<_HelpSection> _sections = [
    _HelpSection(
      title: 'Primeros pasos',
      body:
          'Carga tus mascotas, revisa su perfil y usa las acciones principales desde Inicio o Mascotas.',
      icon: Icons.flag_outlined,
    ),
    _HelpSection(
      title: 'Mascotas',
      body:
          'Cada mascota puede tener identidad, estado de salud, QR, momentos y preferencias sociales.',
      icon: Icons.pets_outlined,
    ),
    _HelpSection(
      title: 'QR seguro',
      body:
          'El QR ayuda a recibir avisos sin mostrar telefono, email ni direccion exacta del tutor.',
      icon: Icons.qr_code_rounded,
    ),
    _HelpSection(
      title: 'Salud y vacunas',
      body:
          'Mascotify ordena recordatorios e informacion basica. No reemplaza una consulta veterinaria.',
      icon: Icons.vaccines_outlined,
    ),
    _HelpSection(
      title: 'Mascotas perdidas',
      body:
          'Los avisos deben compartir datos utiles de la mascota y zona general, evitando informacion privada.',
      icon: Icons.travel_explore_rounded,
    ),
    _HelpSection(
      title: 'Clips',
      body:
          'Clips muestra videos cortos de Mascotify y comunidad demo. Podes silenciar, guardar y compartir.',
      icon: Icons.play_circle_outline_rounded,
    ),
    _HelpSection(
      title: 'Matching',
      body:
          'Elegi una mascota y busca compatibles por especie, raza, zona, edad, energia y objetivo.',
      icon: Icons.favorite_border_rounded,
    ),
    _HelpSection(
      title: 'Privacidad y seguridad',
      body:
          'No publiques telefonos, direcciones exactas ni datos sensibles. El contacto real debe ser mediado.',
      icon: Icons.shield_outlined,
    ),
    _HelpSection(
      title: 'Profesionales y servicios',
      body:
          'La experiencia profesional esta preparada para perfiles, contenido y servicios cuando el backend final este listo.',
      icon: Icons.storefront_outlined,
    ),
    _HelpSection(
      title: 'Preguntas frecuentes',
      body:
          'Si algo no carga, revisa la conexion y vuelve a intentar. Las funciones demo no publican informacion real.',
      icon: Icons.quiz_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 840,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.help_outline_rounded,
                        color: AppColors.primaryDeep,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Centro de ayuda',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Guias cortas para usar Mascotify con privacidad.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (final section in _sections)
                Card(
                  child: ExpansionTile(
                    leading: Icon(section.icon, color: AppColors.primaryDeep),
                    title: Text(section.title),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          section.body,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.35,
                              ),
                        ),
                      ),
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

class _HelpSection {
  const _HelpSection({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;
}
