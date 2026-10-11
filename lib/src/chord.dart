import 'scale.dart';

const chords = {
  '':    [0, 2, 4],
  '7':   [0, 2, 4, 6.4],
  'maj7':[0, 2, 4, 6],
  'm':   [0, 2.4, 4],
  'm7':  [0, 2.4, 4, 6.4],
  'dim': [0, 2.4, 4.4],
  'sus4':[0, 3, 4],
  '5':   [0, 4],
};

class Chord {
  static List<String> get(String s, {bool relative = false}) {
    final scale = Scale.get(s);
    final type = s.length > 1 ? s.substring(1) : '';

    if (!chords.containsKey(type)) return [''];

    final notes = <String>[];
    for (final n in chords[type]!) {
      if (relative) {
        notes.add((n.floor() + 1).toString());
      } else if (n == n.floor()) {
        notes.add(scale[n.toInt() % scale.length]);
      } else {
        // half-step adjustment
        notes.add('${scale[n.toInt() % scale.length]}+');
      }
    }
    return notes;
  }
}
