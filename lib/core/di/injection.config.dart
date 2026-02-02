// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:zeca_app/core/network/dio_client.dart' as _i241;
import 'package:zeca_app/core/services/api_service.dart' as _i844;
import 'package:zeca_app/core/services/geocoding_service.dart' as _i579;
import 'package:zeca_app/core/services/storage_service.dart' as _i852;
import 'package:zeca_app/features/auth/data/datasources/auth_local_datasource.dart'
    as _i414;
import 'package:zeca_app/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i857;
import 'package:zeca_app/features/auth/data/datasources/user_remote_datasource.dart'
    as _i974;
import 'package:zeca_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i667;
import 'package:zeca_app/features/auth/domain/repositories/auth_repository.dart'
    as _i464;
import 'package:zeca_app/features/auth/domain/usecases/login_usecase.dart'
    as _i678;
import 'package:zeca_app/features/auth/domain/usecases/logout_usecase.dart'
    as _i1041;
import 'package:zeca_app/features/auth/domain/usecases/refresh_token_usecase.dart'
    as _i978;
import 'package:zeca_app/features/auth/presentation/bloc/auth_bloc.dart'
    as _i589;
import 'package:zeca_app/features/autonomous/data/datasources/autonomous_remote_datasource.dart'
    as _i106;
import 'package:zeca_app/features/autonomous/data/repositories/autonomous_repository_impl.dart'
    as _i649;
import 'package:zeca_app/features/autonomous/presentation/bloc/autonomous_registration_bloc.dart'
    as _i545;
import 'package:zeca_app/features/autonomous/presentation/bloc/autonomous_vehicles_bloc.dart'
    as _i56;
import 'package:zeca_app/features/change_password/data/repositories/change_password_repository.dart'
    as _i654;
import 'package:zeca_app/features/change_password/domain/usecases/change_password_usecase.dart'
    as _i28;
import 'package:zeca_app/features/change_password/presentation/bloc/change_password_bloc.dart'
    as _i400;
import 'package:zeca_app/features/history/data/datasources/history_remote_datasource.dart'
    as _i753;
import 'package:zeca_app/features/history/data/repositories/history_repository_impl.dart'
    as _i191;
import 'package:zeca_app/features/history/domain/repositories/history_repository.dart'
    as _i799;
import 'package:zeca_app/features/history/domain/usecases/get_history_usecase.dart'
    as _i653;
import 'package:zeca_app/features/history/presentation/bloc/history_bloc.dart'
    as _i639;
import 'package:zeca_app/features/home/data/datasources/fuel_station_remote_datasource.dart'
    as _i787;
import 'package:zeca_app/features/home/data/datasources/vehicle_remote_datasource.dart'
    as _i921;
import 'package:zeca_app/features/home/data/repositories/fuel_station_repository_impl.dart'
    as _i317;
import 'package:zeca_app/features/home/data/repositories/vehicle_repository_impl.dart'
    as _i404;
import 'package:zeca_app/features/home/domain/repositories/fuel_station_repository.dart'
    as _i222;
import 'package:zeca_app/features/home/domain/repositories/vehicle_repository.dart'
    as _i1001;
import 'package:zeca_app/features/home/domain/usecases/get_nearby_stations_usecase.dart'
    as _i85;
import 'package:zeca_app/features/home/domain/usecases/search_vehicle_usecase.dart'
    as _i292;
import 'package:zeca_app/features/home/domain/usecases/validate_station_usecase.dart'
    as _i32;
import 'package:zeca_app/features/home/presentation/bloc/nearby_stations/nearby_stations_bloc.dart'
    as _i434;
import 'package:zeca_app/features/home/presentation/bloc/refueling_form_bloc.dart'
    as _i23;
import 'package:zeca_app/features/home/presentation/bloc/vehicle_bloc.dart'
    as _i948;
import 'package:zeca_app/features/notifications/data/datasources/notification_remote_datasource.dart'
    as _i218;
import 'package:zeca_app/features/notifications/data/repositories/notification_repository_impl.dart'
    as _i61;
import 'package:zeca_app/features/notifications/domain/repositories/notification_repository.dart'
    as _i472;
import 'package:zeca_app/features/notifications/domain/usecases/get_notification_settings_usecase.dart'
    as _i812;
import 'package:zeca_app/features/notifications/domain/usecases/get_notifications_usecase.dart'
    as _i363;
