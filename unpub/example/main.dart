import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:unpub/unpub.dart' as unpub;

main(List<String> args) async {
  var parser = ArgParser();
  parser.addOption('host', abbr: 'h', defaultsTo: '0.0.0.0');
  parser.addOption('port', abbr: 'p', defaultsTo: '4001');
  parser.addOption('database',
      abbr: 'd', defaultsTo: 'mongodb://localhost:27017/dart_pub');

  var results = parser.parse(args);

  var host = results['host'] as String;
  var port = int.parse(results['port'] as String);
  var db = results['database'] as String;

  if (results.rest.isNotEmpty) {
    print('Got unexpected arguments: "${results.rest.join(' ')}".\n\nUsage:\n');
    print(parser.usage);
    exit(1);
  }

  var mongoStore = unpub.MongoStore(db);
  await mongoStore.db.open();

  var baseDir = path.absolute('unpub-packages');
  var packageStore = unpub.FileStore(baseDir);
//  packageStore.supportsDownloadUrl = true;
  var app = unpub.App(

    ///元数据相关
      metaStore: mongoStore,

      ///
      packageStore: packageStore,

//      ///上传流地址 默认 https://pub.dev
//      upstream: 'http://0.0.0.0:4001',

      ///Http(s) proxy to call googleapis (to get uploader email)
      googleapisProxy: '',

      uploaderPassword: 'xxxx',

      ///If specified, unpub will use this email as uploader instead of requesting googleapis
      overrideUploaderEmail: 'xc.fang@tuya.com',

      uploadValidator: (Map<String, dynamic> pubSpec, String uploaderEmail) {
        ///默认前缀,只有是此前缀的包才允许上传
        var prefix = 'tuya_';
        var name = pubSpec['name'] as String;
        if (!name.startsWith(prefix)) {
          throw 'ERROR -> Package name should starts with $prefix';
        }

        if (!(uploaderEmail ?? '').endsWith('@tuya.com')) {
          throw 'ERROR -> Uploader email invalid';
        }
      });

  var server = await app.serve(host, port);
  print('Serving at http://${server.address.host}:${server.port}');
}
