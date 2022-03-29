package com.leeson.ddd.services;

import com.leeson.ddd.model.Object3DData;

public interface LoadListener {

    void onStart();

    void onProgress(String progress);

    void onLoadError(Exception ex);

    void onLoad(Object3DData data);

    void onLoadComplete();
}
