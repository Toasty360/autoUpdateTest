// ignore_for_file: avoid_print

import 'dart:io';
import 'package:auto_update_test/main.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkForUpdates() async {
  // Request necessary permissions before proceeding
  final isAllowed = await requestPermissions();
  if (isAllowed) {
    // GitHub API request to get the latest release
    final response = await Dio().get(
        'https://api.github.com/repos/Toasty360/autoUpdateTest/releases/latest',
        options: Options(
          validateStatus: (status) => true,
        ));

    if (response.statusCode == 200) {
      final release = response.data;
      final latestVersion = release['tag_name'];

      if (latestVersion != version) {
        // Update is available, notify the user and download the update
        final downloadUrl = release['assets'][0]['browser_download_url'];
        print('New version available: $latestVersion');
        print('Downloading update from: $downloadUrl');

        // Call the function to download and install the APK
        await downloadAndInstallApk(downloadUrl);
      } else {
        print('App is up-to-date');
      }
    } else {
      print('Failed to check for updates');
    }
  } else {
    print("Access denied");
  }
}

Future<void> downloadAndInstallApk(String downloadUrl) async {
  // Step 1: Get a directory to store the downloaded APK
  Directory? directory = await getExternalStorageDirectory();
  String filePath = '${directory?.path}/app-update.apk';

  // Step 2: Download the APK file
  try {
    print('Downloading APK...');
    final response = await http.get(Uri.parse(downloadUrl));

    if (response.statusCode == 200) {
      // Write the APK file to the specified path
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('APK downloaded to $filePath');

      // Step 3: Launch the APK installer
      await OpenFile.open(
          filePath); // This opens the APK file to start the installation
      print('Launching APK installer...');
    } else {
      print('Failed to download APK. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error downloading APK: $e');
  }
}

// Function to request permissions
Future<bool> requestPermissions() async {
  // Request permission to write to external storage
  PermissionStatus storageStatus = await Permission.storage.request();

  // Check if permission is granted
  if (storageStatus.isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
  }

  // Request permission to install APKs from unknown sources
  PermissionStatus installStatus =
      await Permission.requestInstallPackages.request();

  if (installStatus.isGranted) {
    print("Install permission granted");
    return true;
  }
  print("Install permission denied");

  return false;
}
