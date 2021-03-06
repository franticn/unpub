import 'dart:io';
import 'package:path/path.dart' as path;
import 'package_store.dart';

class FileStore extends PackageStore {
  String baseDir;

  FileStore(this.baseDir);

  File _getTarballFile(String package, String version) {
    var pathDir = path.join(baseDir, '$package-$version.tar.gz');
    return File(pathDir);
  }

  @override
  Future<void> upload(String package, String version, List<int> content) async {
    try {
      var file = _getTarballFile(package, version);
      await file.create(recursive: true);
      await file.writeAsBytes(content);
    } catch (e) {
      /// todo need fix error : Creation failed, path = '/path' (OS Error: Read-only file system, errno = 30)
      print('error -> ' + e.toString());
    }
  }

  @override
  Stream<List<int>> download(String package, String version) {
    return _getTarballFile(package, version).openRead();
  }
}
