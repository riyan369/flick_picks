import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flick_picks/apikey/apiKey.dart';

import '../RepeatedFunction/searchbarfunc.dart';
import '../sectionPages/movies.dart';
import '../sectionPages/profile_page.dart';
import '../sectionPages/tvseries.dart';
import '../sectionPages/upcoming.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int uval =1;
  List<Map<String, dynamic>> trendingList = [];
  Future<void> trendingListHome() async {
    if (uval == 1) {
      var trendingweekurl =
          'https://api.themoviedb.org/3/trending/all/week?api_key=$apiKey';

     // var trendingWeekResponse = await http.get(Uri.parse(trendingweekurl));
      var trendingWeekResponse = await rootBundle.loadString('assets/responses/trending_all_weekly.json');

     // if (trendingWeekResponse.statusCode == 200) {
        //var tempdata = jsonDecode(trendingWeekResponse.body);
        var tempdata = jsonDecode(trendingWeekResponse);
        var trendingweekjson = tempdata['results'];

        for (var i = 0; i < trendingweekjson.length; i++) {
          trendingList.add({
            'id': trendingweekjson[i]['id'],
            'poster_path': trendingweekjson[i]['poster_path'],
            'vote_average': trendingweekjson[i]['vote_average'],
            'media_type': trendingweekjson[i]['media_type'],
            'indexno': i,
          });
        }
     // }
    }
    else if (uval == 2) {
      var trendingdailyurl =
          'https://api.themoviedb.org/3/trending/all/day?api_key=$apiKey';
      //var trendingDailyResponse = await http.get(Uri.parse(trendingdailyurl));
      var trendingDailyResponse = await rootBundle.loadString('assets/responses/trending_all_day.json');

      //if (trendingDailyResponse.statusCode == 200) {
       // var tempdata = jsonDecode(trendingDailyResponse.body);
        var tempdata = jsonDecode(trendingDailyResponse);
        var trendingdailyjson = tempdata['results'];

        for (var i = 0; i < trendingdailyjson.length; i++) {
          trendingList.add({
            'id': trendingdailyjson[i]['id'],
            'poster_path': trendingdailyjson[i]['poster_path'],
            'vote_average': trendingdailyjson[i]['vote_average'],
            'media_type': trendingdailyjson[i]['media_type'],
            'indexno': i,
          });
        }
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            toolbarHeight: 60,
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FutureBuilder(
                future: trendingListHome(),
                builder: (context, snapshot){
                  if(snapshot.connectionState== ConnectionState.done){
                    return CarouselSlider(
                      options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          height: MediaQuery.of(context).size.height),
                      items: trendingList.map((i){
                        return Builder(builder: (BuildContext context){
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken),
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${i['poster_path']}'
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    );
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }
                },
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Trending'+' 🔥',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),),
                SizedBox(width: 10,),
                Container(
                  height: 45,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DropdownButton(
                      onChanged: (value){
                        setState(() {
                          trendingList.clear();
                          uval = int.parse(value.toString());
                        });
                      },
                      autofocus: true,
                      underline: Container(height: 0,color: Colors.transparent,),
                      dropdownColor: Colors.black.withOpacity(0.6),
                      icon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.amber,
                        size: 30,
                      ),
                      value: uval,
                      items: [
                        DropdownMenuItem(
                            child: Text('weekly',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text('Daily',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 16,
                            ),),
                          value: 2,
                        )

                      ],
                    ),
                  ),
                ),
                SizedBox(width: 50,),
                GestureDetector(
                  onTap: () {
                    // Navigate to another page when CircleAvatar is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.amber, // You can set any desired color
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.amber, // Background color of the CircleAvatar
                      child: Icon(
                        Icons.person, // Replace with the desired icon
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
                searchbarfun(),

                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                    physics: BouncingScrollPhysics(),
                    labelPadding: EdgeInsets.symmetric(horizontal: 25),
                    isScrollable: true,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.amber.withOpacity(0.4),
                    ),
                    tabs: [
                      Tab(child: Text('Tv series'),),
                      Tab(child: Text('Movies'),),
                      Tab(child: Text('Upcoming'),),
                    ],
                  ),
                ),
                Container(
                  height: 1050,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Tvseries(),
                      Movie(),
                      Upcomming(),
                    ],
                  ),
                )

              ],),)
        ],
      ),
    );
  }
}
