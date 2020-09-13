import 'package:food_app/services/auth.dart';
import 'package:food_app/services/database.dart';
import 'package:food_app/services/storage_repo.dart';
import 'package:food_app/services/user_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<UserController>(UserController());
}