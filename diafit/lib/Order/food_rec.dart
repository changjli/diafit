import 'package:flutter/material.dart';

class FoodRecommendPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 380,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2.0),
                        blurRadius: 10,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 28,
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Mon",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "images/weather-icon.png",
                                        ),
                                        fit: BoxFit.cover,
                                        opacity: 0.9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "13 Juni 2023",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(
                              "images/junkFood.jpg",
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.9,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "5 Times",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 50,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "images/next-icon.png",
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
