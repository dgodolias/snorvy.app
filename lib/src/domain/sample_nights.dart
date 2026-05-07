import 'package:snorvy/src/domain/sleep_models.dart';

List<SleepNight> buildSampleNights() {
  final today = DateTime.now();
  final baseNight = DateTime(today.year, today.month, today.day);

  return List.generate(7, (index) {
    final date = baseNight.subtract(Duration(days: index));
    final start = date.subtract(const Duration(hours: 1, minutes: 22));
    final end = date.add(Duration(hours: 6, minutes: 42 + index * 4));
    final score = [42, 37, 51, 28, 63, 49, 35][index];

    return SleepNight(
      date: date,
      startedAt: start,
      endedAt: end,
      snoreScore: score,
      isManual: index == 3,
      events: index == 3
          ? const []
          : [
              SleepEvent(
                id: index * 10,
                kind: SleepEventKind.snore,
                startsAt: start.add(Duration(hours: 1, minutes: 18 + index)),
                duration: Duration(seconds: 42 + index * 3),
                intensity: 74 - index,
              ),
              SleepEvent(
                id: index * 10 + 1,
                kind: SleepEventKind.talk,
                startsAt: start.add(Duration(hours: 3, minutes: 4 + index)),
                duration: Duration(seconds: 16 + index),
                intensity: 58 + index,
              ),
              SleepEvent(
                id: index * 10 + 2,
                kind: SleepEventKind.snore,
                startsAt: start.add(Duration(hours: 4, minutes: 31 + index)),
                duration: Duration(seconds: 67 + index * 2),
                intensity: 81 - index,
              ),
            ],
    );
  });
}
