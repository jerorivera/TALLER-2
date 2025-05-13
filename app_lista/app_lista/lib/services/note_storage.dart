import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import 'dart:convert';

class NoteStorage {
  static const String _key = 'notes';

  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  static Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    if (saved == null) return [];
    return saved.map((s) => Note.fromJson(jsonDecode(s))).toList();
  }
}
