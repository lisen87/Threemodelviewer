package com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.collada;

import android.content.Context;

import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.model.Object3DData;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.LoadListener;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.LoaderTask;

import java.io.IOException;
import java.net.URI;
import java.util.List;

public class ColladaLoaderTask extends LoaderTask {

    public ColladaLoaderTask(Context parent, URI uri, LoadListener callback) {
        super(parent, uri, callback);
    }

    @Override
    protected List<Object3DData> build() throws IOException {
        return new ColladaLoader().load(uri, this);
    }
}