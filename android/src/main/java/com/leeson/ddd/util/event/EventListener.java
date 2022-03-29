package com.leeson.ddd.util.event;

import java.util.EventObject;

public interface EventListener {
    boolean onEvent(EventObject event);
}
