import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../HomePage/HomePage.dart';
import '../RepeatedFunction/TrailerUI.dart';
import '../RepeatedFunction/customReviewUI.dart';
import '../RepeatedFunction/repttext.dart';
import 'package:flick_picks/apikey/apiKey.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../RepeatedFunction/reviewui.dart';
import '../RepeatedFunction/slider.dart';
import '../services/authservice.dart';
import '../services/favservice.dart';
import '../services/reviewservice.dart';

class TvSeriesDetails extends StatefulWidget {
  var id;
  TvSeriesDetails({this.id});

  @override
  State<TvSeriesDetails> createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
  var tvseriesdetaildata;
  List<Map<String, dynamic>> TvSeriesDetails = [];
  List<Map<String, dynamic>> TvSeriesREview = [];
  List<Map<String, dynamic>> similarserieslist = [];
  List<Map<String, dynamic>> recommendserieslist = [];
  List<Map<String, dynamic>> seriestrailerslist = [];
  double averageRating = 0.0;
  List<Map<String, dynamic>> reviews = [];
  FavService _favService = FavService();

  ReviewService service = ReviewService();
  AuthService _authService = AuthService();
  final storage = const FlutterSecureStorage();

  showError(BuildContext context, String content, String title) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Explicitly specify the type here
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _saveAsFavorite() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add to Favorites"),
          content: Text("Do you want to add this movie to your favorites?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Map<String, String> allValues = await storage.readAll();
                String? userid = allValues["userid"];

                var fav = jsonEncode({
                  "typeId": widget.id.toString(),
                  "userId": userid,
                  "type" : "tv"
                });

                print("movie Data---------$TvSeriesDetails");
                var movieData = jsonEncode({
                  "dataId": widget.id.toString(),
                  "type_data": "tv",
                  "poster_path": TvSeriesDetails[0]["poster_path"],
                  "name": TvSeriesDetails[0]["title"],
                  "vote_average": TvSeriesDetails[0]['vote_average'],
                  "date": TvSeriesDetails[0]['releasedate'],
                });
                try {
                  final Response res = await _favService.saveFav(fav,movieData);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tv Show added to favorites"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } on DioException catch (e) {
                  if (e.response != null) {
                    print(e.response!.data);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Tv Show already added"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Tv Show Failed to add to favorites"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text("Add to Favorites"),
            ),
          ],
        );
      },
    );
  }


  void _writeReview() {
    double userRating = 0; // Initialize the user rating
    TextEditingController userReviewController = TextEditingController();


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Write a Review"),
          content: Column(
            children: [
              TextField(
                controller: userReviewController, // Use the TextEditingController
                decoration: InputDecoration(
                  hintText: "Enter your review here",
                ),
                maxLines: 5,
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.yellow, // Set the color to yellow
                ),
                onRatingUpdate: (rating) {
                  userRating = rating;
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Implement functionality to save the review and rating
                Map<String, String> allValues = await storage.readAll();
                String? userid = allValues["userid"];
                final Response res = await _authService.getUser(userid!);
                // Access the "name" field
                String name = res.data["email"];
                print("UserData: $name");
                print("Review: ${userReviewController.text}");
                print("Rating: $userRating");
                print("Movie ID: ${widget.id.toString()}");
                var review = jsonEncode({
                  "movieId": widget.id.toString(),
                  "userId": userid,
                  "rating": "$userRating",
                  "review":"${userReviewController.text}",
                  "username": name,
                });
                try {
                  final response = await service.saveReview(review);
                  showError(context,"Review save completed", "Reviewed Successful");
                  Navigator.of(context).pop();
                } on DioException catch (e) {
                  if (e.response != null) {
                    print(e.response!.data);

                    showError(context, "failed", "Review Failed to save");
                  } else {
                    // Something happened in setting up or sending the request that triggered an Error
                    showError(context, "Error occured,please try againlater", "Oops");
                  }
                }


                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Save"),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
    );
  }

  Future<void> tvseriesdetailfunc() async {
    var tvseriesdetailurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '?api_key=$apiKey';
    var tvseriesreviewurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/reviews?api_key=$apiKey';
    var similarseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/similar?api_key=$apiKey';
    var recommendseriesurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/recommendations?api_key=$apiKey';
    var seriestrailersurl = 'https://api.themoviedb.org/3/tv/' +
        widget.id.toString() +
        '/videos?api_key=$apiKey';
    // 'https://api.themoviedb.org/3/tv/' +
    //     widget.id.toString() +
    //     '/videos?api_key=$apikey';



    var tvseriesdetailresponse = await http.get(Uri.parse(tvseriesdetailurl));
    if (tvseriesdetailresponse.statusCode == 200) {
      tvseriesdetaildata = jsonDecode(tvseriesdetailresponse.body);

      //

       int tv_id = tvseriesdetaildata['id'];
       try {
         var response = await service.getReview(tv_id);
         //
          Map<String, dynamic> responseData = response;
          print(responseData);
          averageRating = responseData['averageRating'].toDouble();
          String formattedRating = averageRating.toStringAsFixed(2);
          print('Average Rating: $formattedRating');
          reviews = List<Map<String, dynamic>>.from(responseData['reviews']);
         print(reviews);
       }on DioException catch (e) {
         averageRating =0.0;
         print("error:$e");
       }

      for (var i = 0; i < 1; i++) {
        TvSeriesDetails.add({
          'backdrop_path': tvseriesdetaildata['backdrop_path'],
          'title': tvseriesdetaildata['original_name'],
          'vote_average': tvseriesdetaildata['vote_average'],
          'overview': tvseriesdetaildata['overview'],
          'status': tvseriesdetaildata['status'],
          'date': tvseriesdetaildata['date'],
          "poster_path": tvseriesdetaildata['poster_path'],

          'releasedate': tvseriesdetaildata['first_air_date'],
          'flickRating' : averageRating,
          'flickReview' : reviews,
        });
      }
      for (var i = 0; i < tvseriesdetaildata['genres'].length; i++) {
        TvSeriesDetails.add({
          'genre': tvseriesdetaildata['genres'][i]['name'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['created_by'].length; i++) {
        TvSeriesDetails.add({
          'creator': tvseriesdetaildata['created_by'][i]['name'],
          'creatorprofile': tvseriesdetaildata['created_by'][i]['profile_path'],
        });
      }
      for (var i = 0; i < tvseriesdetaildata['seasons'].length; i++) {
        TvSeriesDetails.add({
          'season': tvseriesdetaildata['seasons'][i]['name'],
          'episode_count': tvseriesdetaildata['seasons'][i]['episode_count'],
        });
      }
    } else {}
    ///////////////////////////////////////////tvseries review///////////////////////////////////////////

    var tvseriesreviewresponse = await http.get(Uri.parse(tvseriesreviewurl));
    if (tvseriesreviewresponse.statusCode == 200) {
      var tvseriesreviewdata = jsonDecode(tvseriesreviewresponse.body);
      for (var i = 0; i < tvseriesreviewdata['results'].length; i++) {
        TvSeriesREview.add({
          'name': tvseriesreviewdata['results'][i]['author'],
          'review': tvseriesreviewdata['results'][i]['content'],
          "rating": tvseriesreviewdata['results'][i]['author_details']
          ['rating'] ==
              null
              ? "Not Rated"
              : tvseriesreviewdata['results'][i]['author_details']['rating']
              .toString(),
          "avatarphoto": tvseriesreviewdata['results'][i]['author_details']
          ['avatar_path'] ==
              null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
              tvseriesreviewdata['results'][i]['author_details']
              ['avatar_path'],
          "creationdate":
          tvseriesreviewdata['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": tvseriesreviewdata['results'][i]['url'],
        });
      }
    } else {}
    ///////////////////////////////////////////similar series

    var similarseriesresponse = await http.get(Uri.parse(similarseriesurl));
    if (similarseriesresponse.statusCode == 200) {
      var similarseriesdata = jsonDecode(similarseriesresponse.body);
      for (var i = 0; i < similarseriesdata['results'].length; i++) {
        similarserieslist.add({
          'poster_path': similarseriesdata['results'][i]['poster_path'],
          'name': similarseriesdata['results'][i]['original_name'],
          'vote_average': similarseriesdata['results'][i]['vote_average'],
          'id': similarseriesdata['results'][i]['id'],
          'Date': similarseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}
    ///////////////////////////////////////////recommend series

    var recommendseriesresponse = await http.get(Uri.parse(recommendseriesurl));
    if (recommendseriesresponse.statusCode == 200) {
      var recommendseriesdata = jsonDecode(recommendseriesresponse.body);
      for (var i = 0; i < recommendseriesdata['results'].length; i++) {
        recommendserieslist.add({
          'poster_path': recommendseriesdata['results'][i]['poster_path'],
          'name': recommendseriesdata['results'][i]['original_name'],
          'vote_average': recommendseriesdata['results'][i]['vote_average'],
          'id': recommendseriesdata['results'][i]['id'],
          'Date': recommendseriesdata['results'][i]['first_air_date'],
        });
      }
    } else {}

    ///////////////////////////////////////////tvseries trailer///////////////////////////////////////////
    var tvseriestrailerresponse = await http.get(Uri.parse(seriestrailersurl));
    if (tvseriestrailerresponse.statusCode == 200) {
      var tvseriestrailerdata = jsonDecode(tvseriestrailerresponse.body);
      // print(tvseriestrailerdata);
      for (var i = 0; i < tvseriestrailerdata['results'].length; i++) {
        //add only if type is trailer
        if (tvseriestrailerdata['results'][i]['type'] == "Trailer") {
          seriestrailerslist.add({
            'key': tvseriestrailerdata['results'][i]['key'],
          });
        }
      }
      seriestrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    print(seriestrailerslist);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
          future: tvseriesdetailfunc(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        leading:
                        //circular icon button
                        IconButton(
                            onPressed: () {
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: [SystemUiOverlay.bottom]);
                              // SystemChrome.setEnabledSystemUIMode(
                              //     SystemUiMode.manual,
                              //     overlays: []);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                              Navigator.pop(context);
                            },
                            icon: Icon(FontAwesomeIcons.circleArrowLeft),
                            iconSize: 28,
                            color: Colors.white),
                        actions: [
                          IconButton(
                              onPressed: () {
                                //kill all previous routes and go to home page
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                        (route) => false);
                              },
                              icon: Icon(FontAwesomeIcons.houseUser),
                              iconSize: 25,
                              color: Colors.white)
                        ],
                        backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                        expandedHeight:
                        MediaQuery.of(context).size.height * 0.35,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: FittedBox(
                            fit: BoxFit.fill,
                            child: trailerwatch(
                              trailerytid: seriestrailerslist[0]['key'],
                            ),
                          ),
                        )),
                    SliverList(
                        delegate: SliverChildListDelegate([

                          Row(children: [
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: tvseriesdetaildata['genres']!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(25, 25, 25, 1),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: genrestext(
                                              TvSeriesDetails[index + 1]['genre']
                                                  .toString()));
                                    }))
                          ]),
                          Container(
                              padding: EdgeInsets.only(left: 10, top: 12),
                              child: tittletext("Series Overview : ")),

                          Container(
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: overviewtext(
                                  TvSeriesDetails[0]['overview'].toString())),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
                            child: ReviewUI(revdeatils: TvSeriesREview),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: boldtext("Status : " +
                                  TvSeriesDetails[0]['status'].toString())),
                          //created by

                          Container(
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: normaltext("Total Seasons : " +
                                  tvseriesdetaildata['seasons'].length.toString())),

                          //airdate
                          Container(
                              padding: EdgeInsets.only(left: 10, top: 20),
                              child: normaltext("Release date : " +
                                  TvSeriesDetails[0]['releasedate'].toString())),


                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            child: Row(
                              children: [
                                Text('Flick pick rating : ${TvSeriesDetails[0]['flickRating']}'),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 20, top: 10),
                            child: CustomReviewUI(revDetails: TvSeriesDetails[0]['flickReview']),
                          ),
                          sliderlist(similarserieslist, 'Similar Series', 'tv',
                              similarserieslist.length),
                          sliderlist(recommendserieslist, 'Recommended Series',
                              'tv', recommendserieslist.length),
                          Container(
                          )
                        ]))
                  ]);
            } else {
              return Center(
                  child:
                  CircularProgressIndicator(color: Colors.amber.shade400));
            }
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _writeReview, // Call the function to open the review popup
            child: Icon(Icons.rate_review),
            backgroundColor: Colors.amber,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _saveAsFavorite, // Call the function to save as a favorite
            child: Icon(Icons.favorite),
            backgroundColor: Colors.amber,
          ),
        ],
      ),
    );
  }
}