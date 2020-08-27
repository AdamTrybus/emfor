class Chat {
  final String chatId;
  final String expertImage;
  final String expertName;
  final String noticeTitle;
  final String noticeId;
  final String expertUid;
  final String principalUid;
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
    this.noticeTitle,
    this.noticeId,
    this.expertUid,
    this.principalUid,
    this.createdAt,
    this.expertRead,
    this.principalImage,
    this.principalName,
    this.principalRead,
    this.process,
  });
}
