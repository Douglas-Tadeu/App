class ApiConfig {
  // ====== URLs PADRÃO ======

  // Para testes no Windows/Chrome (desktop)
  static const String _desktopBaseUrl = "http://localhost:5500";

  // Para emulador Android (10.0.2.2 é o "localhost" do emulador)
  static const String _emulatorBaseUrl = "http://10.0.2.2:5500";

  // Para celular físico via USB/Wi-Fi — coloque seu IPv4 aqui
  // Exemplo: 192.168.1.75
  static const String _deviceBaseUrl = "http://192.168.1.75:5500";

  // ====== SELETOR AUTOMÁTICO ======
  //
  // Você pode mudar apenas esta linha para trocar o ambiente:
  //
  // 1 → Desktop (Windows / Web)
  // 2 → Emulador Android
  // 3 → Celular físico (USB ou Wi-Fi)
  //
  static const int ambiente = 1;

  // ====== URL FINAL USADA NO APLICATIVO ======
  static String get baseUrl {
    switch (ambiente) {
      case 1:
        return _desktopBaseUrl;
      case 2:
        return _emulatorBaseUrl;
      case 3:
        return _deviceBaseUrl;
      default:
        return _desktopBaseUrl;
    }
  }
}
