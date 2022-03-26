import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Created by robot on 2022/3/26 12:52.
/// @author robot < robot >

class ThreeView extends StatefulWidget {
  final Function(int type,int progress)? loadCallback;
  final String src;
  final ModelType modelType;
  final Widget? placeholder;
  const ThreeView({Key? key,required this.src,required this.modelType,this.placeholder,this.loadCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ThreeViewState();
  }
}


class ThreeViewState extends State<ThreeView> {
  final String viewType = "3dModelViewer";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uri>(
      future: getSrcByModelType(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<Uri> snapshot) {
        print(snapshot.data);
        if (snapshot.data != null && snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data);
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
              },
              creationParamsCodec: const StandardMessageCodec(),
            );
          }else if(Platform.isIOS){
            return UiKitView(
              viewType: viewType,
              creationParams: <String, dynamic>{
                'src': snapshot.data,
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
  ///返回文件路径 uri
  Future<Uri> getSrcByModelType() async {

    if(widget.modelType == ModelType.assets){
      ///assets
      String fileName = widget.src;
      if(widget.src.contains("/")){
        fileName = widget.src.split("/").last;
      }

      var bytes = await rootBundle.load(widget.src);
      Directory dir = await getTemporaryDirectory();
      final buffer = bytes.buffer;
      File f = File(dir.path+"/models/"+fileName);
      if(await f.exists() && await f.length() > 0){
        return f.uri;
      }else{
        f.create(recursive: true);
        print(" =fileName= "+f.path);
        await f.writeAsBytes(
            buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        print(" === "+f.path);
        return f.uri;
      }

    }else if(widget.modelType == ModelType.http){
      _cancelToken = CancelToken();
      String fileName = widget.src.split("/").last;
      Dio dio = Dio();
      String savePath = (await getTemporaryDirectory()).path +"/models/"+fileName ;
      Response response = await dio.download(widget.src, savePath, cancelToken: _cancelToken);

      if(response.statusCode == 200){
        return Uri.file(savePath);
      }else{
        return Uri.parse(response.statusCode.toString());
      }
    }else{
      return Uri.parse(widget.src);
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
