package com.leeson.ddd.services.collada;

import android.content.Context;

import com.leeson.ddd.model.Object3DData;
import com.leeson.ddd.services.LoadListener;
import com.leeson.ddd.services.LoaderTask;

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