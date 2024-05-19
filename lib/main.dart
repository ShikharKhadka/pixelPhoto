import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project2/api/photos_api.dart';
import 'package:project2/extension/extension.dart';
import 'package:project2/local_storage/local_storage.dart';
import 'package:project2/models/like_model.dart';
import 'package:project2/models/photos_model.dart';
import 'package:project2/providers/providers.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  @override
  void initState() {
    getPhotos();
    super.initState();
  }

  Future<List<Photo>> getPhotos() async {
    final data = await PhotoApi().getPhotos();
    print(data);
    return data;
  }

  Widget getPages() {
    switch (currentIndex) {
      case 1:
        return ProfileScreen();
      case 2:
        return LikeScreen();

      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPages(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Photos'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Like')
          ]),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Photos'),
        ),
        body: Column(
          children: [
            ref.watch(photoProvider).when(
                data: (data) {
                  return Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                Future.delayed(Duration(seconds: 1));
                                ref
                                    .watch(photoProvider.notifier)
                                    .searchPhotos(name: _controller.text);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (data.isEmpty)
                          Text('Sorry Could Not Fetch')
                        else
                          Expanded(
                            child: GridView.builder(
                                itemCount: 10,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // number of items in each row
                                  mainAxisSpacing: 8.0, // spacing between rows
                                  crossAxisSpacing:
                                      8.0, // spacing between columns
                                ),
                                itemBuilder: (context, index) {
                                  final photo = data[index].src!.original;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ImageDetail(
                                                    imageUrl: photo ?? '',
                                                  )));
                                    },
                                    child: Image.network(
                                      photo ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                          ),
                      ],
                    ),
                  );
                },
                error: (e, s) {
                  return Text('data');
                },
                loading: () => const CircularProgressIndicator.adaptive())
          ],
        ));
  }
}

class ImageDetail extends StatelessWidget {
  const ImageDetail({required this.imageUrl, super.key});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imageUrl),
            ElevatedButton(
                onPressed: () {
                  LocalStorage().setString(LikeModel(
                    id: 1,
                    name: imageUrl,
                  ));
                },
                child: const Text('Like')),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Set As Wallpaper'),
            ),
          ],
        ),
      ),
    );
  }
}

class LikeScreen extends StatelessWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Like Screen'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: LocalStorage().getString(),
            builder: (context, snapShot) {
              if (snapShot.data == null || snapShot.data!.isEmpty) {
                return Text('Sorry No data Found');
              }
              if (snapShot.hasData) {
                print(snapShot.data?.length);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: snapShot.data!
                        .map((e) => Image.network(e.name ?? ''))
                        .toList(),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    checkIsBirthday();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void checkIsBirthday() {
    _controller.addListener(() {
      if (_controller.text.isNotEmpty &&
          _controller.text == DateTime.now().time) {
        Fluttertoast.showToast(
            msg: "Happy Birthday",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now());
                  if (date != null) {
                    _controller.text = date.time;
                  }
                },
              )),
            ),
          ),
        ],
      ),
    );
  }
}
