package com.leeson.ddd.services;

import android.content.Context;
import android.os.AsyncTask;

import com.leeson.ddd.model.Object3DData;

import java.net.URI;
import java.util.List;

/**
 * This component allows loading the model without blocking the UI.
 *
 * @author andresoviedo
 */
public abstract class LoaderTask extends AsyncTask<Void, String, List<Object3DData>> implements LoadListener {

	/**
	 * URL to the 3D model
	 */
	protected final URI uri;
	/**
	 * Callback to notify of events
	 */
	private final LoadListener callback;

	/**
	 * Build a new progress dialog for loading the data model asynchronously
     * @param uri        the URL pointing to the 3d model
     *
	 */
	public LoaderTask(Context parent, URI uri, LoadListener callback) {
		this.uri = uri;
		this.callback = callback; }


	@Override
	protected void onPreExecute() {
		super.onPreExecute();
	}



	@Override
	protected List<Object3DData> doInBackground(Void... params) {
		try {
		    callback.onStart();
			List<Object3DData> data = build();
            callback.onLoadComplete();
			return  data;
		} catch (Exception ex) {
            callback.onLoadError(ex);
			return null;
		}
	}

	protected abstract List<Object3DData> build() throws Exception;

	public void onLoad(Object3DData data){
		callback.onLoad(data);
	}

	@Override
	protected void onProgressUpdate(String... values) {
		super.onProgressUpdate(values);
	}

	@Override
	protected void onPostExecute(List<Object3DData> data) {
		super.onPostExecute(data);
	}

	@Override
	public void onStart() {
		callback.onStart();
	}

	@Override
	public void onProgress(String progress) {
		super.publishProgress(progress);
		callback.onProgress(progress);
	}

	@Override
	public void onLoadError(Exception ex) {
		callback.onLoadError(ex);
	}

	@Override
	public void onLoadComplete() {
		callback.onLoadComplete();
	}
}