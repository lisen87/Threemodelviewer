import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:threemodelviewer/threemodelviewer.dart';

import 'StatusInfo.dart';

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
///     modelType: ModelType.assets,
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
  ///支持安卓，不支持ios
  final Function(StatusInfo)? loadCallback;
  final String src;
  final List<String>? srcDrawable;
  final ModelType modelType;
  final bool useCache;
  final bool enableTouch;
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
      this.enableTouch = true,
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
  final ValueNotifier<StatusInfo> _status = ValueNotifier<StatusInfo>(StatusInfo(status: "",info: ""));
  Threemodelviewer threemodelviewer = Threemodelviewer();
  @override
  void initState() {
    super.initState();
    threemodelviewer.init();
    threemodelviewer.statusController.stream.listen((event) {
      _status.value = event;
      widget.loadCallback?.call(event);
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uri>(
      future: getSrcByModelType(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
        if (snapshot.data != null && snapshot.connectionState == ConnectionState.done) {
          if(Platform.isAndroid){
            return _getAndroidView(snapshot.data.toString());
          }else if(Platform.isIOS){
            return _getIosView(snapshot.data.toString());
          }
        }
        return Center(child: widget.placeholder ?? const CupertinoActivityIndicator(),);
      },
    );
  }

  Widget _getIosView(String data){
    return UiKitView(
      viewType: viewType,
      creationParams: <String, dynamic>{
        'src': data,
        'type': data.toLowerCase(),
        'enableTouch':widget.enableTouch,
        'srcDrawable':srcDrawableUris,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }


  Widget _getAndroidView(String data){
    ///0 = obj, 1 = stl, 2 = dae
    int type = -1;
    if(data.toLowerCase().endsWith("obj")){
      type = 0;
    }else if(data.toLowerCase().endsWith("stl")){
      type = 1;
    }else if(data.toLowerCase().endsWith("dae")){
      type = 2;
    }
    return Stack(
      children: [
        ValueListenableBuilder(valueListenable: _status, builder: (BuildContext context, StatusInfo value, Widget? child) {
          if(value.status == Status.onLoadComplete.name){
            threemodelviewer.enableTouch(widget.enableTouch);
            return const SizedBox();
          }else {
            return Center(
              child: widget.placeholder ?? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(),
                  const SizedBox(height: 10,),
                  Text(value.status == Status.onProgress.name ?value.info.toString() + "%":value.info ?? "",style: const TextStyle(fontSize: 14,color: Colors.grey),)
                ],
              ),
            );
          }
        }),

        AndroidView(
          viewType: viewType,
          creationParams: <String, dynamic>{
            'src': data,
            'type':type,
            'enableTouch': false,
            'srcDrawable':srcDrawableUris,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      ],
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
      Directory dir = await getTemporaryDirectory();
      if(widget.srcDrawable != null){
        for(int i = 0; i < widget.srcDrawable!.length;i++){
          String assetsName = widget.srcDrawable![i];
          String fileName = assetsName;
          if(assetsName.contains("/")){
            fileName = assetsName.split("/").last;
          }

          File f = File(dir.path+"/models/"+fileName);
          bool exists = await f.exists();
          if(!exists || await f.length() == 0){
            try{
              var bytes = await rootBundle.load(assetsName);
              final buffer = bytes.buffer;
              await f.create(recursive: true);
              await f.writeAsBytes(
                  buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
            }catch(e){
              print("不存在的assets= " + e.toString());
              continue;
            }
          }
          srcDrawableUris[fileName] = f.uri.toString();
        }
      }


      String fileName = widget.src;
      if(widget.src.contains("/")){
        fileName = widget.src.split("/").last;
      }

      File f = File(dir.path+"/models/"+fileName);
      if(await f.exists() && await f.length() > 0){
        return f.uri;
      }else{
        await f.create(recursive: true);
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
    threemodelviewer.statusController.close();
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

