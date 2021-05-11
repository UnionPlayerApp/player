class ScheduleItemRaw {
  final DateTime start;
  final Duration duration;
  final String title;
  final String? description;
  final String artist;
  final String? guest;
  final String? imageUrl;

  ScheduleItemRaw(this.start, this.duration, this.title, this.artist,
      {this.description, this.guest, this.imageUrl});
}
