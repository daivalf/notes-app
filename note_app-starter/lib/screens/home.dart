import 'package:flutter/material.dart';
import 'package:PengingatKu/models/folder.dart';
import 'package:PengingatKu/models/note.dart';
import 'package:PengingatKu/screens/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List <Folder> folders = [];
  // List <Note> notes = [];
  Map<Folder, List<Note>> folderNotes = {};
  Folder? selectedFolder;
  bool _ascendingSort = true;

  void _addNewFolder(String folderName) {
    setState(() {
      // folders.add(Folder(folderName, []));
      // folderNotes[Folder(folderName, [])] = [];
      final newFolder = Folder(folderName, []);
      folderNotes[newFolder] = [];
      selectedFolder = newFolder;
    });
  }

  void _onFolderSelected(Folder folder) async {
    setState(() {
      selectedFolder = folder;
    });
    final updatedFolder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesScreen(
            folder: folder,
            onUpdateFolder: _updateFolder,
            notes: folderNotes[folder] ?? []),
      ),
    );

    if (updatedFolder != null) {
      setState(() {
        folderNotes[folder] = folderNotes.remove(folder)!;
        folderNotes[updatedFolder] = folderNotes[updatedFolder] ?? [];
      });
    }
  }

  void _updateFolder(Folder updatedFolder) {
    setState(() {
      List<Note>? notesOfCurrentFolder =
          folderNotes[selectedFolder]; // Use selectedFolder here

      folderNotes
          .remove(selectedFolder); // Remove the current folder from folderNotes
      folderNotes[updatedFolder] = notesOfCurrentFolder ??
          []; // Add the updated folder back to folderNotes
      selectedFolder =
          updatedFolder; // Update selectedFolder with the new folder
    });
  }

  Future<dynamic> _deleteConfirmationFolder(
      BuildContext context, Folder folder) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Hapus Grup? \n\n',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF293942),
                      height: 1.5),
                  children: [
                    TextSpan(
                        text: 'Grup dengan nama ',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF293942),
                            height: 1.5),
                        children: [
                          TextSpan(
                              text: '\"${folder.name}\"',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          TextSpan(
                            text:
                                ' akan terhapus dan tidak bisa dikembalikan lagi.\n',
                          )
                        ])
                  ])),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3D4C7F),
                    padding: EdgeInsets.all(16)),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'Batal',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD63636),
                    padding: EdgeInsets.all(16)),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: SizedBox(
                  width: 60,
                  child: Text(
                    'Hapus',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteFolder(Folder folder) {
    setState(() {
      folderNotes.remove(folder);
      if (selectedFolder == folder) {
        selectedFolder == null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF3D7F67),
        centerTitle: true,
        title: Text('Aplikasi Pengingat'),
        titleTextStyle: TextStyle(
            color: Color(0xFFF0E9E0),
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Grup',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF293942)),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _ascendingSort = !_ascendingSort;

                        List<Folder> sortedFolders = folderNotes.keys.toList()
                          ..sort((a, b) {
                            final comparison = a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase());
                            return _ascendingSort ? comparison : -comparison;
                          });

                        Map<Folder, List<Note>> sortedFolderNotes = {};
                        for (var folder in sortedFolders) {
                          sortedFolderNotes[folder] = folderNotes[folder]!;
                        }

                        folderNotes = sortedFolderNotes;
                      });
                    },
                    padding: EdgeInsets.all(0),
                    icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color(0xFF3D7F67),
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          _ascendingSort ? Icons.sort : Icons.short_text,
                          color: Color(0xFFF0E9E0),
                        )))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: folderNotes.isEmpty
                    ? Center(
                        child: Text(
                          'Mulai membuat grup \nuntuk menambah daftar tugas \ndengan tombol + di bawah',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFf293942),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(top: 20),
                        itemCount: folderNotes.length,
                        itemBuilder: (context, index) {
                          var folder = folderNotes.keys.toList()[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            color: Color(0xFF3D7F67),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                trailing: IconButton(
                                    onPressed: () async {
                                      final result =
                                          await _deleteConfirmationFolder(
                                              context, folder);
                                      if (result != null && result) {
                                        deleteFolder(folder);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Color(0xFFF0E9E0),
                                    )),
                                title: RichText(
                                    // textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: '${folder.name}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF0E9E0),
                                        ))),
                                onTap: () {
                                  _onFolderSelected(folder);
                                },
                              ),
                            ),
                          );
                        },
                      )),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                String folderName = '';
                bool isTextFieldNotEmpty = false;

                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: TextField(
                        onChanged: (value) {
                          setState(() {
                            folderName = value;
                            isTextFieldNotEmpty = value.isNotEmpty;
                          });
                        },
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF293942),
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Tulis nama grup',
                          hintStyle: TextStyle(
                              color: Color(0xFF293942).withOpacity(0.5),
                              fontSize: 24),
                        ),
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFD63636),
                                padding: EdgeInsets.all(16)),
                            onPressed: () {
                              Navigator.pop(context, '');
                            },
                            child: SizedBox(
                              width: 60,
                              child: Text(
                                'Batal',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3D4C7F),
                                padding: EdgeInsets.all(16)),
                            onPressed: isTextFieldNotEmpty
                                ? () {
                                    _addNewFolder(folderName);
                                    Navigator.of(context).pop();
                                  }
                                : null,
                            child: SizedBox(
                              width: 60,
                              child: Text(
                                'Simpan',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ));
                });
              },
            );
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
