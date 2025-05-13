import 'package:flutter/material.dart';
import '../models/note.dart';
import 'dart:convert';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityIn;
  late Animation<double> _scaleIn;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityIn = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleIn = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String preview =
        widget.note.type == NoteType.text
            ? widget.note.content
            : jsonDecode(widget.note.content)
                .map<String>(
                  (item) =>
                      '${item["checked"] ? "[x]" : "[ ]"} ${item["text"]}',
                )
                .join('\n');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityIn.value,
            child: Transform.scale(
              scale: _scaleIn.value,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _isHovered ? 0.9 : 1.0,
                child: child,
              ),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4,
          child: ListTile(
            title: Text(
              widget.note.title.isEmpty ? 'SIN TITULO' : widget.note.title,
            ),
            subtitle: Text(
              preview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: widget.onTap,
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ),
        ),
      ),
    );
  }
}
