import 'package:timeago/timeago.dart' as timeago;

class Timeago {
  String getTimeago(int? time) {
    final now = DateTime.now();
    final datetime = time == null ? now : DateTime.fromMillisecondsSinceEpoch(time);
    final difference = now.difference(datetime);
    final timefinal = timeago.format(now.subtract(difference));

    return timefinal;
  }
}
