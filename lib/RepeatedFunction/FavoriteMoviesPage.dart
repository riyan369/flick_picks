
import 'package:flick_picks/RepeatedFunction/slider.dart';
import 'package:flick_picks/services/favservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../HomePage/HomePage.dart';


class FavoriteMoviesPage extends StatelessWidget {
  List<Map<String,dynamic>> MovieDetails =[];
  List<Map<String, dynamic>> UserREviews = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> similartvlist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List<Map<String, dynamic>> movietrailerslist = [];
  List MoviesGeneres = [];
  final storage = const FlutterSecureStorage();



  FavService service = FavService();


  Future Moviedetails() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];


    try {
      var response = await service.getFav(userid!);
      print("Response: $response");

      if (response.containsKey("movies")) {
        print("working");
        for (final movie in response["movies"]) {
          print("working 2");

          // Convert the date string to DateTime object
          DateTime date = DateTime.parse(movie['date']);

          // Format the DateTime object as a string without the time
          String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
          print('Dataaaaaaa$movie');
          // Add a new map to the list for each movie
          if (movie['type_data'] == 'movie') {
            similarmovieslist.add({
              "poster_path": movie['poster_path'],
              "name": movie['name'],
              "vote_average": movie['vote_average'],
              "Date": formattedDate,
              "id": movie['dataId'],
            });
          } else if (movie['type_data'] == 'tv') {
            similartvlist.add({
              "poster_path": movie['poster_path'],
              "name": movie['name'],
              "vote_average": movie['vote_average'],
              "Date": formattedDate,
              "id": movie['dataId'],
            });
          }
        }
      } else {
        print("No movies key found in the response");
      }
      print('Data----------------: $similarmovieslist');

    } on DioException catch (e) {
      print("error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Moviedetails(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(FontAwesomeIcons.circleArrowLeft),
                    iconSize: 28,
                    color: Colors.white,
                  ),
                  actions: [
                    IconButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
                      },
                      icon: Icon(FontAwesomeIcons.houseUser),
                      iconSize: 25,
                      color: Colors.white,
                    ),
                  ],


                ),
                SliverList(
                    delegate: SliverChildListDelegate([

                      sliderlist(similarmovieslist, 'Favorite Movies', 'movie', similarmovieslist.length),

                    ])),


                SliverList(
                    delegate: SliverChildListDelegate([

                      sliderlist(similartvlist, 'Favorite TV Shows', 'tv', similartvlist.length),

                    ]))
              ],
            );

          }
          else
          {
            return Center(child: CircularProgressIndicator(
              color: Colors.amber,
            ),);
          }
        },
      ),
    );
  }
}
