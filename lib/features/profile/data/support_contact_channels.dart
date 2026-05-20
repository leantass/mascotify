class SupportContactChannels {
  const SupportContactChannels({
    required this.email,
    required this.whatsAppLabel,
    required this.websiteLabel,
    this.whatsAppPhone,
    this.websiteUrl,
  });

  final String email;
  final String whatsAppLabel;
  final String websiteLabel;
  final String? whatsAppPhone;
  final String? websiteUrl;

  bool get hasWhatsApp => whatsAppPhone != null && whatsAppPhone!.isNotEmpty;
  bool get hasWebsite => websiteUrl != null && websiteUrl!.isNotEmpty;
}

const mascotifySupportChannels = SupportContactChannels(
  email: 'soporte@mascotify.app',
  whatsAppLabel: 'pendiente de configurar',
  websiteLabel: 'pendiente de configurar',
);
