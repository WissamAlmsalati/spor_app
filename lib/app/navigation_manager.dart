class NavigationManager {
  static final NavigationManager _instance = NavigationManager._internal();
  bool _hasNavigatedToOnboarding = false;

  factory NavigationManager() {
    return _instance;
  }

  NavigationManager._internal();

  bool get hasNavigatedToOnboarding => _hasNavigatedToOnboarding;

  void setNavigatedToOnboarding() {
    _hasNavigatedToOnboarding = true;
  }
}