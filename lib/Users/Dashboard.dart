import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // For Android
      statusBarIconBrightness: Brightness.light,
    ));
  } else if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark, // For iOS
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

  Future<void> _refresh() async {
    // Add your refresh logic here, for example fetching new data from API
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    setState(() {
      // Update your mediaUrls or any state variable
    });
  }

  Future<void> _downloadAllMedia() async {
    final tempDir = await getTemporaryDirectory();

    for (var media in _mediaUrls) {
      final url = media['url']!;
      final response = await http.get(Uri.parse(url));
      final fileName = basename(url);
      final filePath = '${tempDir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      if (media['type'] == 'image') {
        await ImageGallerySaver.saveFile(file.path);
      } else if (media['type'] == 'video') {
        await ImageGallerySaver.saveFile(file.path);
      }
    }
  }

  void _showThankYouNote(BuildContext context) {
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
                  "Yth. Mohammad Marzuqi Bin Ismail.\n\n"
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
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xffffdabe),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: Platform.isIOS ? 60 : 40),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello, Muhammad',
                            style: TextStyle(
                                color: Color(0xff1f1f1f),
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          const Text(
                            'Monday, 24 July',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 25,
                              color: Color(0xfffe8550),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffffdabe),
                          Color(0xffffcb96),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                              width: 80,
                              height: 80,
                              alignment: Alignment.centerLeft,
                              repeat: ImageRepeat.repeat,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thank you, Muhammad',
                                style: TextStyle(
                                  color: Color(0xff1f1f1f),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Your sacrifice has been completed.',
                                style: TextStyle(
                                  color: Color(0xff1f1f1f),
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xfffe8550),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () => _showThankYouNote(context),
                                  child: const Text(
                                    'View Note',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Media',
                          style: TextStyle(
                            color: Color(0xff1f1f1f),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _mediaUrls.length,
                          itemBuilder: (context, index) {
                            final media = _mediaUrls[index];
                            final mediaType = media['type'];
                            final mediaUrl = media['url'];

                            return GestureDetector(
                              onTap: () {
                                // Handle media tap
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: mediaType == 'image'
                                    ? Image.network(
                                        mediaUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : VideoPlayerScreen(url: mediaUrl!),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xfffe8550),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: _downloadAllMedia,
                            child: const Text(
                              'Download All',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
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
            child: VideoPlayer(_controller),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
