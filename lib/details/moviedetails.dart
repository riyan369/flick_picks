import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flick_picks/HomePage/HomePage.dart';
import 'package:flick_picks/RepeatedFunction/slider.dart';
import 'package:flick_picks/apikey/apiKey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;


import '../RepeatedFunction/reviewui.dart';
import '../RepeatedFunction/trailerui.dart';
import '../services/reviewservice.dart';




class MovieDetail extends StatefulWidget {
  var id;

  MovieDetail(this.id);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  List<Map<String,dynamic>> MovieDetails =[];
  List<Map<String, dynamic>> UserREviews = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List<Map<String, dynamic>> movietrailerslist = [];
  ReviewService service = ReviewService();
  late String Rating;
  late String Review;


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
              onPressed: () {
                // Implement functionality to save the movie as a favorite
                // You can use the movie details or ID to identify the movie and save it as a favorite
                // Add your logic here...

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Movie added to favorites"),
                    duration: Duration(seconds: 2),
                  ),
                );

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Add to Favorites"),
            ),
          ],
        );
      },
    );
  }


  List MoviesGeneres = [];
  Future Moviedetails() async {
    var moviedetailurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '?api_key=$apiKey';
    var UserReviewurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/reviews?api_key=$apiKey';
    var similarmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/similar?api_key=$apiKey';
    var recommendedmoviesurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/recommendations?api_key=$apiKey';
    var movietrailersurl = 'https://api.themoviedb.org/3/movie/' +
        widget.id.toString() +
        '/videos?api_key=$apiKey';

   // var moviedetailresponse = await http.get(Uri.parse(moviedetailurl));
    var moviedetailresponse = await rootBundle.loadString('assets/responses/details_1096197.json');

    // if (moviedetailresponse.statusCode == 200) {
    //   var moviedetailjson = jsonDecode(moviedetailresponse.body);
    var moviedetailjson = jsonDecode(moviedetailresponse);
      for (var i = 0; i < 1; i++) {
      // final responseData = await service.getReview(moviedetailjson['id']);
        Map<String, dynamic> response = {
          'rating': 10,
          'review': 'text',
        };
        MovieDetails.add({
          "backdrop_path": moviedetailjson['backdrop_path'],
          "title": moviedetailjson['title'],
          "vote_average": moviedetailjson['vote_average'],
          "overview": moviedetailjson['overview'],
          "release_date": moviedetailjson['release_date'],
          "runtime": moviedetailjson['runtime'],
          "budget": moviedetailjson['budget'],
          "revenue": moviedetailjson['revenue'],
          "id": moviedetailjson['id'],
          'flickRating' : response['rating'],
          'flickReview' : response['review'],
        });

      }
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGeneres.add(moviedetailjson['genres'][i]['name']);
      }
    // } else {}

    /////////////////////////////User Reviews///////////////////////////////
   // var UserReviewresponse = await http.get(Uri.parse(UserReviewurl));
    var UserReviewresponse = await rootBundle.loadString('assets/responses/reviews_1096197.json');

   // if (UserReviewresponse.statusCode == 200) {
      var UserReviewjson = jsonDecode(UserReviewresponse);
      for (var i = 0; i < UserReviewjson['results'].length; i++) {
        UserREviews.add({
          "name": UserReviewjson['results'][i]['author'],
          "review": UserReviewjson['results'][i]['content'],
          //check rating is null or not
          "rating":
          UserReviewjson['results'][i]['author_details']['rating'] == null
              ? "Not Rated"
              : UserReviewjson['results'][i]['author_details']['rating']
              .toString(),
          "avatarphoto": UserReviewjson['results'][i]['author_details']
          ['avatar_path'] ==
              null
              ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
              : "https://image.tmdb.org/t/p/w500" +
              UserReviewjson['results'][i]['author_details']['avatar_path'],
          "creationdate":
          UserReviewjson['results'][i]['created_at'].substring(0, 10),
          "fullreviewurl": UserReviewjson['results'][i]['url'],
        });
      }
    // } else {}
    /////////////////////////////similar movies
    //var similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
    var similarmoviesresponse = await rootBundle.loadString('assets/responses/similar_1096197.json');

   // if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarmovieslist.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    //} else {}
    // print(similarmovieslist);
    /////////////////////////////recommended movies
   // var recommendedmoviesresponse = await http.get(Uri.parse(recommendedmoviesurl));
    var recommendedmoviesresponse = await rootBundle.loadString('assets/responses/recommendations_1096197.json');

   // if (recommendedmoviesresponse.statusCode == 200) {
      var recommendedmoviesjson = jsonDecode(recommendedmoviesresponse);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        recommendedmovieslist.add({
          "poster_path": recommendedmoviesjson['results'][i]['poster_path'],
          "name": recommendedmoviesjson['results'][i]['title'],
          "vote_average": recommendedmoviesjson['results'][i]['vote_average'],
          "Date": recommendedmoviesjson['results'][i]['release_date'],
          "id": recommendedmoviesjson['results'][i]['id'],
        });
      }
    //} else {}
    // print(recommendedmovieslist);
    /////////////////////////////movie trailers
   // var movietrailersresponse = await http.get(Uri.parse(movietrailersurl));
    var movietrailersresponse = await rootBundle.loadString('assets/responses/videos_1096197.json');

   // if (movietrailersresponse.statusCode == 200) {
      var movietrailersjson = jsonDecode(movietrailersresponse);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        if (movietrailersjson['results'][i]['type'] == "Trailer") {
          movietrailerslist.add({
            "key": movietrailersjson['results'][i]['key'],
          });
        }
      }
      movietrailerslist.add({'key': 'aJ0cZTcTh90'});
    //} else {}
    print(movietrailerslist);
  }void _writeReview() {
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
                print("Review: ${userReviewController.text}");
                print("Rating: $userRating");
                print("Movie ID: ${widget.id.toString()}");
                var review = jsonEncode({
                  "movieId": widget.id.toString(),
                  "userId": "123",
                  "rating": "$userRating",
                  "review":"${userReviewController.text}",
                  "username": "test_user",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
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
                  backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                  centerTitle: false,
                  pinned: true,
                  expandedHeight:
                  MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: FittedBox(
                      fit: BoxFit.fill,
                      child: trailerwatch(
                        trailerytid: movietrailerslist[0]['key']
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10,top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: MoviesGeneres.length,
                                    itemBuilder: (context, index){
                                      return Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color:
                                            Color.fromRGBO(25,25,25, 1),
                                          borderRadius:
                                            BorderRadius.circular(10),
                                        ),
                                        child: Text(MoviesGeneres[index]),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(left: 10,top: 10),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(25, 25, 25, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                    MovieDetails[0]['runtime'].toString() + ' min'
                                ),

                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text("Movie story :"),
                      ),
                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text(MovieDetails[0]['overview'].toString()),
                      ),

                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: ReviewUI(revdeatils: UserREviews),
                      ),

                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text('Release Date : '+ MovieDetails[0]['release_date'].toString()),
                      ),
                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text('Budget : '+ MovieDetails[0]['budget'].toString()),
                      ),
                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text('Revenue : '+ MovieDetails[0]['revenue'].toString()),
                      ),
                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text('Flick pick Rating : '+  MovieDetails[0]['rating'].toString()),
                      ),
                      Padding(padding: EdgeInsets.only(left: 20,top: 10),
                        child: Text('Flick pick Review : '+   MovieDetails[0]['review'].toString()),
                      ),
                      sliderlist(similarmovieslist, 'Similar Movies', 'movie', similarmovieslist.length),
                      sliderlist(recommendedmovieslist, 'Recommend Movies', 'movie', recommendedmovieslist.length),

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
