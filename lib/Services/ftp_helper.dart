import 'dart:io';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

class FTPHelper {
  Future downloadFile() async {
    String fileName = 'PROJECT.XML';
    FTPConnect ftpConnect =
        FTPConnect('192.168.0.200', user: 'admin', pass: 'admin');

    await Permission.storage.request().isGranted;

    // final result = await FilePicker.platform.pickFiles();

    // try {
    //   await ftpConnect.connect();
    //   bool folderChanged = await ftpConnect.changeDirectory('/WWW');
    //   bool folderExist = await ftpConnect.checkFolderExistence('/USERS');
    //   bool fileExist = await ftpConnect.existFile(fileName);
    //   // await ftpConnect.downloadFile(fileName, File(fileName));
    //   print('Directory changed: $folderChanged');
    //   print('Folder exist: $folderExist');
    //   print('File Exist: $fileExist');
    // } catch (e) {
    //   print(e);
    // }

    // ftpConnect.disconnect();
  }
}
