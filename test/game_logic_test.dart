import 'package:flutter_test/flutter_test.dart';
import 'package:letterforge/domain/game_logic.dart';
import 'package:letterforge/data/word_bank.dart';

void main() {
  group('duplicate-aware evaluation', () {
    test('marks exact matches green before allocating yellows', () {
      expect(evaluateGuess('APPLE', 'APPLE'), everyElement(LetterMark.correct));
    });
    test('does not overcount repeated letters', () {
      expect(evaluateGuess('ALLEY', 'APPLE'), [LetterMark.correct, LetterMark.present, LetterMark.absent, LetterMark.present, LetterMark.absent]);
    });
    test('repeated answer letters can each be present only once per available copy', () {
      expect(evaluateGuess('EERIE', 'LEVEL'), [LetterMark.present, LetterMark.correct, LetterMark.absent, LetterMark.absent, LetterMark.absent]);
    });
    test('rejects non-five-letter guesses and accepts known offline words', () {
      expect(isValidGuess('APPLE'), isTrue);
      expect(isValidGuess('XYZQW'), isFalse);
      expect(() => evaluateGuess('CAT', 'APPLE'), throwsArgumentError);
    });
    test('contains at least 100 distinct level words', () {
      final pool = <String>{...levelWords, ...extraWords}.toList();
      expect(pool.length, greaterThanOrEqualTo(120));
      expect(pool.take(120).toSet().length, 120);
    });
  });
}
