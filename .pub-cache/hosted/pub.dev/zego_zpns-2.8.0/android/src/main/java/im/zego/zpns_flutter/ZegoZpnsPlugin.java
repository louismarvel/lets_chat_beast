package im.zego.zpns_flutter;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import im.zego.zpns_flutter.internal.ZPNsPluginEventHandler;
import im.zego.zpns_flutter.internal.utils.ContextHolder;
import im.zego.zpns_flutter.internal.utils.ZPNsMessagingUtils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.EventChannel;

/** ZegoZpnsPlugin */
public class ZegoZpnsPlugin implements FlutterPlugin, MethodCallHandler,EventChannel.StreamHandler{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  static public HashMap<String, Object> clickedResultMap;

  private MethodChannel methodchannel;

  private final Class<?> manager;

  private final HashMap<String, Method> methodHashMap = new HashMap<>();

  private FlutterPluginBinding binding = null;

  public ZegoZpnsPlugin() {

    try{
      this.manager = Class.forName("im.zego.zpns_flutter.internal.ZPNsPluginMethodHandler");
    }catch (ClassNotFoundException e){
      throw new RuntimeException(e);
    }
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodchannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "zego_zpns");
    methodchannel.setMethodCallHandler(this);
    EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(),"zpns_event_handler");
    eventChannel.setStreamHandler(this);

    this.binding = flutterPluginBinding;

    ZPNsPluginEventHandler.plugin_instance = this;
    Log.i("ZPNsPluginManager", "attach flutter engine");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodchannel.setMethodCallHandler(null);
    ZPNsPluginEventHandler.plugin_instance = null;
    ZPNsPluginEventHandler.isRegisterPushInvoked = false;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }
    if(ContextHolder.getApplicationContext() == null){
      ContextHolder.setApplicationContext(this.binding.getApplicationContext());
    }
    try{
      Method method = methodHashMap.get(call.method);
      if(method == null){
        if(call.method.equals("registerPush")){
          method = this.manager.getMethod(call.method,MethodCall.class,Result.class,FlutterPluginBinding.class);
        }else if(call.method.equals("createNotificationChannel")){
          method = this.manager.getMethod(call.method,MethodCall.class,Result.class,FlutterPluginBinding.class);
        }else if(call.method.equals("addLocalNotification")){
          method = this.manager.getMethod(call.method,MethodCall.class,Result.class,FlutterPluginBinding.class);
        } else if (call.method.equals("setLocalBadge")) {
          method = this.manager.getMethod(call.method,MethodCall.class,Result.class,FlutterPluginBinding.class);
        } else {
          method = this.manager.getMethod(call.method, MethodCall.class, Result.class);
        }
        methodHashMap.put(call.method, method);
      }
      if(call.method.equals(("registerPush"))){
        ZPNsPluginEventHandler.isRegisterPushInvoked = true;
        if(clickedResultMap != null && ZPNsPluginEventHandler.mySink != null){
          Handler handler = new Handler(Looper.getMainLooper());
          handler.post(() -> {
            if (clickedResultMap != null && ZPNsPluginEventHandler.mySink !=null) {
              ZPNsPluginEventHandler.mySink.success(clickedResultMap);
              clickedResultMap = null;
            }
          });


        }
        method.invoke(null,call,result,this.binding);
      }
      else if(call.method.equals("createNotificationChannel")){
        method.invoke(null,call,result,this.binding);
      }
      else if(call.method.equals("addLocalNotification")){
        method.invoke(null,call,result,this.binding);
      }
      else {
        method.invoke(null,call, result);
      }
    }
    catch (NoSuchMethodException e){
      result.notImplemented();
    }
    catch (InvocationTargetException e){
      String message =  e.getTargetException().getMessage();
      result.error("1","InvocationTargetException:"+message,null);
    }
    catch (IllegalAccessException e){
      result.error("1","IllegalAccessException:"+e.getMessage(),null);
    }
    catch (Exception e){
      Log.d("510", "onMethodCall: ");
    }
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    ZPNsPluginEventHandler.getInstance().setSink(events);
    Log.i("ZPNsPluginManager", "set sink");
  }

  @Override
  public void onCancel(Object arguments) {
    ZPNsPluginEventHandler.getInstance().setSink(null);
    Log.i("ZPNsPluginManager", "remove sink");
  }
}
