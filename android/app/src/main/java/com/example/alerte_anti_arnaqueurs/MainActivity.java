package com.example.alerte_anti_arnaqueurs;
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.Toast;

import android.content.Context;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.common.JSONMessageCodec;



public class MainActivity extends FlutterActivity {

    private String[] permissions = {Manifest.permission.READ_PHONE_STATE, Manifest.permission.PROCESS_OUTGOING_CALLS, Manifest.permission.READ_CALL_LOG, Manifest.permission.RECEIVE_SMS, Manifest.permission.READ_CONTACTS};
    private List<String> permissionList = new ArrayList<>();
    
    private static Context context;
    //just created a method to get the app context
    public static Context getAppContext() {
        return MainActivity.context;
    }

    //the onCreate() function gets runned everytime the app is opened
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        MainActivity.context = getApplicationContext();

        TextClassifierClient test = new TextClassifierClient(MainActivity.context);
        test.predicting("Hello, this is james!!!");

        Handler handler = new Handler() {
            public void handleMessage (final Message msg){
                

                if (msg.what == 0){
                    System.out.println("HAAAAAHHHHHHHH");
                    System.out.println(msg.obj.toString() + " is passed to MainActivity");
                    String phoneNumber = msg.obj.toString();
                    BasicMessageChannel MessageChannel = new BasicMessageChannel<Object>(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.appNumber/demo", StandardMessageCodec.INSTANCE);
                    MessageChannel.send(phoneNumber);
                }
                if (msg.what == 1){
                    System.out.println("A list containing SMS and Number is passed to MainActivity");

                    //After much effort, HashMap is the only type that can be passed to flutter with keys and converted into a Dart Map object

                    HashMap<Integer, String> stringValues = (HashMap<Integer, String>)msg.obj;

                    //ArrayList<String> stringValues = (ArrayList<String>)msg.obj;
                    /*String string1 = "\"" + stringValues.get(0) + "\"";
                    String string2 = "\"" + stringValues.get(1) + "\"";
                    stringValues.set(0, string1);
                    stringValues.set(1, string2); */

                    System.out.println("The following is the msg");
                    System.out.println(stringValues);
                    System.out.println(stringValues.get(1));
                    System.out.println(stringValues.get(2));

                    //Use StandardMessageCodec to pass a list to Flutter via the message channel
                    //The BasicMessageChannel is one of the three platform channels in Flutter. It is used to pass raw data coded in bytes.

                    BasicMessageChannel MessageChannel = new BasicMessageChannel<Object>(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.appSms/demo", StandardMessageCodec.INSTANCE);
                    MessageChannel.send(stringValues);

                }
                /*
                if (msg.what == 2){
                    System.out.println(msg.obj.toString() + " is passed to MainActivity");
                    String senderNumber = msg.obj.toString();
                    BasicMessageChannel MessageChannel = new BasicMessageChannel<Object>(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.appSender/demo", StandardMessageCodec.INSTANCE);
                    MessageChannel.send(senderNumber);
                } */
            }

        };

        MyBroadcastReceiver.handler = handler;

        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                permissionList.add(permission);
            } 
        }
             
        if (!permissionList.isEmpty()) {
            ActivityCompat.requestPermissions(this, permissionList.toArray(new String[permissionList.size()]), 1000);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case 1:
                System.out.println(grantResults);
                if (grantResults.length>0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {                
                    Toast.makeText(this, "Permission granted", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(this, "Permission not granted", Toast.LENGTH_SHORT).show();
                    finish();
                }
        }


    }


}