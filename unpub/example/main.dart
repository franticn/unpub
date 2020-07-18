import 'dart:io';

import 'package:unpub/unpub.dart' as unpub;

main(List<String> args) async {
  var basedir = '/path/to/basedir'; // Base directory to save pacakges
  var db = 'mongodb://localhost:27017/dart_pub'; // MongoDB uri

  var metaStore = unpub.MongoStore(db);
  await metaStore.db.open();

  var packageStore = unpub.FileStore(basedir);

  var app = unpub.App(

    ///元数据相关
      metaStore: metaStore,

      ///
      packageStore: packageStore,

      ///上传流地址 默认 https://pub.dev
      upstream: 'http://0.0.0.0:4001',

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

  var server = await app.serve('0.0.0.0', 4001);
  print('Serving at http://${server.address.host}:${server.port}');
}
