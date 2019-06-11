package com.develop.zuzik.flutter_rss_reader;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

/**
 * yaroslavzozulia
 * 2019-06-11.
 */
public class HttpClient {

    interface HttpClientListener {
        void onSuccess(String response);

        void onFail(Exception exception);
    }

    void get(String url,
             Map<String, String> headers,
             HttpClientListener listener) {
        new Thread(() -> {
            try {
                HttpURLConnection urlConnection = (HttpURLConnection) new URL(url).openConnection();
                for (Map.Entry<String, String> entry : headers.entrySet()) {
                    urlConnection.setRequestProperty(entry.getKey(), entry.getValue());
                }
                try (InputStream in = new BufferedInputStream(urlConnection.getInputStream());
                     InputStreamReader reader = new InputStreamReader(in);
                     BufferedReader bufferedReader = new BufferedReader(reader)) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = bufferedReader.readLine()) != null) {
                        response.append(line);
                    }
                    listener.onSuccess(response.toString());
                } finally {
                    urlConnection.disconnect();
                }
            } catch (Exception e) {
                listener.onFail(e);
            }
        }).start();
    }
}
