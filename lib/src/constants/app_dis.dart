import 'package:dio/dio.dart';
import 'package:stepback/src/presentation/ai_reimagine_page/ai_reimagine_cubit.dart';
import 'package:stepback/src/presentation/ar_screen/ar_screen_cubit.dart';
import 'package:stepback/src/presentation/historical_sites/historical_sites_cubit.dart';
import 'package:stepback/src/presentation/location_info_widget/location_info_cubit.dart';
import 'package:stepback/src/resources/network/rest_api.dart';
import 'package:get_it/get_it.dart';

class AppDIs {

  static Future<void> dependencyInjection() async {
    _repositories();
    _cubits();
  }

  static void _repositories() {
    // GetIt.I.registerSingleton<HistoricalApiRepository>(HistoricalApiRepositoryImpl());    
  }

  static void _cubits() {
    GetIt.I.registerFactory<ARScreenCubit>(() => ARScreenCubit());
    GetIt.I.registerFactory<LocationInfoCubit>(() => LocationInfoCubit());
    GetIt.I.registerFactory<HistoricalSitesCubit>(() => HistoricalSitesCubit(
      apiClient: RestClient(Dio())
    ));
    GetIt.I.registerFactory<AIReimagineCubit>(() => AIReimagineCubit());
  }

}


