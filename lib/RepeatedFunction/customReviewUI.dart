import 'package:flutter/material.dart';

class CustomReviewUI extends StatelessWidget {
  final List<Map<String, dynamic>>? revDetails;

  CustomReviewUI({required this.revDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reviews:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          SizedBox(height: 10),
          // Check if revDetails is null or empty
          revDetails == null || revDetails!.isEmpty
              ? Text(
            "No reviews yet.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )
              : // Use ListView.builder to display reviews dynamically
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: revDetails?.length,
            itemBuilder: (context, index) {
              var review = revDetails?[index];

              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rating: ${review?['rating']}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Review: ${review?['review']}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Username: ${review?['username']}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
