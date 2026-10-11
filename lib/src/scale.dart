import 'note.dart';

const scales = {
  '':  '221222',
  'm': '212212',
};

class Scale {
  static List<String> get(String s) {
    final tonic = Note.tone2ord(s);
    final type = s.length > 1 && !RegExp(r'\d').hasMatch(s[1]) ? s.substring(1) : '';
    if (!scales.containsKey(type)) return [''];

    final result = <String>[tones[tonic % chr]];
    var i = tonic;
    for (final interval in scales[type]!.split('')) {
      i += int.parse(interval);
      result.add(tones[i % chr]);
    }
    return result;
  }
}
