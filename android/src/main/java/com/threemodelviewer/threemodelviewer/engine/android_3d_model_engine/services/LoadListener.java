package com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services;

import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.model.Object3DData;

public interface LoadListener {

    void onStart();

    void onProgress(String progress);

    void onLoadError(Exception ex);

    void onLoad(Object3DData data);

    void onLoadComplete();
}
