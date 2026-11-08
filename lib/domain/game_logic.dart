import '../data/word_bank.dart';

enum LetterMark { absent, present, correct }

/// Word scoring follows duplicate-aware two-pass evaluation.
List<LetterMark> evaluateGuess(String guess, String answer) {
  if (guess.length != 5 || answer.length != 5) {
    throw ArgumentError('Both words must contain exactly five letters.');
  }
  final result = List<LetterMark>.filled(5, LetterMark.absent);
  final remaining = <String, int>{};
  for (var i = 0; i < 5; i++) {
    if (guess[i] == answer[i]) {
      result[i] = LetterMark.correct;
    } else {
      remaining[answer[i]] = (remaining[answer[i]] ?? 0) + 1;
    }
  }
  for (var i = 0; i < 5; i++) {
    if (result[i] == LetterMark.correct) continue;
    final count = remaining[guess[i]] ?? 0;
    if (count > 0) {
      result[i] = LetterMark.present;
      remaining[guess[i]] = count - 1;
    }
  }
  return result;
}

bool isValidGuess(String word) => word.length == 5 && validWords.contains(word.toUpperCase());

String hintFor(String answer, int hintIndex) {
  final vowels = answer.split('').where((c) => 'AEIOU'.contains(c)).length;
  switch (hintIndex % 3) {
    case 0: return 'The word starts with ${answer[0]}.';
    case 1: return 'The word contains $vowels vowel${vowels == 1 ? '' : 's'}.';
    default: return 'The word ends with ${answer[4]}.';
  }
}
