import 'package:flick_picks/details/tvseriesdetails.dart';
import 'package:flutter/material.dart';
import 'moviedetails.dart';


class descriptioncheckui extends StatefulWidget {
  var newid;
  var newtype;
   descriptioncheckui(this.newid,this.newtype);

  @override
  State<descriptioncheckui> createState() => _descriptioncheckuiState();
}

class _descriptioncheckuiState extends State<descriptioncheckui> {

  checkType(){
    if(widget.newtype =='movie'){
      return MovieDetail(widget.newid);
    }
    else if(widget.newtype =='tv'){
      return TvSeriesDetails(id : widget.newid);
    }
    else {
      return errorui();
    }
  }
  @override
  Widget build(BuildContext context) {
    return checkType();
  }
}

Widget errorui(){
  return Scaffold(
    body: Center(
      child: Text('Error'),
    ),
  );
}