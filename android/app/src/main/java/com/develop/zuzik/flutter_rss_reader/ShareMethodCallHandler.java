package com.develop.zuzik.flutter_rss_reader;

import android.app.Activity;
import android.content.Intent;

import java.lang.ref.WeakReference;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * yaroslavzozulia
 * 2019-06-11.
 */
public final class ShareMethodCallHandler implements MethodChannel.MethodCallHandler {

    public static final String CHANNEL = "com.develop.zuzik.flutter_rss_reader/share";

    private final WeakReference<Activity> activity;

    public ShareMethodCallHandler(Activity activity) {
        this.activity = new WeakReference<>(activity);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("url")) {
            get(methodCall, result);
        } else {
            result.notImplemented();
        }
    }

    private void get(MethodCall methodCall, MethodChannel.Result result) {
        try {
            Activity activity = this.activity.get();
            if (activity != null) {
                String url = methodCall.argument("url");
                Intent share = new Intent(android.content.Intent.ACTION_SEND);
                share.setType("text/plain");
                share.putExtra(Intent.EXTRA_SUBJECT, "URL");
                share.putExtra(Intent.EXTRA_TEXT, url);
                activity.startActivity(Intent.createChooser(share, "Share URL"));
                result.success(null);
            } else {
                result.error("HttpClientMethodHandler", "Can't share url", null);
            }
        } catch (Exception e) {
            result.error("HttpClientMethodCallHandler", e.getMessage(), null);
        }
    }
}
