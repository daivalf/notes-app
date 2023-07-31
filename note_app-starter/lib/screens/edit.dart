import 'package:flutter/material.dart';

import '../models/note.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

TextEditingController _titleController = TextEditingController();
TextEditingController _contentController = TextEditingController();

@override
  void initState() {
    // TODO: implement initState
if(widget.note != null) {
  _titleController = TextEditingController(text: widget.note!.title);
  _contentController = TextEditingController(text: widget.note!.content);
}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF3D7F67),
        leading: new IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: new Icon(Icons.arrow_back_ios_new, color: Color(0xFFF0E9E0),)
          ),
        actions: [
          IconButton(onPressed: () {
            Navigator.pop(context, [
              _titleController.text,
              _contentController.text,
            ]);
          }, 
          icon: Icon(Icons.check, color: Color(0xFFF0E9E0),)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          children: [
            Row(
              children: [

              ],
            ),
            Expanded(child: ListView(
              children: [
                TextField(
                  controller: _titleController,
                  style: TextStyle(color: Color(0xFF293942), fontSize: 36),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Judul',
                    hintStyle: TextStyle(color: Color(0xFF293942).withOpacity(0.5), fontSize: 36),
                  ),
                ),
                TextField(
                  controller: _contentController,
                  style: TextStyle(color: Color(0xFF293942)),
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis deskripsi..',
                    hintStyle: TextStyle(color: Color(0xFF293942).withOpacity(0.5), fontSize: 16),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}