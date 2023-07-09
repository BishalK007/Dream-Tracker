import 'package:dream_tracker/backend.dart';
import 'package:dream_tracker/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String text =
    'ifjiwejfisemfejfmsfijmifshfmusdmfsyfsiusu08ufsd9asid9is0d9ifsdmyguds9v0uas09usauyd8ushfhashjasgjgasgasgdgasdgasdgasdjgasgastdgasygyjasgyasgyasgcyasgcjysgcyasg';

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
      child: Container(
        height: 350,
        // color: Colors.amber,
        child: FutureBuilder(
          future: fetchAdPlaceItems(widget.title, widget.goalAmt),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text('Something Went Wrong..'),
              );
            } else {
              double screenWidth = MediaQuery.of(context).size.width;
              print(snapshot.data!);
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
                  return Column(
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
                                  'https://stimg.cardekho.com/images/carexteriorimages/630x420/Kia/Sonet/8427/Kia-Sonet-HTX-DCT/1678435390655/front-left-side-47.jpg?tr=w-456',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Title : $text',
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Price : $text',
                                    style: TextStyle(
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
                                  onPressed: () {},
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
                          text,
                          style: TextStyle(fontSize: 16),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
                // slideTransform: const CubeTransform(),
                slideIndicator: CircularSlideIndicator(
                    padding: const EdgeInsets.only(bottom: 32),
                    currentIndicatorColor: myPrimarySwatch,
                    indicatorBackgroundColor:
                        Color.fromARGB(255, 221, 189, 255)),
                itemCount: 3,
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
