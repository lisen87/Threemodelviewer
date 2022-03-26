package com.threemodelviewer.threemodelviewer;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * Created by robot on 2022/3/25 14:20.
 *
 * @author robot < robot >
 */

public class ThreeDModelViewerFactory extends PlatformViewFactory {

    public ThreeDModelViewerFactory(MessageCodec<Object> createArgsCodec) {
        super(createArgsCodec);
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new ThreeDView(context, (Map<String, Object>) args);
    }
}
