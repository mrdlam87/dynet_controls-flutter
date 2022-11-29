import 'package:dynet_controls_v2/Services/networking.dart';

class Dynet {
  Dynet(this.ipAddress);

  final String ipAddress;

  Future<String> _sendDynet(String url) async {
    NetworkHelper networkHelper = NetworkHelper();

    final response = await networkHelper.getHttp(url: url);

    return response;
  }

  Future setPreset({required int area, required int preset}) async {
    String url = 'http://$ipAddress/SetDyNet.cgi?a=$area&p=$preset&f=2000';

    await _sendDynet(url);
  }

  Future setChannelLevel(
      {required int area, required int channel, required int level}) async {
    String url =
        'http://$ipAddress/SetDyNet.cgi?a=$area&c=$channel&l=$level&f=200';

    await _sendDynet(url);
  }

  Future<String> requestCurrentPreset({required int area}) async {
    String url = 'http://$ipAddress/GetDyNet.cgi?a=$area';

    String data = await _sendDynet(url);

    data = data.replaceAll('p=', '');

    return data;
  }

  Future<String> requestCurrentChannelLevel(
      {required int area, required int channelNumber}) async {
    String url =
        'http://$ipAddress/GetDyNet.cgi?a=$area&c=$channelNumber&j=255';
        
    String data = await _sendDynet(url);

    data = data.replaceAll('l=', '');

    return data;
  }
}
