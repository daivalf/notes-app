class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;
  bool isCompleted;
  String folderName;
  DateTime selectedDate;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    required this.selectedDate,
    this.isCompleted = false,
    this.folderName = '',
  });
}


List<Note> sampleNotes = [
  // Note(
  //   id: 1,
  //   title: 'Recipes to Try',
  //   content:
  //       '1. Chicken Alfredo\n2. Vegan chili\n3. Spaghetti carbonara\n4. Chocolate lava cake',
  //   modifiedTime: DateTime(2022,1,1,34,5),
  //   isCompleted: false,
  // ),
  // Note(
  //   id: 2,
  //   title: 'Books to Read',
  //   content:
  //       '1. To Kill a Mockingbird\n2. 1984\n3. The Great Gatsby\n4. The Catcher in the Rye',
  //   modifiedTime: DateTime(2023,3,1,19,5),
  //   isCompleted: false,
  // ),
  // Note(
  //   id: 3,
  //   title: 'Gift Ideas',
  //   content: '1. Jewelry box\n2. Cookbook\n3. Scarf\n4. Spa day gift card',
  //   modifiedTime: DateTime(2023,1,4,16,53),
  //   isCompleted: false,
  // ),
  // Note(
  //   id: 4,
  //   title: 'Workout Plan',
  //   content:
  //       'Monday:\n- Run 5 miles\n- Yoga class\nTuesday:\n- HIIT circuit training\n- Swimming laps\nWednesday:\n- Rest day\nThursday:\n- Weightlifting\n- Spin class\nFriday:\n- Run 3 miles\n- Pilates class\nSaturday:\n- Hiking\n- Rock climbing',
  //   modifiedTime: DateTime(2023,5,1,11,6),
  //   isCompleted: false,
  // ),
  // Note(
  //   id: 5,
  //   title: 'Bucket List',
  //   content:
  //       '1. Travel to Japan\n2. Learn to play the guitar\n3. Write a novel\n4. Run a marathon\n5. Start a business',
  //   modifiedTime: DateTime(2023,1,6,13,9),
  //   isCompleted: false,
  // ),
  // Note(
  //   id: 7,
  //   title: 'Meeting Notes',
  //   content:
  //       'Attendees: John, Mary, David\nAgenda:\n- Budget review\n- Project updates\n- Upcoming events',
  //   modifiedTime: DateTime(2023,2,1,15,14),
  //   isCompleted: false,
  // ),
  // Note(
  //   id: 8,
  //   title: 'Ideas for Vacation',
  //   content:
  //       '1. Visit Grand Canyon\n2. Go on a hot air balloon ride\n3. Try local cuisine\n4. Attend a concert',
  //   modifiedTime: DateTime(2023,2,1,12,34),
  //   isCompleted: false,
  // ),
];
