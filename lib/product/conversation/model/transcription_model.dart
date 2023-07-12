class TranscriptionModel {
  String? status;
  String? transcriptionId;
  int? contentLength;
  int? wordCount;
  List<String>? content;
  String? voice;

  TranscriptionModel({
    this.status,
    this.transcriptionId,
    this.contentLength,
    this.wordCount,
    this.content,
    this.voice,
  });

  TranscriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    transcriptionId = json['transcriptionId'];
    contentLength = json['contentLength'];
    wordCount = json['wordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['transcriptionId'] = transcriptionId;
    data['contentLength'] = contentLength;
    data['wordCount'] = wordCount;
    data['content'] = content;
    data['voice'] = voice;
    return data;
  }
}
