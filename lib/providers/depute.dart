class Depute {
  final String chatId;
  final String expertImage;
  final String expertName;
  final String noticeTitle;
  final String noticeId;
  final String expertPhone;
  final String principalPhone;
  final String createdAt;
  final bool expertRead;
  final String principalImage;
  final String principalName;
  final bool principalRead;
  int process;
  final String estimate;
  final String meet;
  final String attentions;
  final String lat;
  final String lng;
  final variety;
  final String description;
  final List<dynamic> files;
  final String place;

  Depute({
    this.lat,
    this.lng,
    this.variety,
    this.description,
    this.files,
    this.place,
    this.estimate,
    this.meet,
    this.attentions,
    this.chatId,
    this.expertImage,
    this.expertName,
    this.noticeTitle,
    this.noticeId,
    this.expertPhone,
    this.principalPhone,
    this.createdAt,
    this.expertRead,
    this.principalImage,
    this.principalName,
    this.principalRead,
    this.process,
  });
}
