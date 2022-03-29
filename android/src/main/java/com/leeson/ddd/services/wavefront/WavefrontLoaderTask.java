package com.leeson.ddd.services.wavefront;

import android.content.Context;
import android.opengl.GLES20;

import com.leeson.ddd.model.Object3DData;
import com.leeson.ddd.services.LoadListener;
import com.leeson.ddd.services.LoaderTask;

import java.net.URI;
import java.util.List;

/**
 * Wavefront loader implementation
 *
 * @author andresoviedo
 */

public class WavefrontLoaderTask extends LoaderTask {

    public WavefrontLoaderTask(final Context parent, final URI uri, final LoadListener callback) {
        super(parent, uri, callback);
    }

    @Override
    protected List<Object3DData> build() {

        final WavefrontLoader wfl = new WavefrontLoader(GLES20.GL_TRIANGLE_FAN, this);

        super.publishProgress("Loading model...");

        final List<Object3DData> load = wfl.load(uri);

        return load;
    }

    @Override
    public void onProgress(String progress) {
        super.publishProgress(progress);
    }
}
