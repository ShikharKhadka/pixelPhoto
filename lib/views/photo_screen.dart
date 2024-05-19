import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project2/main.dart';
import 'package:project2/providers/providers.dart';

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
          title: const Text('Photos'),
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
                                Future.delayed(const Duration(seconds: 1));
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
                          const Text('Sorry Could Not Fetch')
                        else
                          Expanded(
                            child: GridView.builder(
                                itemCount: 10,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                  return const Text('data');
                },
                loading: () => const CircularProgressIndicator.adaptive())
          ],
        ));
  }
}
