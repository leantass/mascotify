import 'package:flutter/material.dart';

import '../../../../features/explore/presentation/screens/messages_inbox_screen.dart';
import '../../../../shared/models/pet.dart';
import '../../../../theme/app_colors.dart';

class ExpressInterestScreen extends StatefulWidget {
  const ExpressInterestScreen({super.key, required this.pet});

  final Pet pet;

  @override
  State<ExpressInterestScreen> createState() => _ExpressInterestScreenState();
}

class _ExpressInterestScreenState extends State<ExpressInterestScreen> {
  final _messageController = TextEditingController();
  String _interestType = 'Vínculo social';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Expresar interés')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(pet.colorHex), AppColors.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estás iniciando una intención de conexión con ${pet.name}.',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Este flujo mock representa el primer paso para futuras conexiones seguras dentro del módulo social de Mascotify.',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Color(pet.colorHex),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.pets_rounded,
                        color: AppColors.dark,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pet.name, style: textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            '${pet.species} - ${pet.breed}',
                            style: textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            pet.location,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lo que este perfil expresa mejor',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pet.matchingPreferences.matchSummary,
                      style: textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickMatchingTile(
                            label: 'Afinidad',
                            value: pet.matchingPreferences.preferredBondType,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickMatchingTile(
                            label: 'Ritmo',
                            value: pet.matchingPreferences.rhythmLabel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        pet.matchingPreferences.suggestedApproach,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tipo de interés', style: textTheme.titleLarge),
                    const SizedBox(height: 12),
                    RadioGroup<String>(
                      groupValue: _interestType,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _interestType = value;
                        });
                      },
                      child: Column(
                        children: [
                          ...[
                            'Vínculo social',
                            'Posible cría',
                            'Encuentro supervisado',
                          ].map(
                            (option) => RadioListTile<String>(
                              value: option,
                              activeColor: AppColors.accent,
                              contentPadding: EdgeInsets.zero,
                              title: Text(option),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Mensaje breve',
                        hintText:
                            'Contá por qué te interesa este perfil o qué tipo de conexión imaginás.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _sendInterest,
              child: const Text('Enviar intención'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendInterest() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        final pet = widget.pet;
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Intención registrada',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'La intención de conexión con ${pet.name} quedó registrada en este flujo mock y sería procesada por Mascotify como una interacción segura.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Tipo: $_interestType'
                    '${_messageController.text.isNotEmpty ? '\nMensaje: ${_messageController.text}' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.supportSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'Si la conexión avanza, esta intención pasaría primero por la bandeja social con el contexto de matching visible y después podría abrir una conversación cuidada entre familias dentro de la mensajería.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(this.context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MessagesInboxScreen(),
                            ),
                          );
                        },
                        child: const Text('Ir a mensajes'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(this.context).pop();
                        },
                        child: const Text('Entendido'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickMatchingTile extends StatelessWidget {
  const _QuickMatchingTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
