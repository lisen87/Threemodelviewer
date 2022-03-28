package com.threemodelviewer.threemodelviewer.engine;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;

/**
 * 禁止内部所有的控件的触摸事件
 * @author Administrator
 *
 */
public class SelfFishLinearLayout extends LinearLayout {

	private boolean intercept;

	public SelfFishLinearLayout(Context context) {
		super(context);
	}

	public SelfFishLinearLayout(Context context, AttributeSet attrs) {
		this(context, attrs,0);
	}

	public SelfFishLinearLayout(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}

	public void setIntercept(boolean intercept) {
		this.intercept = intercept;
	}
	
	@Override
	public boolean onInterceptTouchEvent(MotionEvent ev) {
		return intercept;
	}
	
	public boolean isIntercept() {
		return intercept;
	}

}





