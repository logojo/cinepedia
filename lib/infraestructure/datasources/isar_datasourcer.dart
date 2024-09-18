import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([MovieSchema],
          inspector: true, directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    //obteniendo la coneccion a la base de datos local
    final isar = await db;

    //realizando consulta select a bd local de isar
    //isar cuando hacemos el build genera metodos de consulta con todos los campos que conforman la entidad
    final Movie? isFavorite =
        await isar.movies.filter().idEqualTo(movieId).findFirst();

    return isFavorite != null ? true : false;
  }

  @override
  Future<void> toggleFaviorite(Movie movie) async {
    final isar = await db;

    final favorite = await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favorite != null) {
      //writeTxnSync se puede modificar para hacer una función con cuerpo y realizar todas las transacciones que se requieran
      //transacciones(insert, select, delete, etc....)

      //* eliminando pelicula
      isar.writeTxnSync(() => isar.movies.deleteSync(favorite.isarId!));
      return;
    }

    //insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;

    //obteniendo todas las peliculas paginadas de la bd local
    final movies =
        await isar.movies.where().offset(offset).limit(limit).findAll();

    return movies;
  }
}
