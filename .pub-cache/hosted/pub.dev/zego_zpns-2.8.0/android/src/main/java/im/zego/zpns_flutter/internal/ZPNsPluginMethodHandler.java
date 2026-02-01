package im.zego.zpns_flutter.internal;

import android.annotation.SuppressLint;
import android.app.Application;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;

import im.zego.zpns_flutter.internal.utils.ContextHolder;
import im.zego.zpns_flutter.internal.utils.ZPNsLogWriter;
import im.zego.zpns_flutter.internal.utils.ZPNsMessagingBackgroundService;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import im.zego.zpns.ZPNsManager;
import im.zego.zpns.util.ZPNsConfig;
import im.zego.zpns_flutter.internal.utils.ZPNsMessagingUtils;
import io.flutter.embedding.engine.FlutterShellArgs;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;


public class ZPNsPluginMethodHandler {
    static int notificationID = 1;
    public static String TAG = "ZPNsPluginMethodHandler";

    public static void getVersion(MethodCall call, Result result){
        result.success(ZPNsManager.getInstance().getVersion());
    }

    public static void registerPush(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding){

        Application application = (Application) binding.getApplicationContext();
        ZPNsManager.getInstance().registerPush(application);


     //   ZPNsRegisterMessage.Builder builder = ZPNsRegisterMessage.builder().
     //           errorCode(ZPNsErrorCode.SUCCESS)
     //           .pushSource(ZPNsConstants.PushSource.HUAWEI).commandResult("token");
     //   ZPNsBroadcastDispatcher.create(application).commandDispatch(builder.build());
        result.success(null);
        ZPNsLogWriter.writeLog(TAG, "[API] registerPush");
    }

    public static void getPushConfig(MethodCall call, Result result){

        HashMap<String,Object> resultMap = new HashMap<>();

        HashMap<String,Object> configMap = ZPNsConverter.cnvZPNsConfigObjectToMap(ZPNsManager.getInstance().getPushConfig());

        resultMap.put("config",configMap);

        result.success(resultMap);
    }

    public static void setPushConfig(MethodCall call,Result result){
        ZPNsConfig zpnsConfig = ZPNsConverter.cnvZPNsConfigMapToObject(Objects.requireNonNull(call.argument("config")));
        ZPNsManager.setPushConfig(zpnsConfig);
    }

    public static void enableDebug(MethodCall call,Result result){
       Boolean enableDebug = call.argument("debug");
       ZPNsManager.enableDebug(enableDebug);
    }

    public static void applyNotificationPermission(MethodCall call,Result result){
        result.success(null);
    }


    public static void unregisterPush(MethodCall call,Result result){
        ZPNsManager.getInstance().unregisterPush();
        result.success(null);
        ZPNsLogWriter.writeLog(TAG, "[API] unregisterPush");
    }

    public static void addLocalNotification(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding){
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            Context context = ContextHolder.getApplicationContext();
            if(notificationID == 0 && context!= null){
                SharedPreferences sharedPref = context.getSharedPreferences(ZPNsMessagingUtils.SHARED_PREFERENCES_KEY,Context.MODE_PRIVATE);
                notificationID = sharedPref.getInt("zegoLocalNotificationIdSequence",0);
            }
            int currentNotificationID = ++notificationID;
            if(context != null){
                SharedPreferences sharedPref = context.getSharedPreferences(ZPNsMessagingUtils.SHARED_PREFERENCES_KEY,Context.MODE_PRIVATE);
                SharedPreferences.Editor editor = sharedPref.edit();
                editor.putInt("zegoLocalNotificationIdSequence",currentNotificationID);
            }

            Application application = (Application) binding.getApplicationContext();
            NotificationManager manager = (NotificationManager) application.getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);
            Map<String,String> messageMap = call.argument("message");
            String title = messageMap.get("title");
            String content = messageMap.get("content");
            String payload = messageMap.get("payload");
            String channelID = messageMap.get("channelID");
            String androidSound = messageMap.get("androidSound");
           // int icon = application.getResources().getIdentifier("ic_launcher","mipmap",application.getPackageName());
            int iconId = application.getApplicationInfo().icon;
            Bitmap bitmap = BitmapFactory.decodeResource(application.getApplicationContext().getResources(), iconId);

