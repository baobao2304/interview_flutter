

class Story {
  int id;
  String? title;
  bool? liked;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDone: liked == true ? 1 : 0,
      columnId: id
    };



    return map;
  }

  Story({
    required this.id, this.title,this.liked
  });

  factory Story.fromMap(Map<dynamic, dynamic> map) {
    return Story( id: map[columnId],
        title: map[columnTitle],
        liked: map[columnDone] == 1 ? true:false  );
  }
}
final String tableStory = 'story';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDone = 'liked';