import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
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
                    ],
                  ),
                  const SizedBox(
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
                          width: 140,
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
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              shadowColor: Colors.black,
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
                              shadowColor: Colors.black,
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
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 140,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shadowColor: Colors.black,
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
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                return Center(
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
                                Icon(Icons.play_circle_outline,
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
    );
  }
}

class MediaDetailScreen extends StatelessWidget {
  final Map<String, String> mediaUrl;

  const MediaDetailScreen({Key? key, required this.mediaUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Detail'),
      ),
      body: Center(
        child: mediaUrl['type'] == 'image'
            ? Image.network(mediaUrl['url']!)
            : VideoPlayerWidget(videoUrl: mediaUrl['url']!),
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
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
