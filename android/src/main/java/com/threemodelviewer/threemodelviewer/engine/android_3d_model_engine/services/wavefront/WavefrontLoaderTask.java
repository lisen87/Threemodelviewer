package com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.wavefront;

import android.content.Context;
import android.opengl.GLES20;

import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.model.Object3DData;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.LoadListener;
import com.threemodelviewer.threemodelviewer.engine.android_3d_model_engine.services.LoaderTask;

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
