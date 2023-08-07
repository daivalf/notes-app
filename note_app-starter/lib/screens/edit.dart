import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import 'package:file_picker/file_picker.dart';

class EditScreen extends StatefulWidget {
  final Note? note;
  const EditScreen({super.key, this.note});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

TextEditingController _titleController = TextEditingController();
TextEditingController _contentController = TextEditingController();
TextEditingController _dateController = TextEditingController();

List<PlatformFile> attachments = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        attachments.add(result.files.single);
      });
    }
  }

// void _showDeleteConfirmationDialog() async {
//     showDialog(
//     context: context, 
//     builder: (context) {
//       return AlertDialog(
//         title: Text('Hapus Tugas?'),
//         content: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3D4C7F),
//               padding: EdgeInsets.all(16)),
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//               child: SizedBox(
//                 width: 60,
//                 child: Text('Batal',
//                 textAlign: TextAlign.center,),
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD63636),
//               padding: EdgeInsets.all(16)),
//               onPressed: (){
//                 Navigator.pop(context);
//               },
//               child: SizedBox(
//                 width: 60,
//                 child: Text('Hapus',
//                 textAlign: TextAlign.center,),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

@override
  void initState() {
    // TODO: implement initState
  if(widget.note != null) {
    _titleController = TextEditingController(text: widget.note!.title);
    _contentController = TextEditingController(text: widget.note!.content);
    _dateController = TextEditingController(text: DateFormat('EEEE, d MMMM yyyy, h:mm a', 'id_ID').format(widget.note!.selectedDate));
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
        // actions: <Widget>[
        //   if (widget.note != null)
        //   IconButton(onPressed: (){
        //   }, 
        //     icon: Icon(Icons.delete, color: Color(0xFFF0E9E0),)
        //   ),
        // ],
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
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0,),
                    ),
                      enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _contentController,
                  style: TextStyle(color: Color(0xFF293942), fontSize: 16),
                  maxLines: null,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 20, color: Color(0xFF293942)),
                    contentPadding: EdgeInsets.only(bottom: 40),
                    border: InputBorder.none,
                    hintText: 'Tulis deskripsi..',
                    hintStyle: TextStyle(color: Color(0xFF293942).withOpacity(0.5), fontSize: 16),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0,),
                    ),
                      enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _dateController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3D7F67), 
                    fontWeight: FontWeight.bold, 
                    fontSize: 16
                  ),
                  decoration: InputDecoration(
                    hintText: 'Pilih tanggal dan waktu',
                    hintStyle: TextStyle(
                      color: Color(0xFF3D7F67), 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
                    ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context, 
                      initialDate: widget.note?.selectedDate ?? DateTime.now(), 
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                      context: context, 
                      initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        DateTime pickedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        setState(() {
                        _dateController.text = DateFormat('EEEE, d MMMM yyyy, h:mm a', 'id_ID').format(pickedDateTime);
                        widget.note?.selectedDate = pickedDateTime;
                      });
                      }
                    }
                  },
                ),
                SizedBox(height: 20,),
                // TextField(
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Color(0xFF3D7F67), 
                //     fontWeight: FontWeight.bold, 
                //     fontSize: 16
                //   ),
                //   decoration: InputDecoration(
                //     hintText: 'Tambah file lampiran',
                //     hintStyle: TextStyle(
                //       color: Color(0xFF3D7F67), 
                //       fontWeight: FontWeight.bold, 
                //       fontSize: 16),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(30),
                //       borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
                //     ),
                //       enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(30),
                //       borderSide: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
                //     ),
                //   ),
                //   readOnly: true,
                //   onTap: () {
                //     _pickFile();
                //   },
                // ),
                // Column(
                //   children: attachments.map((attachment) {
                //     return Text(attachment.name);
                //   }).toList(),
                // ),
              ],
            ),)
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(onPressed: () {
            Navigator.pop(context, [
              _titleController.text,
              _contentController.text,
              _dateController.text,
            ]);
        },
        elevation: 20,
        backgroundColor: Color(0xFF3D4C7F),
        child: Icon(
          Icons.save,
          size: 40,
          color: Color(0xFFF0E9E0),
          ),
        ),
      ),
    );
  }
}