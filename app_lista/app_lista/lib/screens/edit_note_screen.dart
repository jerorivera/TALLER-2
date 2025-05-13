import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import 'dart:convert';

class EditNoteScreen extends StatefulWidget {
  final Note? note;

  EditNoteScreen({this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _textContentController;
  late List<Map<String, dynamic>> _checklistItems;
  NoteType _noteType = NoteType.text;

  @override
  void initState() {
    super.initState();
    _noteType = widget.note?.type ?? NoteType.text;
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _textContentController = TextEditingController(
        text: widget.note?.type == NoteType.text ? widget.note?.content ?? '' : '');
    _checklistItems = widget.note?.type == NoteType.checklist
        ? List<Map<String, dynamic>>.from(jsonDecode(widget.note!.content))
        : [];
  }

  void _saveNote() {
    final id = widget.note?.id ?? Uuid().v4();
    final title = _titleController.text.trim();
    final content = _noteType == NoteType.text
        ? _textContentController.text
        : jsonEncode(_checklistItems);

    Navigator.of(context).pop(
      Note(id: id, title: title, content: content, type: _noteType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Tipo de Nota'),
            trailing: DropdownButton<NoteType>(
              value: _noteType,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _noteType = val;
                  });
                }
              },
              items: [
                DropdownMenuItem(
                  child: Text('Texto'),
                  value: NoteType.text,
                ),
                DropdownMenuItem(
                  child: Text('Checklist'),
                  value: NoteType.checklist,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
          ),
          Expanded(
            child: _noteType == NoteType.text
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textContentController,
                      maxLines: null,
                      decoration: InputDecoration(labelText: 'Contenido'),
                    ),
                  )
                : ListView.builder(
                    itemCount: _checklistItems.length + 1,
                    itemBuilder: (ctx, i) {
                      if (i == _checklistItems.length) {
                        return ListTile(
                          title: Text('Agregar ítem'),
                          trailing: Icon(Icons.add),
                          onTap: () {
                            setState(() {
                              _checklistItems.add({"text": "", "checked": false});
                            });
                          },
                        );
                      }

                      return CheckboxListTile(
                        value: _checklistItems[i]['checked'],
                        onChanged: (val) {
                          setState(() {
                            _checklistItems[i]['checked'] = val ?? false;
                          });
                        },
                        title: TextField(
                          decoration: InputDecoration(hintText: 'Tarea'),
                          onChanged: (val) {
                            _checklistItems[i]['text'] = val;
                          },
                          controller: TextEditingController(
                            text: _checklistItems[i]['text'],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
