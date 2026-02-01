package im.zego.zpns_flutter.internal;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import im.zego.zpns_flutter.ZegoZpnsPlugin;
import im.zego.zpns_flutter.callback.ZPNsBackgroundMessageHandler;
import im.zego.zpns_flutter.internal.utils.ContextHolder;
import im.zego.zpns_flutter.internal.utils.ZPNsLogWriter;
import im.zego.zpns_flutter.internal.utils.ZPNsMessagingBackgroundService;
import im.zego.zpns_flutter.internal.utils.ParcelableMap;
import im.zego.zpns_flutter.internal.utils.ZPNsMessagingUtils;

import java.lang.reflect.Method;
import java.util.HashMap;

import im.zego.zpns.ZPNsMessageReceiver;
import im.zego.zpns.entity.ZPNsMessage;
import im.zego.zpns.entity.ZPNsRegisterMessage;

import im.zego.zpns.enums.ZPNsConstants;
import io.flutter.plugin.common.EventChannel;

public class ZPNsPluginEventHandler extends ZPNsMessageReceiver {

    String SHOW_IN_FOREGROUND = "show_in_foreground";
    public static EventChannel.EventSink mySink = null;

    public static ZegoZpnsPlugin plugin_instance = null;

    public static Boolean isRegisterPushInvoked = false;

    public void setSink(EventChannel.EventSink sink) {
        mySink = sink;
    }

    private static final String CHANNEL = "widget.filc.hu/timetable";

    private static final String TAG = "ZPNsPluginEventHandler";

    private static ZPNsPluginEventHandler instance;

    public static ZPNsPluginEventHandler getInstance() {
        if(instance == null) {
            synchronized (ZPNsPluginEventHandler.class) {
                if(instance == null) {
                    instance = new ZPNsPluginEventHandler();
                }
            }
        }
        return instance;
    }

    @Override
    public void onThroughMessageReceived(Context context, ZPNsMessage message) {
        if (ContextHolder.getApplicationContext() == null) {
            ContextHolder.setApplicationContext(context.getApplicationContext());
        }

        ZPNsLogWriter.writeLog(TAG, "onThroughMessageReceived. title: " + message.getTitle() + ", content: " + message.getContent() + ", extras: " + message.getExtras());

        if(message.getPushSource() == ZPNsConstants.PushSource.FCM) {
            Log.i(TAG, "Receive FCM ZPNsMessage. waiting for FCMReceiver to callback event");
            ZPNsLogWriter.writeLog(TAG, "Receive FCM ZPNsMessage. waiting for FCMReceiver to callback event");
            return;
        }

        if (ZPNsMessagingUtils.isApplicationForeground(context)) {
            onThroughForegroundMessage(context, message);
        } else {
            onThroughBackgroundMessage(context, message);
        }

        detectAndCallNativeHandler(context, message);
    }

    public void onThroughForegroundMessage(Context context, ZPNsMessage message) {
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onThroughMessageReceived");
        resultMap.put("message", ZPNsConverter.cnvZPNsMessageObjectToMap(message));

        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> {
            if (mySink == null) {
                return;
            }
            mySink.success(resultMap);
        });

