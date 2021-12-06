class Env {
  Env(this.baseUrl);

  final String baseUrl;
}

mixin EnvValue {
  static final Env development = Env('');
  static final Env staging = Env('');
  static final Env production = Env('');
}
