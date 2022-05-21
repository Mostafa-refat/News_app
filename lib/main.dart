import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:news_app/core/blocObserver/bloc_observer.dart';
import 'package:news_app/core/cacheHelper/cache_helper.dart';
import 'package:news_app/core/cubit/cubit.dart';
import 'package:news_app/core/cubit/states.dart';
import 'package:news_app/core/dioHelper/dio_helper.dart';
import 'package:news_app/core/styles/themes.dart';
import 'package:news_app/news_layout/cubit/cubit.dart';
import 'package:news_app/news_layout/news_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  final bool? isDark;

  MyApp({this.isDark});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit()..getBusiness()..getSports()..getScience(),
        ),
        BlocProvider(
          create: (context) => AppCubit()..changeNewsAppMode(fromShared: isDark),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // ------------------------------------->
            theme: lightTheme,
            // ------------------------------------->
            darkTheme: darkTheme,
            // ------------------------------------->
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: Directionality(
                textDirection: TextDirection.ltr,
                child: NewsLayout()
            ),
          );
        },
      ),
    );
  }
}
