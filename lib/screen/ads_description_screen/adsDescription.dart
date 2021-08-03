import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:nerding_admin_web/screen/approved_ads_screen/approved_ads.dart';
import 'package:nerding_admin_web/screen/home_screen/home_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class AdsDescription extends StatefulWidget {
  final String title;
  final String itemColor;
  final String userNumber;
  final String address;
  final String description;
  final List<dynamic> urlImage;

  const AdsDescription({
    required this.title,
    required this.itemColor,
    required this.userNumber,
    required this.description,
    required this.address,
    required this.urlImage,
  });
  @override
  _AdsDescriptionState createState() => _AdsDescriptionState();
}

class _AdsDescriptionState extends State<AdsDescription> {
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ApproveAdsScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: _screenWidth * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 8,
                    right: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          widget.address,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(12),
                  child: CarouselSlider(
                    items: widget.urlImage
                        .map((image) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: image,
                                height: 220,
                                width: _screenWidth,
                                fit: BoxFit.cover,
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.brush_outlined,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(widget.itemColor),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(widget.userNumber),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
