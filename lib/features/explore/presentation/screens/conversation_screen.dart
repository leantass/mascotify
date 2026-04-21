import 'package:flutter/material.dart';

import '../../../../shared/data/app_data_source.dart';
import '../../../../shared/models/social_models.dart';
import '../../../../shared/widgets/responsive_page_body.dart';
import '../../../../theme/app_colors.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.thread});

  final MessageThread thread;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();
  late MessageThread _thread;

  bool _isSimulatingReply = false;

  @override
  void initState() {
    super.initState();
    _thread = AppData.findMessageThreadById(widget.thread.id) ?? widget.thread;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final thread = _thread;

    return Scaffold(
      appBar: AppBar(title: const Text('Conversacion')),
      body: SafeArea(
        child: ResponsivePageBody(
          maxWidth: 1160,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 980;

              if (!isWide) {
                return Column(
                  children: [
                    Expanded(
                      child: _buildConversationPane(
                        context,
                        thread,
                        includeSummary: true,
                      ),
                    ),
                    _buildComposerPanel(context, thread, compact: true),
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 320,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ThreadSummaryCard(thread: thread),
                            const SizedBox(height: 12),
                            _ContextSummaryCard(thread: thread),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: _buildConversationPane(
                                context,
                                thread,
                                includeSummary: false,
                              ),
                            ),
                            _buildComposerPanel(context, thread, compact: false),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildConversationPane(
    BuildContext context,
    MessageThread thread, {
    required bool includeSummary,
  }) {
    return Column(
      children: [
        if (includeSummary) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: _ThreadSummaryCard(thread: thread),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _ContextSummaryCard(thread: thread),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: _ConversationHeaderBar(thread: thread),
          ),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, includeSummary ? 0 : 0, 20, 16),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            decoration: BoxDecoration(
              color: includeSummary ? AppColors.surface : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.builder(
              itemCount: thread.messages.length,
              itemBuilder: (context, index) {
                final message = thread.messages[index];
                return _MessageBubble(
                  message: message,
                  accentColor: Color(thread.accentColorHex),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComposerPanel(
    BuildContext context,
    MessageThread thread, {
    required bool compact,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        borderRadius: compact
            ? BorderRadius.zero
            : const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Respuestas rapidas mock',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: thread.autoReplies
                .take(3)
                .map(
                  (reply) => ActionChip(
                    backgroundColor: AppColors.surfaceAlt,
                    label: Text(reply),
                    onPressed: () {
                      setState(() {
                        _messageController.text = reply;
                        _messageController.selection = TextSelection.collapsed(
                          offset: reply.length,
                        );
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          if (_isSimulatingReply)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '${thread.ownerName} esta escribiendo una respuesta mock...',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Esta mensajeria mantiene el contexto del interes original y simula un intercambio seguro entre familias dentro de Mascotify.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final stackComposer = compact || constraints.maxWidth < 560;

              if (stackComposer) {
                return Column(
                  children: [
                    TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Escribir mensaje dentro de Mascotify',
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _sendMessage,
                        child: const Text('Enviar'),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Escribir mensaje dentro de Mascotify',
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _sendMessage,
                      child: const Text('Enviar'),
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

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final threadId = _thread.id;
    await AppData.sendMessage(threadId, text);
    _reloadThread();
    if (!mounted) return;

    setState(() {
      _messageController.clear();
      _isSimulatingReply = _thread.autoReplies.isNotEmpty;
    });

    if (_thread.autoReplies.isEmpty) return;

    await Future<void>.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;

    await AppData.addAutomatedReply(threadId);
    _reloadThread();
    if (!mounted) return;

    setState(() {
      _isSimulatingReply = false;
    });
  }

  void _reloadThread() {
    _thread = AppData.findMessageThreadById(widget.thread.id) ?? _thread;
  }
}

class _ThreadSummaryCard extends StatelessWidget {
  const _ThreadSummaryCard({required this.thread});

  final MessageThread thread;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(thread.accentColorHex),
            AppColors.surface,
            AppColors.primarySoft,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.forum_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.ownerName,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thread.relatedLabel,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                label: thread.status,
                backgroundColor: Colors.white,
                textColor: AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                label: thread.connectionType,
                backgroundColor: Colors.white,
              ),
              _InfoPill(
                label: thread.stageLabel,
                backgroundColor: AppColors.surfaceAlt,
              ),
              _InfoPill(
                label: thread.entryPointLabel,
                backgroundColor: Colors.white.withValues(alpha: 0.72),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            thread.summary,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proximo paso sugerido',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  thread.nextStepLabel,
                  style: textTheme.bodyMedium?.copyWith(
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

class _ContextSummaryCard extends StatelessWidget {
  const _ContextSummaryCard({required this.thread});

  final MessageThread thread;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contexto asociado',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: thread.contextTags
                .map(
                  (tag) => _ContextChip(
                    label: tag,
                    backgroundColor: Colors.white,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'En browser, este bloque queda visible para no perder el hilo del interes original mientras lees o escribis mensajes.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationHeaderBar extends StatelessWidget {
  const _ConversationHeaderBar({required this.thread});

  final MessageThread thread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${thread.ownerName} - ${thread.lastActivity}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 12),
          _StatusPill(
            label: thread.status,
            backgroundColor: Colors.white,
            textColor: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.accentColor});

  final MessageEntry message;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final alignment = message.isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final bubbleColor = message.isMine ? AppColors.dark : accentColor;
    final textColor = message.isMine ? Colors.white : AppColors.textPrimary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxBubbleWidth = constraints.maxWidth >= 760 ? 420.0 : 300.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.timestamp,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.backgroundColor});

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ContextChip extends StatelessWidget {
  const _ContextChip({required this.label, required this.backgroundColor});

  final String label;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
