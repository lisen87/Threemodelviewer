package com.leeson.ddd.objects;

import android.opengl.GLES20;

import com.leeson.ddd.model.Object3DData;
import com.leeson.ddd.util.io.IOUtils;

public final class Line {

    public static Object3DData build(float[] line) {
        return new Object3DData(IOUtils.createFloatBuffer(line.length).put(line))
                .setDrawMode(GLES20.GL_LINES).setId("Line");
    }
}