import 'package:zeca_app/features/notifications/domain/usecases/mark_notification_read_usecase.dart'
    as _i30;
import 'package:zeca_app/features/notifications/domain/usecases/send_notification_usecase.dart'
    as _i693;
import 'package:zeca_app/features/notifications/domain/usecases/update_notification_settings_usecase.dart'
    as _i175;
import 'package:zeca_app/features/notifications/presentation/bloc/notification_bloc.dart'
    as _i533;
import 'package:zeca_app/features/refueling/data/datasources/document_remote_datasource.dart'
    as _i493;
import 'package:zeca_app/features/refueling/data/datasources/refueling_remote_datasource.dart'
    as _i133;
import 'package:zeca_app/features/refueling/data/repositories/document_repository_impl.dart'
    as _i672;
import 'package:zeca_app/features/refueling/data/repositories/refueling_repository_impl.dart'
    as _i93;
import 'package:zeca_app/features/refueling/domain/repositories/document_repository.dart'
    as _i63;
import 'package:zeca_app/features/refueling/domain/repositories/refueling_repository.dart'
    as _i724;
import 'package:zeca_app/features/refueling/domain/usecases/finalize_refueling_usecase.dart'
    as _i271;
import 'package:zeca_app/features/refueling/domain/usecases/generate_refueling_code_usecase.dart'
    as _i117;
import 'package:zeca_app/features/refueling/domain/usecases/upload_document_usecase.dart'
    as _i514;
import 'package:zeca_app/features/refueling/domain/usecases/validate_refueling_code_usecase.dart'
    as _i256;
import 'package:zeca_app/features/refueling/presentation/bloc/document_bloc.dart'
    as _i698;
import 'package:zeca_app/features/refueling/presentation/bloc/refueling_code_bloc.dart'
    as _i651;
import 'package:zeca_app/features/trip/data/datasources/expense_remote_datasource.dart'
    as _i41;
import 'package:zeca_app/features/trip/data/datasources/trip_remote_datasource.dart'
    as _i105;
import 'package:zeca_app/features/trip/data/repositories/expense_repository_impl.dart'
    as _i68;
import 'package:zeca_app/features/trip/data/repositories/trip_repository_impl.dart'
    as _i725;
import 'package:zeca_app/features/trip/domain/repositories/expense_repository.dart'
    as _i589;
import 'package:zeca_app/features/trip/domain/repositories/trip_repository.dart'
    as _i139;
import 'package:zeca_app/features/trip/domain/usecases/create_expense.dart'
    as _i427;
import 'package:zeca_app/features/trip/domain/usecases/get_active_trip.dart'
    as _i948;
import 'package:zeca_app/features/trip/domain/usecases/get_expense_categories.dart'
    as _i632;
import 'package:zeca_app/features/trip/domain/usecases/get_expenses_by_trip.dart'
    as _i1051;
import 'package:zeca_app/features/trip/domain/usecases/get_trip_summary.dart'
    as _i780;
