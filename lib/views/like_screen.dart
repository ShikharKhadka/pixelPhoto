import 'package:flutter/material.dart';
import 'package:project2/local_storage/local_storage.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Like Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: LocalStorage().getString(),
              builder: (context, snapShot) {
                if (snapShot.data == null || snapShot.data!.isEmpty) {
                  return const Text('Sorry No data Found');
                }
                if (snapShot.hasData) {
                  return Column(
                    children: snapShot.data!
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(e.name ?? ''),
                            ))
                        .toList(),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}