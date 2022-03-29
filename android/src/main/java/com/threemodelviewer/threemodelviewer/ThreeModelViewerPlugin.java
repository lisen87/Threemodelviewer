package com.threemodelviewer.threemodelviewer;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.StandardMessageCodec;

/** ThreeModelViewerPlugin */
public class ThreeModelViewerPlugin implements FlutterPlugin {

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("3dModelViewer",new ThreeDModelViewerFactory(flutterPluginBinding.getBinaryMessenger(),StandardMessageCodec.INSTANCE));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
