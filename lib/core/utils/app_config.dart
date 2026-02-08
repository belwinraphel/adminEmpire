enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String appName;
  final String apiBaseUrl;
  final bool useFirebase;

  AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    this.useFirebase = true, // Default to Firebase
  });
}
