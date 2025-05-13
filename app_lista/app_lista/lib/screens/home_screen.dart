import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/note_storage.dart';
import 'edit_note_screen.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Cargar notas al iniciar
  }

  // Cargar notas desde shared_preferences
  void _loadNotes() async {
    final loadedNotes = await NoteStorage.loadNotes();
    setState(() {
      _notes.addAll(loadedNotes);
    });
  }

  // Agregar o editar una nota
  void _addOrEditNote(Note? note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNoteScreen(note: note),
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        final index = _notes.indexWhere((n) => n.id == result.id);
        if (index >= 0) {
          _notes[index] = result;
        } else {
          _notes.add(result);
        }
      });

      // Guardar notas después de agregar o editar
      await NoteStorage.saveNotes(_notes);
    }
  }

  // Eliminar una nota
  void _deleteNote(String id) async {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });

    // Guardar notas después de eliminar
    await NoteStorage.saveNotes(_notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notas y Listas')),
      body: _notes.isEmpty
          ? Center(child: Text('No hay notas aún'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (ctx, i) => NoteCard(
                note: _notes[i],
                onTap: () => _addOrEditNote(_notes[i]),
                onDelete: () => _deleteNote(_notes[i].id),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(null), // Añadir una nueva nota
        child: Icon(Icons.add),
      ),
    );
  }
}
