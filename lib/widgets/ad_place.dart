import 'package:dream_tracker/backend.dart';
import 'package:dream_tracker/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AdPlace extends StatefulWidget {
  const AdPlace({super.key, required this.goalAmt, required this.title});
  final String title;
  final int goalAmt;

  @override
  State<AdPlace> createState() => _AdPlaceState();
}

class _AdPlaceState extends State<AdPlace> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 350,
        // color: Colors.amber,
        child: FutureBuilder(
          future: fetchAdPlaceItems(widget.title, widget.goalAmt),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Something Went Wrong..'),
              );
            } else {
              double screenWidth = MediaQuery.of(context).size.width;
              // print(snapshot.data!);
              //
              //______Ad Place Slider___
              //
              return CarouselSlider.builder(
                // key: _sliderKey,
                unlimitedMode: true,
                slideBuilder: (index) {
                  //
                  //_____ Ad place Item ______//
                  //
                  return InkWell(
                    onTap: () async {
                      await launchUrl(
                          Uri.parse(snapshot.data![index]['Product Url']));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 200,
                              width: (screenWidth - 70) / 2,
                              // color: Colors.red,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: myPrimarySwatch,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    snapshot.data![index]['Image Link'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 200,
                              width: (screenWidth - 70) / 2,
                              // color: Colors.blue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  //_______ Title Text ________//
                                  //
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      "Title: " +
                                          snapshot.data![index]['Title'],
                                      // 'Title : $text',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  //
                                  //_______ Price Text ________//
                                  //
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Text(
                                      // ignore: prefer_interpolation_to_compose_strings
                                      'Price : ' +
                                          snapshot.data![index]['Price']
                                              .toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  //
                                  //___ Visit Button __
                                  //
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await launchUrl(Uri.parse(snapshot
                                          .data![index]['Product Url']));
                                    },
                                    icon: const Icon(FontAwesomeIcons.globe),
                                    label: const Text('Visit'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //
                        //_______ Deccription text _____//
                        //
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            "Description-",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Text(
                            snapshot.data![index]['Description'],
                            style: TextStyle(fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                // slideTransform: const CubeTransform(),
                slideIndicator: CircularSlideIndicator(
                    padding: const EdgeInsets.only(bottom: 32),
                    currentIndicatorColor: myPrimarySwatch,
                    indicatorBackgroundColor:
                        Color.fromARGB(255, 221, 189, 255)),
                itemCount: snapshot.data!.length,
              );
            }
          },
        ),
      ),
    );
  }
}

class AdRender extends StatefulWidget {
  const AdRender({super.key});

  @override
  State<AdRender> createState() => _AdRenderState();
}

class _AdRenderState extends State<AdRender> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
