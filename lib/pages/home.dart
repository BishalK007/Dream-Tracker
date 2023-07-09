import 'package:dream_tracker/widgets/home_body.dart';
import 'package:flutter/material.dart';
import 'package:hidable/hidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      //____APP BAR And Body
      //
      body: NestedScrollView(
        controller: _controller,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            //
            //____APP BAR
            //
            const SliverAppBar(
              title: Text('Dream Tracker'),
            ),
          ];
        },
        //
        //____ Body
        //
        body: const HomeBody(),
      ),
      //
      //____Button
      //
      floatingActionButton: Hidable(
        controller: _controller,
        child: FloatingActionButton(onPressed: () {}),
      ),
    );
  }
}
