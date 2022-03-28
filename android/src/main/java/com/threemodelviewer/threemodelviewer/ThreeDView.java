package com.threemodelviewer.threemodelviewer;

import android.content.Context;
import android.net.Uri;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import com.threemodelviewer.threemodelviewer.engine.ModelViewerGUI;
import com.threemodelviewer.threemodelviewer.engine.SelfFishLinearLayout;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.camera.CameraController;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.collision.CollisionController;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.controller.TouchController;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.model.Camera;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.SceneLoader;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.view.ModelRenderer;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.view.ModelSurfaceView;
import com.threemodelviewer.threemodelviewer.engine.util.android.ContentUtils;
import com.threemodelviewer.threemodelviewer.engine.util.event.EventListener;

import java.net.URI;
import java.util.EventObject;
import java.util.Iterator;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * Created by robot on 2022/3/25 14:23.
 *
 * @author robot < robot >
 */

public class ThreeDView implements PlatformView , EventListener {
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
    public ThreeDView(Context context, Map<String,Object> args) {
        this.context = context;
        selfFishLinearLayout = new SelfFishLinearLayout(context);
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        selfFishLinearLayout.setLayoutParams(params);
        init(args);
    }
    private void init(Map<String,Object> args){
        boolean enableTouch = false;
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
                    enableTouch = (boolean) args.get("enableTouch");
                    selfFishLinearLayout.setIntercept(!enableTouch);
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
        // load model
        scene.init();
    }

    @Override
    public View getView() {
        if (selfFishLinearLayout.getChildCount() == 0){
            selfFishLinearLayout.addView(gLView);
        }
        return selfFishLinearLayout;
    }


    @Override
    public void dispose() {
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
}
