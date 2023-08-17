import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';

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

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


bool isFormValid = false;
bool canProceed() {
  return _titleController.text.isNotEmpty && _dateController.text.isNotEmpty;
}

void initializeNotifications() async {
  // const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    },
  );
}

// void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     await Navigator.push(
//       context,
//       MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
//     );
// }

Future<void> scheduleReminderNotification(DateTime dateTime, String taskTitle) async {
  // const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //   'reminder_channel',
  //   'Reminder Channel',
  //   'Channel for reminder notifications',
  //   importance: Importance.high,
  //   priority: Priority.high,
  // );
  const String alarmDismissActionId = 'alarm_dismiss_action';

  AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your channel id', 
      'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        styleInformation: BigTextStyleInformation('Kegiatan anda pada catatan "$taskTitle" akan segera dimulai!',),
        ticker: 'ticker',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('raw/alarm'),
    );
        
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails
  );
  
  // await flutterLocalNotificationsPlugin.show(
  //   0, 'plain title', 'plain body', notificationDetails,
  //   payload: 'item x');

  // final now = DateTime.now();
  // final scheduledTime = dateTime.subtract(Duration(minutes: 30));
  final now = tz.TZDateTime.now(tz.local);
  final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

  print('Scheduled Time: $scheduledTime');
  print('Current Time: $now');

  if (scheduledTime.isAfter(now)) {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Pengingat!',
      'Kegiatan anda pada catatan "$taskTitle" akan segera dimulai!',
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}


void showFillFieldsDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: RichText(
                              textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Semua data belum terisi \n\n',
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF293942), 
                            height: 1.5
                            ),
                          children: [
                            TextSpan(
                              text: 'Silahkan isi judul dan pilih tanggal terlebih dahulu.\n',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF293942),
                                height: 1.5
                              ),
                            )
                          ]
                        )
                      ),
          content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3D4C7F),
                                  padding: EdgeInsets.all(16)),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                },
                                  child: SizedBox(
                                    width: 60,
                                    child: Text('Ok',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                              ],
                            ),
        );
      },
    );
  }

List<String> selectedFileNames = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        // attachments.add(result.files.single);
        selectedFileNames.add(result.files.single.name);
      });
    }
  }

  void _updateFormValidity() {
    setState(() {
      isFormValid = _titleController.text.isNotEmpty && _dateController.text.isNotEmpty;
    });
  }

@override
  void initState() {
    // TODO: implement initState
  if(widget.note != null) {
    _titleController = TextEditingController(text: widget.note!.title);
    _contentController = TextEditingController(text: widget.note!.content);
    _dateController = TextEditingController(text: DateFormat('EEEE, d MMMM yyyy, h:mm a', 'id_ID').format(widget.note!.selectedDate));
  }
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    initializeNotifications();
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
        actions: <Widget>[
          IconButton(onPressed: canProceed() 
          ? (){
            Navigator.pop(context, [
              _titleController.text,
              _contentController.text,
              _dateController.text,
            ]);
          }
          : () {
            showFillFieldsDialog();
          }, 
            icon: Icon(Icons.check, color: Color(0xFFF0E9E0),)
          ),
        ],
      ),
body: Padding(
  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
  child: Column(
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

                      _updateFormValidity();
                      // scheduleReminderNotification(pickedDateTime); // Schedule the reminder
                      scheduleReminderNotification(pickedDateTime.subtract(Duration(minutes: 30)), _titleController.text);
                      }
                    }
                  },
                ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('File Lampiran', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF293942)),),
          IconButton(
            onPressed: (){
              _pickFile();
            },
            padding: EdgeInsets.all(0),
            icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Color(0xFF3D7F67),
              borderRadius: BorderRadius.circular(30)),
            child: Icon(Icons.add, color: Color(0xFFF0E9E0),)))
        ],
      ),
      SizedBox(height: 20),
      Expanded(
        child: ListView.builder(
          itemCount: selectedFileNames.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Color(0xFF3D7F67), width: 2.0),
              ),
              child: ListTile(
                onTap: () {},
                title: Text(selectedFileNames[index]),
                titleTextStyle: TextStyle(color: Color(0xFF3D7F67), fontSize: 16),
                leading: Icon(Icons.article, color: Color(0xFF3D7F67),),
                trailing: IconButton(
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: RichText(
                              textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Hapus File?\n\n',
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF293942), 
                            height: 1.5
                            ),
                            children: [
                              TextSpan(
                                text: 'File tidak bisa dikembalikan lagi.\n',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF293942),
                                height: 1.5
                              ),
                              )
                            ]
                        ),
                      ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3D4C7F),
                                  padding: EdgeInsets.all(16)),
                                  onPressed: (){
                                    Navigator.pop(context);
                                },
                                  child: SizedBox(
                                    width: 60,
                                    child: Text('Batal',
                                    textAlign: TextAlign.center,),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD63636),
                                  padding: EdgeInsets.all(16)),
                                  onPressed: (){
                                    setState(() {
                                      selectedFileNames.removeAt(index);
                                      Navigator.pop(context);
                                    });
                                  },
                                    child: SizedBox(
                                      width: 60,
                                      child: Text('Hapus',
                                      textAlign: TextAlign.center,),
                                    ),
                                ),
                              ],
                            ),
                          );
                      });
                }, 
                icon: Icon(Icons.delete, color: Color(0xFF3D7F67),)),
              ),
            );
          },
        ),
      ),
    ],
  ),
),
      // floatingActionButton: Container(
      //   height: 80,
      //   width: 80,
      //   child: FloatingActionButton(onPressed: () {

      //   },
      //   elevation: 20,
      //   backgroundColor: Color(0xFF3D4C7F),
      //   child: Icon(
      //     Icons.save,
      //     size: 40,
      //     color: Color(0xFFF0E9E0),
      //     ),
      //   ),
      // ),
    );
  }
}