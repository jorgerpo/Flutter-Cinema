import 'package:cinema_flt/bloc/home_block.dart';
import 'package:cinema_flt/db/movie_db.dart';
import 'package:cinema_flt/db/movie_moor.dart';
import 'package:cinema_flt/repository/movie_repository.dart';
import 'package:cinema_flt/services/network_client.dart';
import 'package:cinema_flt/services/service.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> globalProviders = [
  ...independentServices,
  ...dependentServices,
];

List<SingleChildCloneableWidget> independentServices = [
  Provider.value(
    value: NetworkClient(),
  ),
  Provider.value(
    value: MovieDb(),
  )
];

List<SingleChildCloneableWidget> dependentServices = [
  ProxyProvider<NetworkClient, Service>(
    builder: (context, client, service) => Service.create(client.chopperClient),
    dispose: (context, service) => service.client.dispose(),
  ),
  ProxyProvider<MovieDb, MovieMoor>(
      builder: (context, movieDb, movieMorr) => MovieMoor(movieDb)),
  ProxyProvider2<MovieMoor, Service, MovieRepository>(
      builder: (context, movieMoor, service, movieRepository) =>
          MovieRepository(service, movieMoor)),
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
  ProxyProvider<MovieRepository, HomeBloc>(
    builder: (context, movieRepository, homeBloc) =>
        HomeBloc(movieRepository: movieRepository),
    dispose: (context, homeBloc) => homeBloc.dispose(),
  ),
];
