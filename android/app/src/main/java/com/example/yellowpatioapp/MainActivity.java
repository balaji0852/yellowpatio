package com.example.yellowpatioapp;

// import io.flutter.app.FlutterActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.android.TransparencyMode;
import io.flutter.embedding.engine.FlutterEngine;

// import io.flutter.view.FlutterView;

import android.os.Bundle;
import android.content.Intent;
import java.util.HashMap;
import java.util.Map;
import androidx.annotation.NonNull;



import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {

  private Map<String, String> sharedData = new HashMap();


    @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    //**************deprecated api***************
    // GeneratedPluginRegistrant.registerWith(this);
    // view.enableTransparentBackground();
    // view.setZOrderMediaOverlay(true);
    // view.holder.setFormat(PixelFormat.TRANSPARENT);

    System.out.print("**********oncreate************");


     handleSendIntent(getIntent());

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "app.channel.shared.data").setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                    if (call.method.contentEquals("getSharedData")) {

                        System.out.print("**********onMethodcall************");

                        result.success(sharedData);
                        sharedData.clear();
                    }
                }
            }
        );

  }


  //creating a transparent android activity;)
  //flutter experience will be rendered over this transparent activity
  @Override public TransparencyMode getTransparencyMode(){
    return TransparencyMode.transparent;
  }


  @Override
    protected void onNewIntent(Intent intent) {
        // Handle intent when app is resumed
        super.onNewIntent(intent);
        handleSendIntent(intent);
    }

    private void handleSendIntent(Intent intent) {
        String action = intent.getAction();
        String type = intent.getType();

        // We only care about sharing intent that contain plain text
        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                sharedData.put("subject", intent.getStringExtra(Intent.EXTRA_SUBJECT));
                sharedData.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
            }
        }
    }
}
