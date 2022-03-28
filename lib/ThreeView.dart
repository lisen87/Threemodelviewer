import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Created by robot on 2022/3/26 12:52.
/// Container(
///               height: 300,
///               width: 300,
///               color: Colors.blue,
///               child: const ThreeView(
///                 src: "http://xingchen.p1.sdqttx.net:91/test/ship.obj",
///                 modelType: ModelType.http,
///                 srcDrawable: [
///                   "http://xingchen.p1.sdqttx.net:91/test/ship.bmp",
///                   "http://xingchen.p1.sdqttx.net:91/test/ship.mtl",
///                   "http://xingchen.p1.sdqttx.net:91/test/ship.png",
///                 ],
///               ),
///             ),
///
///
/// Container(
///   height: 300,
///   width: 300,
///   color: Colors.green,
///   child: const ThreeView(
///     src: "assets/ship.obj",
///     modelType: ModelType.file,
///     srcDrawable: [
///       "assets/ship.bmp",
///       "assets/ship.mtl",
///       "assets/ship.png",
///     ],
///   ),
/// ),
///
///
/// Container(
///              height: 300,
///              width: 300,
///              color: Colors.green,
///              child: const ThreeView(
///                src: "文件路径path",
///                modelType: ModelType.file,
///              ),
///            ),
/// @author robot < robot >

class ThreeView extends StatefulWidget {
  final Function(int type,int progress)? loadCallback;
  final String src;
  final List<String>? srcDrawable;
  final ModelType modelType;
  final bool useCache;
  final Widget? placeholder;

  /// 安卓支持：obj,stl, dae ，ios支持：obj，dae ，

  ///src: assets/xxx.obj 或 文件路径 或 http:xxxx.obj
  ///modelType:   assets,file, http,
  ///srcDrawable 有些 obj 需要 图片等资源在和obj文件同一文件夹下才正常显示，当为 modelType= assets才需要
  const ThreeView(
      {Key? key,
      required this.src,
      required this.modelType,
      this.srcDrawable,
      this.useCache = true,
      this.placeholder,
      this.loadCallback})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ThreeViewState();
  }
}


class ThreeViewState extends State<ThreeView> {
  final String viewType = "3dModelViewer";
  Map<String ,String> srcDrawableUris = {};
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uri>(
      future: getSrcByModelType(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
        if (snapshot.data != null && snapshot.connectionState == ConnectionState.done) {
          if(Platform.isAndroid){
            ///0 = obj, 1 = stl, 2 = dae
            int type = -1;
            if(snapshot.data.toString().toLowerCase().endsWith("obj")){
              type = 0;
            }else if(snapshot.data.toString().toLowerCase().endsWith("stl")){
              type = 1;
            }else if(snapshot.data.toString().toLowerCase().endsWith("dae")){
              type = 2;
            }
            return AndroidView(
              viewType: viewType,
              creationParams: <String, dynamic>{
                'src': snapshot.data.toString(),
                'type':type,
                'srcDrawable':srcDrawableUris,
              },
              creationParamsCodec: const StandardMessageCodec(),
            );
          }else if(Platform.isIOS){
            return UiKitView(
              viewType: viewType,
              creationParams: <String, dynamic>{
                'src': snapshot.data,
                'type':snapshot.data.toString().toLowerCase(),
                'srcDrawable':srcDrawableUris,
              },
              creationParamsCodec: const StandardMessageCodec(),
            );
          }
        }

        return widget.placeholder ?? const Center(child: CupertinoActivityIndicator(),);
      },
    );
  }
  CancelToken? _cancelToken;

  _copy(String assetPath) async {
    String fileName = assetPath;
    if(assetPath.contains("/")){
      fileName = assetPath.split("/").last;
    }
    Directory dir = await getTemporaryDirectory();
    File f = File(dir.path+"/models/"+fileName);
    bool exists = await f.exists();
    if(!exists || await f.length() == 0){
      var bytes = await rootBundle.load(assetPath);
      final buffer = bytes.buffer;
      f.create(recursive: true);
      await f.writeAsBytes(
          buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    }
    srcDrawableUris[fileName] = f.uri.toString();
  }

  ///返回文件路径 uri
  Future<Uri> getSrcByModelType() async {

    if(widget.modelType == ModelType.assets){
      ///assets

      if(widget.srcDrawable != null){
        for (String element in widget.srcDrawable!) {
          _copy(element);
        }
      }


      String fileName = widget.src;
      if(widget.src.contains("/")){
        fileName = widget.src.split("/").last;
      }

      Directory dir = await getTemporaryDirectory();
      File f = File(dir.path+"/models/"+fileName);
      if(await f.exists() && await f.length() > 0){
        return f.uri;
      }else{
        f.create(recursive: true);
        var bytes = await rootBundle.load(widget.src);
        final buffer = bytes.buffer;
        await f.writeAsBytes(
            buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        return f.uri;
      }

    }else if(widget.modelType == ModelType.http){
      _cancelToken = CancelToken();

      if(widget.srcDrawable != null){
        for (String element in widget.srcDrawable!) {

          String fileName = element;
          if(element.contains("/")){
            fileName = element.split("/").last;
          }
          Directory dir = await getTemporaryDirectory();
          File f = File(dir.path+"/models/"+fileName);
          bool exists = await f.exists();
          if(!widget.useCache || !exists || await f.length() == 0){
            Dio dio = Dio();
            Response response = await dio.download(element, f.path, cancelToken: _cancelToken);
            if(response.statusCode == 200){
              srcDrawableUris[fileName] = f.uri.toString();
            }
          }else{
            srcDrawableUris[fileName] = f.uri.toString();
          }
        }
      }

      String fileName = widget.src.split("/").last;

      Directory dir = await getTemporaryDirectory();
      File f = File(dir.path+"/models/"+fileName);
      if(!widget.useCache || !await f.exists() || await f.length() == 0){
        Dio dio = Dio();
        Response response = await dio.download(widget.src, f.path, cancelToken: _cancelToken);

        if(response.statusCode == 200){
          return f.uri;
        }else{
          return Uri.parse(response.statusCode.toString());
        }
      }else{
        return f.uri;
      }
    }else{
      return File(widget.src).uri;
    }
  }
  @override
  void dispose() {
    super.dispose();
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('');
    }
  }
}

enum ModelType {
  file,
  assets,
  http,
}