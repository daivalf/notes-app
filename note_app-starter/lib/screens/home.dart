import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

List<Note> filteredNotes = [];

@override
void initState() {
  super.initState();
  initializeDateFormatting('id_ID', null);
  filteredNotes = sampleNotes;
}

// void toggleTaskCompletion(Note task, List<Note> filteredNotes) {
//   task.isCompleted = !task.isCompleted;
//   filteredNotes.sort((a, b) => a.isCompleted ? 1 : -1);
// }

void onSearchTextChanged(String searchText) {
setState(() {
  filteredNotes =
  sampleNotes.where((note) => note.title.toLowerCase().contains(searchText.
  toLowerCase()) || note.content.toLowerCase().contains(searchText.toLowerCase()))
  .toList();
});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF3D7F67),
        title: TextField(
          autofocus: false,
          onChanged: onSearchTextChanged,
          style: TextStyle(fontSize: 16, color: Color(0xFF293942)),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12),
            hintText: "Cari judul tugas",
            hintStyle: TextStyle(color: Color(0xFF293942).withOpacity(0.5)),
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFF293942).withOpacity(0.5),
            ),
            fillColor: Color(0xFFF0E9E0).withOpacity(0.7),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.transparent)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.transparent)
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daftar Tugas', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF293942)),),
                IconButton(
                  onPressed: (){},
                  padding: EdgeInsets.all(0),
                  icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Color(0xFF3D7F67),
                  borderRadius: BorderRadius.circular(30)),
                  child: Icon(Icons.question_mark, color: Color(0xFFF0E9E0),)))
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: filteredNotes.isEmpty
            ? Center(
              child: Text('Mulai menulis catatan \n dengan tombol + di bawah',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFf293942),),
              textAlign: TextAlign.center,
              ),
            )
            : ListView.builder(
              padding: EdgeInsets.only(top:20),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: filteredNotes[index].isCompleted
                  ? Color(0xFF3D7F67).withOpacity(0.6)
                  : Color(0xFF3D7F67),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (BuildContext context) => 
                            EditScreen(note: filteredNotes[index]),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            int originalIndex =  sampleNotes.indexOf(filteredNotes[index]);
                            sampleNotes[originalIndex]=Note(
                                id: sampleNotes[originalIndex].id, 
                                title: result[0], 
                                content: result[1], 
                                modifiedTime: DateTime.now(),);
                            filteredNotes[index] = Note(
                                id: filteredNotes[index].id, 
                                title: result[0], 
                                content: result[1], 
                                modifiedTime: DateTime.now(),);
                          });
                        }
                      },
                      leading: IconButton(onPressed: () {
                        setState(() {
                          // Toggle completion state of selected task
                          filteredNotes[index].isCompleted = !filteredNotes[index].isCompleted;
                            // move to the bottom
                            List<Note> completedTasks = [];
                            List<Note> incompleteTasks = [];
              
                            for (int i = 0; i < filteredNotes.length; i++) {
                              if (filteredNotes[i].isCompleted) {
                              completedTasks.add(filteredNotes[i]);
                              } else {
                              incompleteTasks.add(filteredNotes[i]);
                              }
                            }
              
                          filteredNotes.clear();
                          filteredNotes.addAll(incompleteTasks);
                          filteredNotes.addAll(completedTasks);
                        });
                      },
                      icon: filteredNotes[index].isCompleted
                      ? Icon(Icons.check_circle, color: Color(0xFFF0E9E0),)
                      : Icon(Icons.circle_outlined, color: Color(0xFFF0E9E0),),
                      ),
                      title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                        text: '${filteredNotes[index].title} \n',
                        style: TextStyle(
                          decoration: filteredNotes[index].isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Color(0xFFF0E9E0), 
                          height: 1.5),
                        children: [
                          TextSpan(
                            text: '${filteredNotes[index].content}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFF0E9E0),
                              height: 1.5),
                          )
                        ]
                      )
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Text(
                          'Diubah pada: ${DateFormat('EEEE, d MMMM yyyy, h:mm a', 'id_ID').format(filteredNotes[index].modifiedTime)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFF0E9E0),
                          )
                          ),
                      ),
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(onPressed: ()async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const EditScreen(),
          ),
          );
          
          if (result != null) {
            setState(() {
              sampleNotes.insert(
              0,
              Note(
                id: sampleNotes.length, 
                title: result[0],
                content: result[1], 
                modifiedTime: DateTime.now(),));
                filteredNotes = sampleNotes;
            });
          }

        },
        elevation: 20,
        backgroundColor: Color(0xFF3D4C7F),
        child: Icon(
          Icons.add,
          size: 40,
          color: Color(0xFFF0E9E0),
          ),
        ),
      ),
    );
  }
}