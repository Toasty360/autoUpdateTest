// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> checkForUpdates() async {
  const currentVersion = 'v1.0.0'; // Your app's current version

  // GitHub API request to get the latest release
  final response = await http.get(
      Uri.parse('https://api.github.com/repos/OWNER/REPO/releases/latest'));

  if (response.statusCode == 200) {
    final release = json.decode(response.body);
    final latestVersion = release['tag_name'];

    if (latestVersion != currentVersion) {
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
