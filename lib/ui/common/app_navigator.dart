import 'package:flutter/material.dart';
import 'package:flutter_movie/ui/actor/actor_detail_view.dart';
import 'package:flutter_movie/ui/actor/actor_photos_view.dart';
import 'package:flutter_movie/ui/common/common_photo_view.dart';
import 'package:flutter_movie/ui/common/common_web_view.dart';
import 'package:flutter_movie/ui/movie/movie_detail_list.dart';
import 'package:flutter_movie/ui/movie/movie_list_view.dart';

class AppNavigator {


  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  static void toWebView(BuildContext context,{String url}) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                CommonWebView(url == null ? 'https://www.baidu.com' : url, '百度')));
  }

  static void toMovieDetail(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                MovieDetailList()));
  }

  static void toActorDetail(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                ActorDetailView()));
  }


  static void toMovieList(BuildContext context,String title,String action) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                MovieListView(action, title)));
  }

  static void toPhotoList(BuildContext context,String title) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                ActorPhotosView(title)));
  }

  static void toPhotoViewGallery(BuildContext context,List<String> images,int initIndex){
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return new CommonPhotoView(imageUrls: images, initIndex: initIndex);
    }));
  }
}
