package com.example.alerte_anti_arnaqueurs;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.telephony.SmsMessage;
import android.text.TextUtils;

import java.io.*;
import java.util.*;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class MyBroadcastReceiver extends BroadcastReceiver {
    public static Handler handler;

    @Override
    public void onReceive(Context context, Intent intent) {

        String phoneNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER);

        if (!TextUtils.isEmpty(phoneNumber)) {
            Message message = new Message();
            message.what = 0;
            message.obj = phoneNumber;
            System.out.println("Number received: " + phoneNumber);
            System.out.println(message);
            handler.sendMessage(message);
            }
        
        if (intent.getAction().equals("android.provider.Telephony.SMS_RECEIVED")) {
            Bundle bundle = intent.getExtras();
            SmsMessage[] msgs = null;
            String msg_from;
            String msgBody;
            if (bundle != null) {
                try {
                    Object[] pdus = (Object[]) bundle.get("pdus");
                    msgs = new SmsMessage[pdus.length];
                    for (int i = 0; i < msgs.length; i++) {
                        msgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
                        msg_from = msgs[i].getOriginatingAddress();
                        msgBody = msgs[i].getMessageBody();

                    if (!TextUtils.isEmpty(msgBody) && !TextUtils.isEmpty(msg_from)) {
                        Message message = new Message();
                        Message number = new Message();
                        message.what = 1;
                        message.obj = msgBody;
                        number.what = 2;
                        number.obj = msg_from;
                        System.out.println("Message received: " + msgBody + "From" + msg_from);
                        System.out.println(msgBody + msg_from);
                        handler.sendMessage(message);
                        handler.sendMessage(number);
                        }
                    }

                } catch (Exception e) {
                    e.printStackTrace();

                }
            }
        }
    }
}
