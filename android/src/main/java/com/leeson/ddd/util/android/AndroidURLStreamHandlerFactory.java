package com.leeson.ddd.util.android;

import java.net.URLStreamHandler;
import java.net.URLStreamHandlerFactory;

public class AndroidURLStreamHandlerFactory implements URLStreamHandlerFactory {

    @Override
    public URLStreamHandler createURLStreamHandler(String protocol) {
        if ("android".equals(protocol)) {
            return new com.leeson.ddd.util.android.assets.Handler();
        } else if ("content".equals(protocol)){
            return new com.leeson.ddd.util.android.content.Handler();
        }
        return null;
    }
}
