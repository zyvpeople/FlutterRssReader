package com.develop.zuzik.flutter_rss_reader;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * yaroslavzozulia
 * 2019-06-11.
 */
public final class HttpClientMethodCallHandler implements MethodChannel.MethodCallHandler {

    public static final String CHANNEL = "com.develop.zuzik.flutter_rss_reader/httpClient";

    private final HttpClient httpClient = new HttpClient();

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("get")) {
            get(methodCall, result);
        } else {
            result.notImplemented();
        }
    }

    private void get(MethodCall methodCall, MethodChannel.Result result) {
        new Thread(() -> {
            try {
                String url = methodCall.argument("url");
                Map<String, String> headers = methodCall.argument("headers");
                httpClient.get(url, headers, new HttpClient.HttpClientListener() {
                    @Override
                    public void onSuccess(String response) {
                        result.success(response);
                    }

                    @Override
                    public void onFail(Exception exception) {
                        result.error("HttpClientMethodCallHandler", exception.getMessage(), null);
                    }
                });
            } catch (Exception e) {
                result.error("HttpClientMethodCallHandler", e.getMessage(), null);
            }
        }).start();
    }
}