import 'package:zeca_app/features/trip/presentation/bloc/trip_expenses_bloc.dart'
    as _i501;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i579.GeocodingService>(() => _i579.GeocodingService());
    gh.factory<_i23.RefuelingFormBloc>(() => _i23.RefuelingFormBloc());
    gh.factory<_i921.VehicleRemoteDataSource>(
        () => _i921.VehicleRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i753.HistoryRemoteDataSource>(
        () => _i753.HistoryRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i974.UserRemoteDataSource>(
        () => _i974.UserRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i493.DocumentRemoteDataSource>(
        () => _i493.DocumentRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i787.FuelStationRemoteDataSource>(
        () => _i787.FuelStationRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i106.AutonomousRemoteDataSource>(
        () => _i106.AutonomousRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i857.AuthRemoteDataSource>(
        () => _i857.AuthRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i799.HistoryRepository>(
        () => _i191.HistoryRepositoryImpl(gh<_i753.HistoryRemoteDataSource>()));
    gh.factory<_i218.NotificationRemoteDataSource>(
        () => _i218.NotificationRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i133.RefuelingRemoteDataSource>(
        () => _i133.RefuelingRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i724.RefuelingRepository>(() =>
        _i93.RefuelingRepositoryImpl(gh<_i133.RefuelingRemoteDataSource>()));
    gh.factory<_i653.GetHistoryUseCase>(
        () => _i653.GetHistoryUseCase(gh<_i799.HistoryRepository>()));
    gh.factory<_i653.GetRefuelingDetailsUseCase>(
        () => _i653.GetRefuelingDetailsUseCase(gh<_i799.HistoryRepository>()));
    gh.lazySingleton<_i105.TripRemoteDataSource>(
        () => _i105.TripRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.lazySingleton<_i41.ExpenseRemoteDataSource>(
        () => _i41.ExpenseRemoteDataSourceImpl(gh<_i241.DioClient>()));
    gh.factory<_i414.AuthLocalDataSource>(
        () => _i414.AuthLocalDataSourceImpl(gh<_i852.StorageService>()));
    gh.factory<_i649.AutonomousRepository>(() =>
        _i649.AutonomousRepositoryImpl(gh<_i106.AutonomousRemoteDataSource>()));
    gh.factory<_i56.AutonomousVehiclesBloc>(
        () => _i56.AutonomousVehiclesBloc(gh<_i649.AutonomousRepository>()));
    gh.factory<_i545.AutonomousRegistrationBloc>(() =>
        _i545.AutonomousRegistrationBloc(gh<_i649.AutonomousRepository>()));
    gh.factory<_i1001.VehicleRepository>(
        () => _i404.VehicleRepositoryImpl(gh<_i921.VehicleRemoteDataSource>()));
    gh.factory<_i639.HistoryBloc>(
        () => _i639.HistoryBloc(gh<_i653.GetHistoryUseCase>()));
    gh.factory<_i654.ChangePasswordRepository>(
        () => _i654.ChangePasswordRepository(gh<_i844.ApiService>()));
    // Trip/Expense Repositories - must be registered before use cases
    gh.lazySingleton<_i139.TripRepository>(
        () => _i725.TripRepositoryImpl(gh<_i105.TripRemoteDataSource>()));
    gh.lazySingleton<_i589.ExpenseRepository>(
        () => _i68.ExpenseRepositoryImpl(gh<_i41.ExpenseRemoteDataSource>()));
    // Trip Use Cases - must be registered before TripExpensesBloc
    gh.factory<_i948.GetActiveTrip>(
        () => _i948.GetActiveTrip(gh<_i139.TripRepository>()));
    gh.factory<_i780.GetTripSummary>(
        () => _i780.GetTripSummary(gh<_i139.TripRepository>()));
    gh.factory<_i632.GetExpenseCategories>(
        () => _i632.GetExpenseCategories(gh<_i589.ExpenseRepository>()));
    gh.factory<_i1051.GetExpensesByTrip>(
        () => _i1051.GetExpensesByTrip(gh<_i589.ExpenseRepository>()));
    gh.factory<_i427.CreateExpense>(
        () => _i427.CreateExpense(gh<_i589.ExpenseRepository>()));
    gh.factory<_i501.TripExpensesBloc>(() => _i501.TripExpensesBloc(
          getActiveTrip: gh<_i948.GetActiveTrip>(),
          getTripSummary: gh<_i780.GetTripSummary>(),
          getExpenseCategories: gh<_i632.GetExpenseCategories>(),
          getExpensesByTrip: gh<_i1051.GetExpensesByTrip>(),
          createExpense: gh<_i427.CreateExpense>(),
        ));
    gh.factory<_i222.FuelStationRepository>(() =>
        _i317.FuelStationRepositoryImpl(
            gh<_i787.FuelStationRemoteDataSource>()));
    gh.factory<_i63.DocumentRepository>(() =>
        _i672.DocumentRepositoryImpl(gh<_i493.DocumentRemoteDataSource>()));
    gh.factory<_i292.SearchVehicleUseCase>(
        () => _i292.SearchVehicleUseCase(gh<_i1001.VehicleRepository>()));
    gh.factory<_i514.UploadDocumentUseCase>(
        () => _i514.UploadDocumentUseCase(gh<_i63.DocumentRepository>()));
    gh.factory<_i464.AuthRepository>(() => _i667.AuthRepositoryImpl(
          gh<_i857.AuthRemoteDataSource>(),
          gh<_i414.AuthLocalDataSource>(),
          gh<_i852.StorageService>(),
        ));
    gh.factory<_i472.NotificationRepository>(() =>
        _i61.NotificationRepositoryImpl(
            gh<_i218.NotificationRemoteDataSource>()));
    gh.factory<_i256.ValidateRefuelingCodeUseCase>(() =>
        _i256.ValidateRefuelingCodeUseCase(gh<_i724.RefuelingRepository>()));
    gh.factory<_i271.FinalizeRefuelingUseCase>(
        () => _i271.FinalizeRefuelingUseCase(gh<_i724.RefuelingRepository>()));
    gh.factory<_i117.GenerateRefuelingCodeUseCase>(() =>
        _i117.GenerateRefuelingCodeUseCase(gh<_i724.RefuelingRepository>()));
    gh.factory<_i698.DocumentBloc>(() => _i698.DocumentBloc(
        uploadDocumentUseCase: gh<_i514.UploadDocumentUseCase>()));
    gh.factory<_i978.RefreshTokenUseCase>(
        () => _i978.RefreshTokenUseCase(gh<_i464.AuthRepository>()));
    gh.factory<_i678.LoginUseCase>(
        () => _i678.LoginUseCase(gh<_i464.AuthRepository>()));
    gh.factory<_i1041.LogoutUseCase>(
        () => _i1041.LogoutUseCase(gh<_i464.AuthRepository>()));
    gh.factory<_i28.ChangePasswordUseCase>(
        () => _i28.ChangePasswordUseCase(gh<_i654.ChangePasswordRepository>()));
    gh.factory<_i32.ValidateStationUseCase>(
        () => _i32.ValidateStationUseCase(gh<_i222.FuelStationRepository>()));
    gh.factory<_i85.GetNearbyStationsUseCase>(
        () => _i85.GetNearbyStationsUseCase(gh<_i222.FuelStationRepository>()));
    gh.factory<_i651.RefuelingCodeBloc>(() => _i651.RefuelingCodeBloc(
          generateRefuelingCodeUseCase:
              gh<_i117.GenerateRefuelingCodeUseCase>(),
          validateRefuelingCodeUseCase:
              gh<_i256.ValidateRefuelingCodeUseCase>(),
        ));
    gh.factory<_i589.AuthBloc>(() => _i589.AuthBloc(
          loginUseCase: gh<_i678.LoginUseCase>(),
          logoutUseCase: gh<_i1041.LogoutUseCase>(),
          authRepository: gh<_i464.AuthRepository>(),
        ));
    gh.factory<_i400.ChangePasswordBloc>(() => _i400.ChangePasswordBloc(
          gh<_i28.ChangePasswordUseCase>(),
          gh<_i589.AuthBloc>(),
        ));
    gh.factory<_i175.UpdateNotificationSettingsUseCase>(() =>
        _i175.UpdateNotificationSettingsUseCase(
            gh<_i472.NotificationRepository>()));
    gh.factory<_i693.SendNotificationUseCase>(() =>
        _i693.SendNotificationUseCase(gh<_i472.NotificationRepository>()));
    gh.factory<_i363.GetNotificationsUseCase>(() =>
        _i363.GetNotificationsUseCase(gh<_i472.NotificationRepository>()));
    gh.factory<_i30.MarkNotificationReadUseCase>(() =>
        _i30.MarkNotificationReadUseCase(gh<_i472.NotificationRepository>()));
    gh.factory<_i812.GetNotificationSettingsUseCase>(() =>
        _i812.GetNotificationSettingsUseCase(
            gh<_i472.NotificationRepository>()));
    gh.factory<_i533.NotificationBloc>(() => _i533.NotificationBloc(
          getNotificationsUseCase: gh<_i363.GetNotificationsUseCase>(),
          markNotificationReadUseCase: gh<_i30.MarkNotificationReadUseCase>(),
          getNotificationSettingsUseCase:
              gh<_i812.GetNotificationSettingsUseCase>(),
          updateNotificationSettingsUseCase:
              gh<_i175.UpdateNotificationSettingsUseCase>(),
        ));
    gh.factory<_i948.VehicleBloc>(() => _i948.VehicleBloc(
          searchVehicleUseCase: gh<_i292.SearchVehicleUseCase>(),
          getNearbyStationsUseCase: gh<_i85.GetNearbyStationsUseCase>(),
          validateStationUseCase: gh<_i32.ValidateStationUseCase>(),
        ));
    gh.factory<_i434.NearbyStationsBloc>(
        () => _i434.NearbyStationsBloc(gh<_i85.GetNearbyStationsUseCase>()));
    return this;
  }
}
