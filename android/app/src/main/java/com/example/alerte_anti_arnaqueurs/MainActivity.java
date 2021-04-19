package com.example.alerte_anti_arnaqueurs;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;


public class MainActivity extends FlutterActivity {

    private String[] permissions = {Manifest.permission.READ_PHONE_STATE, Manifest.permission.PROCESS_OUTGOING_CALLS, Manifest.permission.READ_CALL_LOG, Manifest.permission.RECEIVE_SMS};
    private List<String> permissionList = new ArrayList<>();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Handler handler = new Handler() {
            public void handleMessage (final Message msg){
                if (msg.what == 0){
                    System.out.println(msg+"======="+msg.obj.toString());
                    String phoneNumber = msg.obj.toString();
                    BasicMessageChannel MessageChannel = new BasicMessageChannel<Object>(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.appNumber/demo", StandardMessageCodec.INSTANCE);
                    MessageChannel.send(phoneNumber);
                }
                if (msg.what == 1){
                    System.out.println(msg + msg.obj.toString());
                    String messageSms = msg.obj.toString();
                    BasicMessageChannel MessageChannel = new BasicMessageChannel<Object>(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.appSms/demo", StandardMessageCodec.INSTANCE);
                    MessageChannel.send(messageSms);
                }
                if (msg.what == 2){
                    System.out.println(msg + msg.obj.toString());
                    String senderNumber = msg.obj.toString();
                    BasicMessageChannel MessageChannel = new BasicMessageChannel<Object>(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.appSender/demo", StandardMessageCodec.INSTANCE);
                    MessageChannel.send(senderNumber);
                }
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