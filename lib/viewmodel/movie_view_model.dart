import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie/base/base_view_model.dart';
import 'package:flutter_movie/base/view_state.dart';
import 'package:flutter_movie/model/movie_detail.dart';
import 'package:flutter_movie/model/movie_top_bannner.dart';
import 'package:flutter_movie/repository/movie_repository.dart';
import 'package:flutter_movie/ui/common/app_color.dart';
import 'package:flutter_movie/util/movie_data_util.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieViewModel extends BaseViewModel<MovieRepository> {
  var weeklyList;
  var top250List;
  var usBoxList;
  var newMoviesList;
  List<MovieTopBanner> banners;
  MovieDetail movieDetail;
  Color movieDetailPageColor = AppColor.white;

  /// 获取本周口碑榜电影
  Future<dynamic> getWeeklyList() async {
    var result = await requestData(mRepository.getWeeklyList());
    if (result == null) {
      return null;
    }
    List content = result.data['subjects'];
    List movies = [];
    content.forEach((data) {
      movies.add(data['subject']);
    });
    return movies;
  }

  /// 获取新片榜电影
  Future<dynamic> getNewMoviesList() async {
    var result = await requestData(mRepository.getNewMoviesList());
    return result?.data['subjects'];
  }

  /// 获取北美票房榜电影
  Future<dynamic> getUsBoxList() async {
    var result = await requestData(mRepository.getUsBoxList());
    if (result == null) {
      return null;
    }
    List content = result.data['subjects'];
    List movies = [];
    content.forEach((data) {
      movies.add(data['subject']);
    });
    return movies;
  }

  /// 获取 top250 榜单
  Future<dynamic> getTop250List({int start, int count}) async {
    var result = await requestData(
        mRepository.getTop250List(start: start, count: count));
    return result?.data['subjects'];
  }

  /// 获取电影详情
  Future<dynamic> getMovieDetail(String movieId) async {
    var result = await requestData(mRepository.getMovieDetail(movieId));
    movieDetail = MovieDetail.fromJson(result?.data);
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(movieDetail.images.small),
    );
    if (generator.darkVibrantColor != null) {
      movieDetailPageColor = generator.darkVibrantColor.color;
    } else {
      movieDetailPageColor = Color(0xff35374c);
    }
    setState(ViewState.loaded);
    return result?.data;
  }

  void loadData(int start, int count) async {
    await requestData(_loadData(start, count));
  }

  Future<dynamic> _loadData(int start, int count) async {
    weeklyList = MovieDataUtil.getMovieList(await getWeeklyList());
    top250List = MovieDataUtil.getMovieList(
        await getTop250List(start: start, count: count));
    usBoxList = MovieDataUtil.getMovieList(await getUsBoxList());
    newMoviesList = MovieDataUtil.getMovieList(await getNewMoviesList());

    var paletteGenerator1 = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(weeklyList[0].images.small));
    var paletteGenerator2 = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(top250List[0].images.small));
    var paletteGenerator3 = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(usBoxList[0].images.small));
    var paletteGenerator4 = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(newMoviesList[0].images.small));

    banners = [
      new MovieTopBanner(weeklyList, '一周口碑电影榜', '每周五更新·共10部', 'weekly',
          paletteGenerator1.darkVibrantColor),
      new MovieTopBanner(top250List, '豆瓣电影Top250', '豆瓣榜单·共250部', 'top250',
          paletteGenerator2.darkVibrantColor),
      new MovieTopBanner(newMoviesList, '一周新电影榜', '每周五更新·共10部', 'new_movies',
          paletteGenerator3.darkVibrantColor),
      new MovieTopBanner(usBoxList, '北美电影票房榜', '每周五更新·共10部', 'usBox',
          paletteGenerator4.darkVibrantColor),
    ];
  }

  @override
  MovieRepository createRepository() {
    return new MovieRepository();
  }
}
