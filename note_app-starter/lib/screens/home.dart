import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';

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
  filteredNotes = sampleNotes;
}

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
        backgroundColor: Color(0xFF3D737F),
        title: TextField(
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
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
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
                  decoration: BoxDecoration(color: Color(0xFF3D737F),
                  borderRadius: BorderRadius.circular(30)),
                  child: Icon(Icons.question_mark, color: Color(0xFFF0E9E0),)))
              ],
            ),
            SizedBox(height: 10,),
            Expanded(child: ListView.builder(
              padding: EdgeInsets.only(top:20),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Color(0xFF3D737F),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: IconButton(onPressed: () {},
                      icon: Icon(
                        Icons.circle_outlined, color: Color(0xFFF0E9E0),
                      ),
                      ),
                      title: RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                        text: '${filteredNotes[index].title} \n',
                        style: TextStyle(
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
                          'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
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
        child: FloatingActionButton(onPressed: (){
      
        },
        elevation: 15,
        backgroundColor: Color(0xFF293942),
        child: Icon(
          Icons.add,
          size: 40,
          color: Color(0xFFF0E9E0),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}