// package com.example.alerte_anti_arnaqueurs;

// import com.alibaba.fastjson.JSON;
// import com.alibaba.fastjson.JSONObject;
// import com.iflytek.msp.lfasr.LfasrClient;
// import com.iflytek.msp.lfasr.exception.LfasrException;
// import com.iflytek.msp.lfasr.model.Message;
// import android.os.SystemClock;

// import java.util.HashMap;
// import java.util.Map;
// import java.util.concurrent.TimeUnit;

// /**
//  * <p>Title : SDK 调用实例</p>
//  * <p>Description : </p>
//  * <p>Date : 2020/4/20 </p>
//  *
//  * @author : hejie
//  */
// public class SpeechRecognition {
//     //音频文件路径
//     //1、绝对路径：D:\......\demo-3.0\src\main\resources\audio\lfasr.wav
//     //2、相对路径：./resources/audio/lfasr.wav
//     //3、通过classpath：;
//     final static String APP_ID;
//     final static String SECRET_KEY;

//     SpeechRecognition(String id, String key) {
//         this.id = APP_ID;
//         this.key = SECRET_KEY;
//     }

//     public static void standard(String audio) {
//         String AUDIO_FILE_PATH  = audio;

//         System.out.println(AUDIO_FILE_PATH);
//         //1、创建客户端实例
//         LfasrClient lfasrClient = LfasrClient.getInstance(APP_ID, SECRET_KEY);

//         //2、上传
//         Message task = lfasrClient.upload(AUDIO_FILE_PATH);
//         String taskId = task.getData();
//         System.out.println("转写任务 taskId：" + taskId);

//         //3、查看转写进度
//         int status = 0;
//         while (status != 9) {
//             Message message = lfasrClient.getProgress(taskId);
//             JSONObject object = JSON.parseObject(message.getData());
//             if (object ==null) throw new LfasrException(message.toString());
//             status = object.getInteger("status");
//             System.out.println(message.getData());
//             SystemClock.sleep(2000);
//         }
//         //4、获取结果
//         Message result = lfasrClient.getResult(taskId);
//         System.out.println("转写结果: \n" + result.getData());


//         //退出程序，关闭线程资源，仅在测试main方法时使用。
//         System.exit(0);
//     }

//     public static void performance(String audio) {
//         String AUDIO_FILE_PATH  = audio;

//         System.out.println(AUDIO_FILE_PATH);
//         //1、创建客户端实例, 设置性能参数
//         LfasrClient lfasrClient =
//                 LfasrClient.getInstance(
//                         APP_ID,
//                         SECRET_KEY,
//                         10, //线程池：核心线程数
//                         50, //线程池：最大线程数
//                         50, //网络：最大连接数
//                         10000, //连接超时时间
//                         30000, //响应超时时间
//                         null);
//         //LfasrClient lfasrClient = LfasrClient.getInstance(APP_ID, SECRET_KEY);


//         //2、上传
//         //2.1、设置业务参数
//         Map<String, String> param = new HashMap<>(16);
//         //语种： cn-中文（默认）;en-英文（英文不支持热词）
//         param.put("language", "en");
//         //垂直领域个性化：法院-court；教育-edu；金融-finance；医疗-medical；科技-tech
//         //param.put("pd","finance");

//         Message task = lfasrClient.upload(
//                 AUDIO_FILE_PATH
//                 , param);
//         String taskId = task.getData();
//         System.out.println("转写任务 taskId：" + taskId);


//         //3、查看转写进度
//         int status = 0;
//         while (status != 9) {
//             Message message = lfasrClient.getProgress(taskId);
//             JSONObject object = JSON.parseObject(message.getData());
//             status = object.getInteger("status");
//             System.out.println(message.getData());
//             SystemClock.sleep(2000);
//         }
//         //4、获取结果
//         Message result = lfasrClient.getResult(taskId);
//         System.out.println("转写结果: \n" + result.getData());


//         //退出程序，关闭线程资源，仅在测试main方法时使用。
//         //System.exit(0);
//     }

// }
