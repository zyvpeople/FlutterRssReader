package com.develop.zuzik.flutter_rss_reader;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), HttpClientMethodCallHandler.CHANNEL)
                .setMethodCallHandler(new HttpClientMethodCallHandler());
        new MethodChannel(getFlutterView(), ShareMethodCallHandler.CHANNEL)
                .setMethodCallHandler(new ShareMethodCallHandler(this));
    }
}
