package im.zego.zpns_flutter.internal.utils;

import android.util.Log;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class ZPNsLogWriter {

    public static String TAG = "ZPNsLogWriter";

    public static void writeLog(String tag, String log){
        boolean isLoadedZPNs = false;
        try {
            System.loadLibrary("ZPNs");
            isLoadedZPNs = true;
        } catch (UnsatisfiedLinkError e) {
            e.printStackTrace();
        }

        if(!isLoadedZPNs) {
            Log.w(TAG, "ZPNs so is not loaded, ignore");
            return;
        }

        try {
            Class<?>clazz = Class.forName("im.zego.zpns.util.ZPNsLogUtils");
            Method method = clazz.getDeclaredMethod("writeCustomLog", String.class, String.class);
            method.setAccessible(true);
            String customLog = "[" + tag + "] " + log;
            method.invoke(null, customLog, "Flutter");
            method.setAccessible(false);
        }
        catch (NoSuchMethodException e){
            e.printStackTrace();
            Log.e(TAG, "NoSuchMethodException: " + e.getMessage());
        }
        catch (InvocationTargetException e){
            String message =  e.getTargetException().getMessage();
            Log.e(TAG,"new InvocationTargetException: " + message);
        }
        catch (IllegalAccessException e){
            Log.e(TAG,"IllegalAccessException: " + e.getMessage(),null);
        }
        catch (Exception e){
            Log.d(TAG, "onMethodCall: ");
        }

    }
}
