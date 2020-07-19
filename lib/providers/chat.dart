class Chat {
  final String chatId;
  final String expertImage;
  final String expertName;
  final String estimate;
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

  Chat({
    this.chatId,
    this.expertImage,
    this.expertName,
    this.estimate,
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
