import 'package:get_it/get_it.dart';

import '../../features/exchange/data/datasources/exchange_remote_datasource.dart';
import '../../features/exchange/data/repositories/exchange_repository_impl.dart';
import '../../features/exchange/domain/repositories/exchange_repository.dart';
import '../../features/exchange/presentation/bloc/exchange_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Core
  sl.registerLazySingleton(() => createDioClient());

  // Data sources
  sl.registerLazySingleton<ExchangeRemoteDataSource>(
    () => ExchangeRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ExchangeRepository>(
    () => ExchangeRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory(() => ExchangeCubit(repository: sl()));
}
