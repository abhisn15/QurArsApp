import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue,
      statusBarIconBrightness: Brightness.light,
    ));
  } else if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    requestPermissions(context);
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  //Permintaan Izin  Pengguna
  Future<void> requestPermissions(BuildContext context) async {
    if (Platform.isIOS) {
      PermissionStatus notificationPermission =
          await Permission.notification.request();

      if (notificationPermission.isGranted) {
        //
      } else if (notificationPermission.isDenied) {
        await _showPermissionDialog(context, 'Notification Permission');
      }
    }
    if (Platform.isAndroid) {
      // Request storage permission
      PermissionStatus storagePermission =
          await Permission.manageExternalStorage.request();
      PermissionStatus notificationPermission =
          await Permission.notification.request();

      if (storagePermission.isGranted && notificationPermission.isGranted) {
        print('Storage permission granted');
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        print('Manage external storage permission granted');
      } else if (await Permission.notification.request().isGranted) {
        print('Notification permission granted');
      } else {
        // Show modal dialog if permission is denied
        await _showPermissionDialog(
            context, 'Storage Permission, and Notification Permission');
      }
    }
  }

// Function to show permission dialog
  Future<void> _showPermissionDialog(
      BuildContext context, String permissionName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionName Required'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This app needs $permissionName to function properly.'),
                Text('Please grant $permissionName in your device settings.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                openAppSettings(); // Open app settings for user to enable permission
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> showDownloadNotification(
  //     String fileName, String progress) async {
  //   int progressValue = int.tryParse(progress) ?? 0; // Parsing progress

  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'download_channel',
  //     'Download',
  //     channelDescription: 'Download notification',
  //     importance: Importance.low,
  //     priority: Priority.low,
  //     showProgress: true,
  //     maxProgress: 100,
  //     progress: progressValue, // Use parsed value here
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Downloading $fileName',
  //     'Download in progress: $progress%',
  //     platformChannelSpecifics,
  //   );
  // }

  Future<void> showDownloadNotification(
      String fileName, int progressValue) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download',
      channelDescription: 'Download notification',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
            threadIdentifier: 'Download notification', presentSound: true);

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloading $fileName',
      'Download in progress: $progressValue%',
      platformChannelSpecifics,
      payload: 'progress_$progressValue',
    );
  }

  Future<void> showCompleteNotification(String fileName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Download',
      channelDescription: 'Download notification',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
            threadIdentifier: 'Download notification', presentSound: true);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      '$fileName has been downloaded successfully',
      platformChannelSpecifics,
    );
  }

  final List<Map<String, String>> _mediaUrls = [
    {
      'type': 'image',
      'url':
          'https://images.unsplash.com/photo-1550348579-959785e820f7?w=1200&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z29hdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'type': 'image',
      'url':
          'https://images.unsplash.com/photo-1550348579-959785e820f7?w=1200&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z29hdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'type': 'image',
      'url':
          'https://images.unsplash.com/photo-1550348579-959785e820f7?w=1200&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z29hdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'type': 'image',
      'url':
          'https://images.unsplash.com/photo-1550348579-959785e820f7?w=1200&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z29hdHxlbnwwfHwwfHx8MA%3D%3D'
    },
    {
      'type': 'video',
      'url':
          'https://videos.pexels.com/video-files/5512609/5512609-sd_360_640_25fps.mp4'
    },
    {
      'type': 'video',
      'url':
          'https://videos.pexels.com/video-files/4065222/4065222-sd_506_960_25fps.mp4'
    },
    // Add more media URLs
  ];

  Future<void> downloadFiles(List<Map<String, String>> mediaList) async {
    try {
      for (var media in mediaList) {
        final String url = media['url']!;
        final String type = media['type']!;

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final fileName = Uri.parse(url).pathSegments.last.split('?').first;
          final directory = await getApplicationDocumentsDirectory();
          // print('Downloading from: $url');
          final file = File('${directory.path}/$fileName');

          // Show download notification with initial progress
          await showDownloadNotification(fileName, 0);

          await file.writeAsBytes(response.bodyBytes);
          // print('Downloaded: $fileName');
          // print('Saving file to: ${file.path}');

          if (type == 'image') {
            // Save image to gallery
            await PhotoManager.editor
                .saveImageWithPath(file.path, title: 'qurban_arsip.jpg');
          } else if (type == 'video') {
            // Save video to gallery
            await _saveVideoToGallery(file.path);
          }

          // Show complete notification
          await showCompleteNotification(fileName);
        } else {
          print('Failed to download $url');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveVideoToGallery(String videoPath) async {
    try {
      final File videoFile = File(videoPath);

      // Ensure the file exists
      if (await videoFile.exists()) {
        // Save video to gallery using PhotoManager
        final AssetEntity? result = await PhotoManager.editor
            .saveVideo(videoFile, title: 'qurban_arsip.mp4');
      } else {
        print("Video file does not exist.");
      }
    } catch (e) {
      print("Error saving video: $e");
    }
  }

  Future<void> _refresh() async {
    // Add your refresh logic here, for example fetching new data from API
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    setState(() {
      // Update your mediaUrls or any state variable
    });
  }

  void _showThankYouNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thank-you Note"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "Assalamualaikum Wr Wb.\n"
                  "Yth. Alvaro Sekeluarga.\n\n"
                  "Alhamdulillah Pemotongan Hewan Qurban Tuan/Puan/Saudara-i Tahun 1445 H tepatnya di Pesantren Attaqwa Bekasi, Indonesia telah selesai di laksanakan.\n\n"
                  "Bagi Tuan/Puan/Saudara-i di Singapore dapat menyempurnakan Sunnah sebagaimana sabda Rasulullah SAW\n\n"
                  "“Jika kalian melihat hilal Dzulhijjah, dan diantara kalian ada yang ingin berqurban, maka hendaklah dia menahan (tidak memotong) sebagian rambutnya kukunya” (HR.Muslim)\n\n"
                  "Segala bentuk laporan akan kami kirimkan Hard File ke Singapore berupa :\n"
                  "💾 Surat Ucapan Terimakasih\n"
                  "📷 Foto Hewan Qurban\n"
                  "📝 Sertifikat Qurban\n\n"
                  "Kami ucapakan Terimakasih telah mempercayai kami pada tahun ini untuk membantu proses pemotongan Qurban Tuan/Puan/saudara-i. Besar harapan kami semoga tahun tahun yang akan datang masih mempercayakan amanah ini kepada kami.\n\n"
                  "Wassalamualaikum wr Wb.\n\n"
                  "Team S.G.Charity Jakarta.",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: Platform.isIOS ? 20 : 40),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            width: 50,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                child: Text(
                                  'Alvaro Sekeluarga',
                                  style: TextStyle(
                                      color: Color.fromRGBO(44, 180, 255, 1),
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 140,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () async {
                                await downloadFiles(_mediaUrls);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Download complete, your download save on galery')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                shadowColor: Colors.black38,
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(30),
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(10)),
                                ),
                              ),
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Download All',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 140,
                            height: 35,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shadowColor: Colors.black38,
                                elevation: 4,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(30),
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(10)),
                                ),
                              ),
                              child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 140,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: _showThankYouNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shadowColor: Colors.black38,
                        elevation: 4,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(30),
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(10)),
                        ),
                      ),
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Thank-you note',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: Platform.isIOS ? 20 : 20,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _mediaUrls.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MediaDetailScreen(mediaUrl: _mediaUrls[index]),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _mediaUrls[index]['type'] == 'image'
                            ? Image.network(
                                _mediaUrls[index]['url']!,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: VideoPlayerWidget(
                                      videoUrl: _mediaUrls[index]['url']!,
                                    ),
                                  ),
                                  const Icon(Icons.play_circle_outline,
                                      color: Colors.white, size: 50),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MediaDetailScreen extends StatelessWidget {
  final Map<String, String> mediaUrl;

  const MediaDetailScreen({Key? key, required this.mediaUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: mediaUrl['type'] == 'image'
                ? Image.network(mediaUrl['url']!)
                : VideoPlayerWidget(videoUrl: mediaUrl['url']!),
          ),
          Positioned(
            top: 40,
            left: 0,
            child: Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios_new : Icons.arrow_back,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }
}
