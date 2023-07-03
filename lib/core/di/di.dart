import 'package:ebsar2/core/utils/pref.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // SharedPref
  sl.registerLazySingleton<MySharedPref>(
        () => MySharedPref(),
  );

}
