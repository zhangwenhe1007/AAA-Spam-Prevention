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
import java.util.Map;
import java.io.File; 

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.common.JSONMessageCodec;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;

import org.tensorflow.lite.support.label.Category;


public class MainActivity extends FlutterActivity {
    //private static final String AUDIO_FILE_PATH = MainActivity.class.getResource("/").getPath()+"/audio/Recording.m4a";

    // String path = "src/main/resources/audio/Recording.m4a";
    // File file = new File(path);
    // String absolutePath = file.getAbsolutePath();
    
    private String[] permissions = {Manifest.permission.READ_PHONE_STATE, Manifest.permission.PROCESS_OUTGOING_CALLS, Manifest.permission.READ_CALL_LOG, Manifest.permission.RECEIVE_SMS, Manifest.permission.READ_CONTACTS};
    private List<String> permissionList = new ArrayList<>();
    
    private static Context context;
    // SpeechRecognition recognizer;

    // static final String CHANNEL = "com.flutter.speech/speech";
    // private MethodChannel channel;

    //just created a method to get the app context
        //https://stackoverflow.com/questions/2002288/static-way-to-get-context-in-android
    public static Context getAppContext() {
        return MainActivity.context;
    }

    // @Override
    // public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    //     super.configureFlutterEngine(flutterEngine);

    //     BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
    //     channel = new MethodChannel(messenger, CHANNEL);

    //     channel.setMethodCallHandler(
    //         (call, result) -> {
    //             if (call.method.equals("Printy")) {
    //                 Map<String, String> arguments = call.arguments();
    //                 String name = arguments.get("name");

    //                 SpeechRecognition recognizer = new SpeechRecognition("deaf65c1", "43e3e7cd1af6bd370964af0dc94e7a7a");

    //                 try {
    //                     recognizer.performance(absolutePath);
    //                 } catch (Exception e) {
    //                     System.out.println(e);
    //                 }


    //                 result.success(name+"says that you have done it");
    //             } else {
    //                 result.notImplemented();
    //             }
    //         }
    //     );
    // }

    //the onCreate() function gets runned everytime the app is opened
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //GeneratedPluginRegistrant.registerWith(flutterEngine);
        
        

        // new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
        //     @Override
        //     public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        //         if (methodCall.method.equals("Printy")) {
        //             result.success("Hi From Java");
        //         }
        //     }
        // });
        

        MainActivity.context = getApplicationContext();

        TextClassifierClient test = new TextClassifierClient(MainActivity.getAppContext());

        Handler handler = new Handler() {
            public void handleMessage (final Message msg){
                 System.out.println("HAAAAAHHHHHHHH");

                 //OMG don't forget to load the model!!!
                 test.load();
                 List<Category> results = test.predicting(msg.obj.toString());
                 System.out.println("Label is: " + results.get(0).getLabel() + " message is: " + results.get(0).getDisplayName() + "Score: " + results.get(0).getScore());
                 test.unload();

                 if (msg.what == 0){              
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