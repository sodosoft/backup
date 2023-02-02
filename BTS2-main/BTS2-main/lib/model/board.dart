class BoardData{
  String title;
  String content;
  String date;

  BoardData(this.title, this.content, this.date);

  factory BoardData.fromJson(Map<String, dynamic> json) => BoardData(
    json['title'],
    json['content'],
    json['date'],
  );

  Map<String, dynamic> toJson() => {
    'title' : title,
    'content' : content,
    'date' : date
  };
}