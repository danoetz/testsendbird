import 'package:flutter/foundation.dart';
import 'package:timeago/timeago.dart' as timeago;

class Timeago {
  String getTimeago(int? time) {
    final now = DateTime.now();
    final datetime = time == null ? now : DateTime.fromMillisecondsSinceEpoch(time);
    debugPrint('datetime: $datetime');
    final difference = now.difference(datetime);
    debugPrint('difference: $difference');
    final timefinal = timeago.format(now.subtract(difference));
    debugPrint('timefinal: $timefinal');

    return timefinal;
  }
}
