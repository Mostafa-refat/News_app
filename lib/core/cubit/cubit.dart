import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cacheHelper/cache_helper.dart';
import 'package:news_app/core/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeNewsAppMode({bool? fromShared}){
    if(fromShared != null){
      isDark = fromShared;
      emit(NewsAppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value){
        emit(NewsAppChangeModeState());
      });
    }
  }

}
