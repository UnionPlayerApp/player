abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsInitEvent extends SettingsEvent {}

class SettingsChangedEvent<T> extends SettingsEvent {
  final T value;

  const SettingsChangedEvent({required this.value});
}
