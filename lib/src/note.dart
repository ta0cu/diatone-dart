import 'dart:math' as math;

const int chr = 12;
final double step = math.pow(2, 1 / chr).toDouble(); // 2^(1/12)

const List<String> tones = [ 'C', 'C♯', 'D', 'D♯', 'E', 'F',
                             'F♯', 'G', 'G♯', 'A', 'A♯', 'B', ];

class Note {
  /// Convert an ordinal (MIDI-style) to a note name.
  /// If [key] is true, the octave number is omitted.
  static String ord2tone(int i, {bool key = false}) {
    i += 48;
    var s = tones[i % chr];
    if (!key) s += (i ~/ chr).toString();
    return s;
  }

  /// Convert a note name (e.g. "C4", "A#3", "Bb2") to an ordinal.
  static int tone2ord(String s) {
    var i = 48;

    // Extract trailing digits (octave)
    final match = RegExp(r'(\d+)$').firstMatch(s);
    if (match != null) {
      i = int.parse(match.group(1)!) * chr;
    }

    // Find the base note index
    var idx = tones.indexOf(s[0].toUpperCase());
    if (idx == -1) return i - 48;

    // Handle accidental
    if (s.length > 1) {
      final acc = s[1];
      if (acc == 'b' || acc == '♭') idx -= 1;
      if (acc == '#' || acc == '♯') idx += 1;
    }

    return i + idx - 48;
  }

  /// Normalize input to a numeric ordinal.
  static num fix(dynamic i) {
    if (i is num) return i;
    if (i is String) {
      // If it starts with a digit, treat as ordinal
      if (i.isNotEmpty && RegExp(r'^\d').hasMatch(i)) {
        return int.parse(i);
      }
      return tone2ord(i);
    }
    throw ArgumentError('Cannot fix: $i');
  }

  /// Return the key name of a note (no octave) or its index if [ord] is true.
  static dynamic key(dynamic s, {bool ord = true}) {
    final fixed = fix(s);
    final name = ord2tone(fixed.toInt(), key: true);
    if (ord) {
      return tones.indexOf(name);
    }
    return name;
  }

  /// Alias for [key] with ord=false — returns the note name.
  static String name(dynamic s) => key(s, ord: false) as String;

  /// Get a list containing the note name.
  static List<String> get(dynamic s) => [name(s)];

  /// Get the frequency (Hz) of a note or ordinal. A4 = 440 Hz.
  static double getFreq(dynamic i) {
    final ord = fix(i).toDouble();
    return 440.0 * math.pow(step, ord - 9);
  }
}
