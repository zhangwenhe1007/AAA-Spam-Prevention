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

import java.io.*;
import java.util.*;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class MyBroadcastReceiver extends BroadcastReceiver {
    public static Handler handler;

    private void writeToFile(String data, String path, Context context) {
        System.out.println("Function write to file is executing...");
        try {
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(context.openFileOutput(path, Context.MODE_APPEND));
            outputStreamWriter.write(data);
            outputStreamWriter.write("\n");
            outputStreamWriter.close();
            System.out.println("Successfully added data");
        }
        catch (IOException e) {
            Log.e("Exception", "File write failed: " + e.toString());
        } 
    }

    private List readFromFile(Context context) {
        List resultList = new ArrayList();

        try {
            InputStream inputStream = context.openFileInput("config.csv");
            if ( inputStream != null ) {
                InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                String csvLine;
                StringBuilder stringBuilder = new StringBuilder();
    //Fix so that reader reads all lines
                while ( (csvLine = bufferedReader.readLine()) != null ) {
                    //stringBuilder.append("\n").append(receiveString);
                    System.out.println(csvLine);
                    String[] row = csvLine.split(",");
                    resultList.add(row);
                }
                inputStream.close();
                for (int i = 0; i < resultList.size(); i++) {
                    System.out.println(resultList.get(i).toString());
                }
                //readedFile = stringBuilder.toString();
            }
        }
        catch (FileNotFoundException e) {
            Log.e("login activity", "File not found: " + e.toString());
        } catch (IOException e) {
            Log.e("login activity", "Can not read file: " + e.toString());
        }
    
        return resultList;
    }

    @Override
    public void onReceive(Context context, Intent intent) {

        String phoneNumber = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER);

        if (!TextUtils.isEmpty(phoneNumber)) {
            Message message = new Message();
            message.what = 0;
            message.obj = phoneNumber;
            System.out.println("Number received: " + phoneNumber);
            handler.sendMessage(message);
            System.out.println("Adding number to file named config");
            writeToFile(phoneNumber, "numbers.csv", context);
            writeToFile("No current message", "numbers_message.csv", context);
            writeToFile("Y", "numbers_modify.csv", context);
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
                        System.out.println("Message received: " + msgBody + " From" + msg_from);
                        handler.sendMessage(message);
                        handler.sendMessage(number);
                        writeToFile(msgBody, "sms.csv", context);
                        writeToFile(msg_from, "sms_description.csv", context);
                        writeToFile("Y", "sms_modify.csv", context);
                        }
                    }

                } catch (Exception e) {
                    e.printStackTrace();

                }
            }
        }
    }
}
