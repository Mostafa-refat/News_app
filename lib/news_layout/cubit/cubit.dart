import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/dioHelper/dio_helper.dart';
import 'package:news_app/news_layout/cubit/states.dart';
import 'package:news_app/view/business/business_screen.dart';
import 'package:news_app/view/science/science_screen.dart';
import 'package:news_app/view/sports/sports_screen.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);
  // ---------------------------------------------------------->
  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];
  // ---------------------------------------------------------->
  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

// ---------------------------------------------------------->
  void changeBottomNavBar(int index){
    currentIndex = index;
    emit(NewsBottomNavState());
  }

// ---------------------------------------------------------->
  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());
    // ---------------------------------------------------------->
    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country':'eg',
        'category':'business',
        // 'apikey':'65f7f556ec76449fa7dc7c0069f040ca',
        'apikey':'960d990b1b34482c9b7e1265b4b8e224',
      },
    ).then((value){
      print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

// ---------------------------------------------------------->
  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingState());
// ---------------------------------------------------------->
    if(sports.length == 0){
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'sports',
          // 'apikey':'65f7f556ec76449fa7dc7c0069f040ca'
          'apikey':'960d990b1b34482c9b7e1265b4b8e224',

        },
      ).then((value){
        print(value.data['articles'][0]['title']);
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }
// ---------------------------------------------------------->

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingState());
    // ---------------------------------------------------------->
    if(science.length == 0){
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country':'eg',
          'category':'science',
          // 'apikey':'65f7f556ec76449fa7dc7c0069f040ca',
          'apikey':'960d990b1b34482c9b7e1265b4b8e224'

        },
      ).then((value){
        print(value.data['articles'][0]['title']);
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    }
    else {
      emit(NewsGetScienceSuccessState());
    }
  }
// ---------------------------------------------------------->

  List<dynamic> search = [];

  void getSearch(String value) {

    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q':'$value',
        // 'apikey':'65f7f556ec76449fa7dc7c0069f040ca',
        'apikey':'960d990b1b34482c9b7e1265b4b8e224'
      },
    ).then((value){
      // print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
// ---------------------------------------------------------->
}
