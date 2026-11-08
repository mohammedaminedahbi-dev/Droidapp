import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Progress {
  int unlocked = 1;
  int coins = 30;
  int played = 0;
  int wins = 0;
  int streak = 0;
  int bestStreak = 0;
  int totalGuesses = 0;
  bool sound = true;
  bool haptics = true;
  final Set<int> completed = {};
  final Map<int, int> attemptsByLevel = {};

  double get winRate => played == 0 ? 0 : wins * 100 / played;
  int get averageGuesses => wins == 0 ? 0 : (totalGuesses / wins).round();

  Map<String, dynamic> toJson() => {
    'unlocked': unlocked, 'coins': coins, 'played': played, 'wins': wins,
    'streak': streak, 'bestStreak': bestStreak, 'totalGuesses': totalGuesses,
    'sound': sound, 'haptics': haptics, 'completed': completed.toList(),
    'attempts': attemptsByLevel.map((k,v) => MapEntry(k.toString(),v)),
  };

  void load(Map<String, dynamic> j) {
    unlocked = (j['unlocked'] as num?)?.toInt() ?? 1;
    coins = (j['coins'] as num?)?.toInt() ?? 30;
    played = (j['played'] as num?)?.toInt() ?? 0;
    wins = (j['wins'] as num?)?.toInt() ?? 0;
    streak = (j['streak'] as num?)?.toInt() ?? 0;
    bestStreak = (j['bestStreak'] as num?)?.toInt() ?? 0;
    totalGuesses = (j['totalGuesses'] as num?)?.toInt() ?? 0;
    sound = j['sound'] as bool? ?? true;
    haptics = j['haptics'] as bool? ?? true;
    completed..clear()..addAll((j['completed'] as List? ?? []).whereType<num>().map((e)=>e.toInt()));
    attemptsByLevel..clear()..addAll((j['attempts'] as Map? ?? {}).map((k,v)=>MapEntry(int.parse(k.toString()), (v as num).toInt())));
    unlocked = unlocked.clamp(1, 120).toInt();
    coins = coins.clamp(0, 999999).toInt();
  }
}

class ProgressStore {
  static const _key = 'letterforge_progress_v1';
  Future<Progress> load() async {
    final p = Progress();
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) p.load(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) { /* Start safely with fresh progress if storage is corrupt. */ }
    return p;
  }
  Future<void> save(Progress p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(p.toJson()));
  }
}
