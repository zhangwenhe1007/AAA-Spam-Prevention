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
import android.util.Log;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.HttpURLConnection;

import java.io.InputStream;
import java.io.Reader;

import java.net.*;
import java.nio.charset.Charset;

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


//CHANGED THE SMS INTO ONE SINGLE MESSAGE CHANNEL. PUT THE NUMBER AND THE SMS TOGETHER

                    if (!TextUtils.isEmpty(msgBody) && !TextUtils.isEmpty(msg_from)) {

                        //Create an arrayList containing both the sms and the number of the sender
                        //ArrayList<String> messages = new ArrayList<String>();

                        HashMap<Integer, String> messages = new HashMap<Integer, String>();
                        messages.put(1,msgBody);
                        messages.put(2,msg_from);
                        Message message = new Message();
                        message.what = 1;
                        message.obj = messages;
                        System.out.println("Message received: " + msgBody + " From" + msg_from);
                        handler.sendMessage(message);
                        }
                    }

                } catch (Exception e) {
                    e.printStackTrace();

                }
            }
        }
    }
}
