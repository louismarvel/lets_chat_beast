// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package im.zego.zpns_flutter.internal.utils;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterShellArgs;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public class ZPNsMessagingBackgroundService extends JobIntentService {
  private static final String TAG = "ZPNsFlutterBackgroundService";

  private static final List<Intent> messagingQueue =
      Collections.synchronizedList(new LinkedList<>());

  /** Background Dart execution context. */
  private static ZPNsMessagingBackgroundExecutor flutterBackgroundExecutor;

  /**
   * Schedule the message to be handled by the {@link ZPNsMessagingBackgroundService}.
   */
  public static void enqueueMessageProcessing(Context context, Intent messageIntent, boolean useWakefulService) {
    Log.d(TAG, "ZPNs Native enqueueMessageProcessing enqueueWork");
    ZPNsLogWriter.writeLog(TAG, "enqueueMessageProcessing. jobID: " + ZPNsMessagingUtils.JOB_ID + ", is use wakeful service: " + useWakefulService);
    enqueueWork(
        context,
        ZPNsMessagingBackgroundService.class,
        ZPNsMessagingUtils.JOB_ID,
        messageIntent,
            useWakefulService);
  }

  /**
   * Starts the background isolate for the {@link ZPNsMessagingBackgroundService}.
   *
   * <p>Preconditions:
   *
   * <ul>
   *   <li>The given {@code callbackHandle} must correspond to a registered Dart callback. If the
   *       handle does not resolve to a Dart callback then this method does nothing.
   *   <li>A static {@link #pluginRegistrantCallback} must exist, otherwise a {@link
   *       PluginRegistrantException} will be thrown.
   * </ul>
   */
  @SuppressWarnings("JavadocReference")
  public static void startBackgroundIsolate(long callbackHandle, FlutterShellArgs shellArgs) {
     Log.d(TAG, "startBackgroundIsolate Returning...");
    if (flutterBackgroundExecutor != null) {
      Log.w(TAG, "Attempted to start a duplicate background isolate. Returning...");
      return;
    }
    flutterBackgroundExecutor = new ZPNsMessagingBackgroundExecutor();
    flutterBackgroundExecutor.startBackgroundIsolate(callbackHandle, shellArgs);

    Log.i(TAG, "ZPNsBackgroundService start executor");
    ZPNsLogWriter.writeLog(TAG, "start background isolate executor");
  }


  /* package */
  static void onInitialized() {
    Log.i(TAG, "ZPNsBackgroundService init");
    ZPNsLogWriter.writeLog(TAG, "BackgroundService onInitialized");
    synchronized (messagingQueue) {
      // Handle all the message events received before the Dart isolate was
      // initialized, then clear the queue.
      for (Intent intent : messagingQueue) {
        flutterBackgroundExecutor.executeDartCallbackInBackgroundIsolate(intent, null);
      }
      messagingQueue.clear();
    }
    Log.i(TAG, "ZPNsBackgroundService success");
  }

  /**
   * Sets the Dart callback handle for the Dart method that is responsible for initializing the
   * background Dart isolate, preparing it to receive Dart callback tasks requests.
   */
  public static void setCallbackDispatcher(long callbackHandle) {
    ZPNsMessagingBackgroundExecutor.setCallbackDispatcher(callbackHandle);
  }

  /**
   * Sets the Dart callback handle for the users Dart handler that is responsible for handling
   * messaging events in the background.
   */
  public static void setUserCallbackHandle(long callbackHandle) {
    ZPNsMessagingBackgroundExecutor.setUserCallbackHandle(callbackHandle);
  }

  @Override
  public void onCreate() {
    super.onCreate();
    Context context = getApplicationContext();
    Log.d(TAG, "ZPNsBackgroundService create context: "+context);
    ZPNsLogWriter.writeLog(TAG, "BackgroundService onCreate. context: " + context);

    if (context != null) {
      ContextHolder.setApplicationContext(context);
    }

    if (flutterBackgroundExecutor == null) {
      flutterBackgroundExecutor = new ZPNsMessagingBackgroundExecutor();
    }
    flutterBackgroundExecutor.startBackgroundIsolate();

    Log.d(TAG, "ZPNsBackgroundService create success");
  }

  /**
   * Executes a Dart callback, as specified within the incoming {@code intent}.
   *
   * <p>Invoked by our {@link JobIntentService} superclass after a call to {@link
   * JobIntentService#enqueueWork(Context, Class, int, Intent, boolean);}.
   *
   * <p>If there are no pre-existing callback execution requests, other than the incoming {@code
   * intent}, then the desired Dart callback is invoked immediately.
   *
   * <p>If there are any pre-existing callback requests that have yet to be executed, the incoming
   * {@code intent} is added to the {@link #messagingQueue} to be invoked later, after all
   * pre-existing callbacks have been executed.
   */
  @Override
  protected void onHandleWork(@NonNull final Intent intent) {
    if (!flutterBackgroundExecutor.isDartBackgroundHandlerRegistered()) {
      Log.w(
          TAG,
          "A background message could not be handled in Dart as no onBackgroundMessage handler has been registered.");
      ZPNsLogWriter.writeLog(TAG, "A background message could not be handled in Dart as no onBackgroundMessage handler has been registered");
      return;
    }

    Log.d(TAG, "ZPNsBackgroundService handle work");
    ZPNsLogWriter.writeLog(TAG, "BackgroundService handle work.");

    // If we're in the middle of processing queued messages, add the incoming
    // intent to the queue and return.
    synchronized (messagingQueue) {
      if (flutterBackgroundExecutor.isNotRunning()) {
        Log.i(TAG, "Service has not yet started, messages will be queued.");
        ZPNsLogWriter.writeLog(TAG, "Service has not yet started, messages will be queued.");
        messagingQueue.add(intent);
        return;
      }
    }

    // There were no pre-existing callback requests. Execute the callback
    // specified by the incoming intent.
    final CountDownLatch latch = new CountDownLatch(1);
    Log.d(TAG, "ZPNsBackgroundService new handle");
    new Handler(getMainLooper())
        .post(
            () -> flutterBackgroundExecutor.executeDartCallbackInBackgroundIsolate(intent, latch));

    try {
      latch.await();
      ZPNsLogWriter.writeLog(TAG, "Service handle work success.");
    } catch (InterruptedException ex) {
      Log.i(TAG, "Exception waiting to execute Dart callback", ex);
    }
  }
}
