abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsInitEvent extends SettingsEvent {}

class SettingsChangedEvent<T> extends SettingsEvent {
  final T value;

  const SettingsChangedEvent({required this.value});
}

class SettingsContactUsEvent extends SettingsEvent {
  final String subject;
  final String error;

  const SettingsContactUsEvent({required this.subject, required this.error});
}
