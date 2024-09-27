import 'package:stepback/src/presentation/ai_reimagine_page/ai_reimagine_cubit.dart';
import 'package:stepback/src/presentation/ar_screen/ar_screen_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stepback/src/presentation/historical_sites/historical_sites_cubit.dart';
import 'package:stepback/src/presentation/location_info_widget/location_info_cubit.dart';

class AppBlocProviders {
  AppBlocProviders._();

  static final List<BlocProvider<dynamic>> providers = [
     BlocProvider<ARScreenCubit>(
       create: (context) => GetIt.I<ARScreenCubit>(),
     ),
     BlocProvider<LocationInfoCubit>(
       create: (context) => GetIt.I<LocationInfoCubit>(),
     ),
     BlocProvider<HistoricalSitesCubit>(
       create: (context) => GetIt.I<HistoricalSitesCubit>(),
     ),
     BlocProvider<AIReimagineCubit>(
       create: (context) => GetIt.I<AIReimagineCubit>(),
     ),
  ];
}