        Log.i(TAG, "onThroughForegroundMessage");
        ZPNsLogWriter.writeLog(TAG, "onThroughForegroundMessage. title: " + message.getTitle() + ", content: " + message.getContent() + ", extras: " + message.getExtras());
    }

    public void onThroughBackgroundMessage(Context context, ZPNsMessage message) {
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onThroughMessageReceived");
        resultMap.put("message", ZPNsConverter.cnvZPNsMessageObjectToMap(message));

        boolean useWakefulService = getUseWakeFulService(message);
        Intent onBackgroundMessageIntent =
                new Intent(context, ZPNsMessagingBackgroundService.class);
        ParcelableMap parcelableMap = new ParcelableMap(resultMap);
        onBackgroundMessageIntent.putExtra(
                ZPNsMessagingUtils.EXTRA_REMOTE_MESSAGE, parcelableMap);
        ZPNsMessagingBackgroundService.enqueueMessageProcessing(
                context, onBackgroundMessageIntent, useWakefulService);
        Log.i(TAG, "onThroughBackgroundMessage");
        ZPNsLogWriter.writeLog(TAG, "onThroughBackgroundMessage. title: " + message.getTitle() + ", content: " + message.getContent() + ", extras: " + message.getExtras());
    }

    @Override
    protected void onNotificationClicked(Context context, ZPNsMessage message) {
        Log.d("510","onNotificationClicked. title: " + message.getTitle() + ", content: " + message.getContent() + ", extras: " + message.getExtras());
        ZPNsLogWriter.writeLog(TAG, "onNotificationClicked. title: " + message.getTitle() + ", content: " + message.getContent() + ", extras: " + message.getExtras());
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("method", "onNotificationClicked");
        resultMap.put("message", ZPNsConverter.cnvZPNsMessageObjectToMap(message));
        if(plugin_instance != null){
            if(mySink != null  && isRegisterPushInvoked){
                Handler handler = new Handler(Looper.getMainLooper());
                handler.post(() -> mySink.success(resultMap));
            }else{
                ZegoZpnsPlugin.clickedResultMap = resultMap;
            }
        }else{
            ZegoZpnsPlugin.clickedResultMap = resultMap;
            Log.d("510","launchMainActivity,click map:"+resultMap.toString());
            this.launchMainActivity(context);
        }
    }

    private void launchMainActivity(Context context) {
        Intent intentLaunchMain = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        if (intentLaunchMain != null) {
            intentLaunchMain.putExtra(SHOW_IN_FOREGROUND, true);
            context.startActivity(intentLaunchMain);
        } else {
            Log.e(TAG, "Failed to get launch intent for package: " + context.getPackageName());
        }
    }

    @Override
    protected void onNotificationArrived(Context context, ZPNsMessage message) {
        if (mySink == null) {
            return;
        }
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("message", ZPNsConverter.cnvZPNsMessageObjectToMap(message));
        resultMap.put("method", "onNotificationArrived");

        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> mySink.success(resultMap));

        ZPNsLogWriter.writeLog(TAG, "onNotificationArrived. title: " + message.getTitle() + ", content: " + message.getContent() + ", extras: " + message.getExtras());
    }

    @Override
    protected void onRegistered(Context context, ZPNsRegisterMessage message) {
        Log.d("ZPNs native", "onRegistered: pushid:" + message.getCommandResult());
        if (mySink == null) {
            return;
        }
        HashMap<String, Object> resultMap = new HashMap<>();

        resultMap.put("method", "onRegistered");

        resultMap.put("message", ZPNsConverter.cnvZPNsRegisterMessageObjectToMap(message));
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(() -> mySink.success(resultMap));
        ZPNsLogWriter.writeLog(TAG, "onRegistered. code: " + message.getErrorCode() + " message: " + message.getMsg() + " commandResult: " + message.getCommandResult() + " deveiceToken: " + message.getDeviceToken());
    }

    private boolean getUseWakeFulService(ZPNsMessage message) {
        if (message.getPushSource() == ZPNsConstants.PushSource.FCM) {
            try {
                Object fcmMessage = message.getPushMessage();
                Class<?> classz = fcmMessage.getClass();
                Method method = classz.getDeclaredMethod("getPriority");
                method.setAccessible(true);
                return ((int) method.invoke(fcmMessage) == 1);
            } catch (Exception | Error ignored) {
            }
        }
        return false;
    }

    private void detectAndCallNativeHandler(Context context, ZPNsMessage message) {
        try {
            ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(),
                    PackageManager.GET_META_DATA);
            String classPath = appInfo.metaData.getString("ZPNsBackgroundMessageHandlerClassPath");
            if (classPath != null) {
                try {
                    Class<?> zpnsHandlerClass = Class.forName(classPath);
                    ZPNsBackgroundMessageHandler zpnsHandlerObj = (ZPNsBackgroundMessageHandler) zpnsHandlerClass.newInstance();
                    zpnsHandlerObj.onThroughMessageReceived(context, message);
                } catch (Exception | Error e) {
                    Log.d(TAG, "ZPNs Native Find class failure", e);
                }
            }
        } catch (Exception | Error e) {
            Log.d(TAG, "ZPNs Native Find ApplicationInfo failure", e);
        }
    }
}
