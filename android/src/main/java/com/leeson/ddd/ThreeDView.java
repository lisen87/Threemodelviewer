package com.leeson.ddd;

import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import com.leeson.ddd.camera.CameraController;
import com.leeson.ddd.collision.CollisionController;
import com.leeson.ddd.controller.TouchController;
import com.leeson.ddd.model.Camera;
import com.leeson.ddd.model.Object3DData;
import com.leeson.ddd.services.LoadListener;
import com.leeson.ddd.services.SceneLoader;
import com.leeson.ddd.view.ModelRenderer;
import com.leeson.ddd.view.ModelSurfaceView;
import com.leeson.ddd.util.android.ContentUtils;
import com.leeson.ddd.util.event.EventListener;

import java.net.URI;
import java.util.EventObject;
import java.util.Iterator;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

/**
 * Created by robot on 2022/3/25 14:23.
 *
 * @author robot < robot >
 */

public class ThreeDView implements PlatformView , EventListener , MethodChannel.MethodCallHandler {
    private Context context;
    /**
     * Type of model if file name has no extension (provided though content provider)
     */
    private int paramType;
    /**
     * The file to load. Passed as input parameter
     */
    private URI paramUri;
    /**
     * Background GL clear color. Default is light gray
     */
    private float[] backgroundColor = new float[]{0.0f, 0.0f, 0.0f, 0.0f};//透明
//    private float[] backgroundColor = new float[]{0.0f, 0.0f, 0.0f, 1.0f};//black
//    private float[] backgroundColor = new float[]{1f, 1f, 1.0f, 1.0f};//white

    private ModelSurfaceView gLView;
    private TouchController touchController;
    private SceneLoader scene;
    private ModelViewerGUI gui;
    private CollisionController collisionController;


    private CameraController cameraController;
    private SelfFishLinearLayout selfFishLinearLayout;

    private MethodChannel channel;
    public ThreeDView(Context context, BinaryMessenger messenger,Map<String, Object> args) {
        this.context = context;
        selfFishLinearLayout = new SelfFishLinearLayout(context);
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        selfFishLinearLayout.setLayoutParams(params);

        channel = new MethodChannel(messenger, "ThreeModelViewerPlugin");
        channel.setMethodCallHandler(this);
        init(args);
    }
    private void init(Map<String,Object> args){
        if (args != null) {
            try {
                if (args.get("src") != null) {
                    paramUri = new URI(args.get("src").toString());
                    Log.i("ModelActivity", "Params: uri '" + paramUri + "'");
                }
                if (args.get("srcDrawable") != null){
                    Map<String,String> srcDrawable = (Map<String, String>) args.get("srcDrawable");
                    ContentUtils.clearDocumentsProvided();
                    Iterator<Map.Entry<String, String>> iterator = srcDrawable.entrySet().iterator();
                    while (iterator.hasNext()){
                        Map.Entry<String, String> next = iterator.next();
                        ContentUtils.addUri(next.getKey(), Uri.parse(next.getValue()));
                    }
                }
                paramType = args.get("type") != null ? Integer.parseInt(args.get("type").toString()) : -1;

                if (args.get("backgroundColor") != null) {
                    String[] backgroundColors = args.get("backgroundColor").toString().split(" ");
                    backgroundColor[0] = Float.parseFloat(backgroundColors[0]);
                    backgroundColor[1] = Float.parseFloat(backgroundColors[1]);
                    backgroundColor[2] = Float.parseFloat(backgroundColors[2]);
                    backgroundColor[3] = Float.parseFloat(backgroundColors[3]);
                }
                if (args.get("enableTouch") != null){
                    Boolean enableTouch = (Boolean) args.get("enableTouch");
                    if (enableTouch != null){
                        selfFishLinearLayout.setIntercept(!enableTouch);
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

        }

        // Create our 3D scenario
        Log.i("ModelActivity", "Loading Scene...");
        scene = new SceneLoader(context, paramUri, paramType, gLView);


        try {
            Log.i("ModelActivity", "Loading GLSurfaceView...");
            gLView = new ModelSurfaceView(context, backgroundColor, this.scene);
//            ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            gLView.setLayoutParams(selfFishLinearLayout.getLayoutParams());
            gLView.addListener(this);
//            gLView.toggleLights();
            scene.setView(gLView);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            Log.i("ModelActivity", "Loading TouchController...");
            touchController = new TouchController(context);
            touchController.addListener(this);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            Log.i("ModelActivity", "Loading CollisionController...");
            collisionController = new CollisionController(gLView, scene);
            collisionController.addListener(scene);
            touchController.addListener(collisionController);
            touchController.addListener(scene);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            Log.i("ModelActivity", "Loading CameraController...");
            cameraController = new CameraController(scene.getCamera());
            gLView.getModelRenderer().addListener(cameraController);
            touchController.addListener(cameraController);

            scene.getCamera().setOnStopTranslate(new Camera.OnStopTranslate() {
                @Override
                public void onStop() {
                    scene.setUserHasInteracted(false);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            // TODO: finish UI implementation
            Log.i("ModelActivity", "Loading GUI...");
            gui = new ModelViewerGUI(gLView, scene);
            touchController.addListener(gui);
            gLView.addListener(gui);
            scene.addGUIObject(gui);
        } catch (Exception e) {
            e.printStackTrace();
        }

        scene.setCallback(new LoadListener() {
            @Override
            public void onStart() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onStart","");
                    }
                });
            }

            @Override
            public void onProgress(String progress) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onProgress",progress);
                    }
                });
            }

            @Override
            public void onLoadError(Exception ex) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onLoadError",ex.getMessage());
                    }
                });
            }

            @Override
            public void onLoad(Object3DData data) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onLoad",data.getName());
                    }
                });
            }

            @Override
            public void onLoadComplete() {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod("onLoadComplete","");
                    }
                });
            }
        });


        // load model
        scene.init();

    }

    private Handler handler = new Handler(Looper.getMainLooper());
    @Override
    public View getView() {
        if (selfFishLinearLayout.getChildCount() == 0){
            selfFishLinearLayout.addView(gLView);
        }
        Log.e("TAG", "getView: "+selfFishLinearLayout );
        return selfFishLinearLayout;
    }


    @Override
    public void dispose() {
        handler.removeCallbacksAndMessages(null);
        channel.setMethodCallHandler(null);
        scene.destroy();
    }

    @Override
    public boolean onEvent(EventObject event) {
        if (event instanceof ModelRenderer.ViewEvent) {
            ModelRenderer.ViewEvent viewEvent = (ModelRenderer.ViewEvent) event;
            if (viewEvent.getCode() == ModelRenderer.ViewEvent.Code.SURFACE_CHANGED) {
                touchController.setSize(viewEvent.getWidth(), viewEvent.getHeight());
                gLView.setTouchController(touchController);

                // process event in GUI
                if (gui != null) {
                    gui.setSize(viewEvent.getWidth(), viewEvent.getHeight());
                    gui.setVisible(true);
                }
            }
        }
        return true;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("enableTouch")){
            Boolean enable = call.argument("enableTouch");
            if (selfFishLinearLayout != null && enable != null){
                selfFishLinearLayout.setIntercept(!enable);
            }
            Log.e(getClass().getSimpleName(), "onMethodCall: enableTouch = "+enable );
            result.success("");
        }else if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else{
            result.notImplemented();
        }
    }
}
