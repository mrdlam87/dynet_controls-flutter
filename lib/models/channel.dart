class Channel {
  Channel(
      {required this.channelNumber,
      required this.channelName,
      this.currentChannelLevel = 0});

  int channelNumber;
  double currentChannelLevel;
  String channelName;

  void setCurrentChannelLevel(double channelLevel) {
    currentChannelLevel = channelLevel;
  }
}
