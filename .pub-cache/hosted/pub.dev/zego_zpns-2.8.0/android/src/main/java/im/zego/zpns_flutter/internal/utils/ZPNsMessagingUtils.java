package im.zego.zpns_flutter.internal.utils;

import android.app.ActivityManager;
import android.app.KeyguardManager;
import android.content.Context;

import java.util.List;



public class ZPNsMessagingUtils {
    public static final String EXTRA_REMOTE_MESSAGE = "notification";
    static final int JOB_ID = 10000;
    public static final String SHARED_PREFERENCES_KEY = "im.zego.zpns.callback";
    public static boolean isApplicationForeground(Context context) {
        KeyguardManager keyguardManager =
                (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);

        if (keyguardManager != null && keyguardManager.isKeyguardLocked()) {
            return false;
        }

        ActivityManager activityManager =
                (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        if (activityManager == null) return false;

        List<ActivityManager.RunningAppProcessInfo> appProcesses =
                activityManager.getRunningAppProcesses();
        if (appProcesses == null) return false;

        final String packageName = context.getPackageName();
        for (ActivityManager.RunningAppProcessInfo appProcess : appProcesses) {
            if (appProcess.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND
                    && appProcess.processName.equals(packageName)) {
                return true;
            }
        }


        return false;
    }
}