            Notification.Builder builder = new Notification.Builder(application.getApplicationContext());
            builder.setAutoCancel(true);
            builder.setContentTitle(title);
            builder.setContentText(content);
            builder.setSmallIcon(iconId);
            builder.setLargeIcon(bitmap);
//            builder.setTicker("dwa");
            if(channelID != null && !channelID.equals("") && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O){
                builder.setChannelId(channelID);
            }
            Intent intent = new Intent();
            if(payload != null && !payload.equals("")){
                intent.putExtra("payload",payload);
            }
            @SuppressLint("UnspecifiedImmutableFlag") PendingIntent pendingIntent;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                pendingIntent = PendingIntent.getActivity(application, 0, intent, PendingIntent.FLAG_IMMUTABLE);
            } else {
                pendingIntent = PendingIntent.getActivity(application, 0, intent, PendingIntent.FLAG_ONE_SHOT);
            }
            builder.setContentIntent(pendingIntent);
            builder.setAutoCancel(true);
            if(channelID != null && !channelID.equals("") && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O){
                builder.setChannelId(channelID);
            }
            if(androidSound != null && !androidSound.equals("")){
                Uri sound = Uri.parse("android.resource://" + application.getPackageName() + androidSound);
                builder.setSound(sound);
            }else{
                builder.setDefaults(Notification.DEFAULT_SOUND);
            }
            manager.notify(currentNotificationID,builder.build());
        }
        result.success(null);
    }

    public static void createNotificationChannel(MethodCall call, Result result, FlutterPlugin.FlutterPluginBinding binding){

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            Application application = (Application) binding.getApplicationContext();
            HashMap<String,Object> channelMap = Objects.requireNonNull(call.argument("channel"));
            String channelID = (String) Objects.requireNonNull(channelMap.get("channelID"));
            String channelName = (String) Objects.requireNonNull(channelMap.get("channelName"));
            String androidSound = (String) Objects.requireNonNull(channelMap.get("androidSound"));
            NotificationChannel channel = new NotificationChannel(channelID, channelName, NotificationManager.IMPORTANCE_HIGH);
            Uri sound = Uri.parse("android.resource://" + application.getPackageName() + androidSound);
            channel.setSound(sound, null);
            NotificationManager notificationManager = application.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
        result.success(null);
    }

    public static void storeBackgroundHandle(MethodCall call, Result result){
        Map<String, Object> arguments = ((Map<String, Object>) call.arguments);
        long pluginCallbackHandle = 0;
        long userCallbackHandle = 0;

        Object arg1 = arguments.get("pluginCallbackHandle");
        Object arg2 = arguments.get("userCallbackHandle");

        if (arg1 instanceof Long) {
            pluginCallbackHandle = (Long) arg1;
        } else {
            pluginCallbackHandle = Long.valueOf((Integer) arg1);
        }

        if (arg2 instanceof Long) {
            userCallbackHandle = (Long) arg2;
        } else {
            userCallbackHandle = Long.valueOf((Integer) arg2);
        }

        FlutterShellArgs shellArgs = null;
//        if (mainActivity != null) {
//            // Supports both Flutter Activity types:
//            //    io.flutter.embedding.android.FlutterFragmentActivity
//            //    io.flutter.embedding.android.FlutterActivity
//            // We could use `getFlutterShellArgs()` but this is only available on `FlutterActivity`.
//            shellArgs = FlutterShellArgs.fromIntent(mainActivity.getIntent());
//        }

        ZPNsMessagingBackgroundService.setCallbackDispatcher(pluginCallbackHandle);
        ZPNsMessagingBackgroundService.setUserCallbackHandle(userCallbackHandle);
        ZPNsMessagingBackgroundService.startBackgroundIsolate(
                pluginCallbackHandle, shellArgs);
    }

    public static void setLocalBadge(MethodCall call, Result result,FlutterPlugin.FlutterPluginBinding binding){
        int badge = call.argument("badge");
        ZPNsManager.getInstance().setApplicationIconBadgeNumber(binding.getApplicationContext(),badge);
    }
}
