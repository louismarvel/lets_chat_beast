package im.zego.zpns_flutter.internal;


import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;


import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import im.zego.zpns.entity.ZPNsMessage;
import im.zego.zpns.entity.ZPNsRegisterMessage;
import im.zego.zpns.util.ZPNsConfig;


public class ZPNsConverter {
    static public Map<String,Object> convertExtras(String extras) {
        Map<String, Object> res = null;
        try {
            Gson gson = new Gson();
            res = gson.fromJson(extras, new TypeToken<Map<String, Object>>() {
            }.getType());
        } catch (JsonSyntaxException ignored) {
        }
        return res;
    }

    static public ZPNsConfig cnvZPNsConfigMapToObject(HashMap<String,Object> configMap){
        ZPNsConfig zpnsConfig = new ZPNsConfig();

        zpnsConfig.enableHWPush = (Boolean) (Objects.requireNonNull(configMap.get("hw_push")));
        zpnsConfig.enableMiPush = (Boolean) (Objects.requireNonNull(configMap.get("xiaomi_push")));
        zpnsConfig.enableVivoPush = (Boolean) (Objects.requireNonNull(configMap.get("vivo_push")));
        zpnsConfig.enableOppoPush = (Boolean) (Objects.requireNonNull(configMap.get("oppo_push")));
        zpnsConfig.enableFCMPush = (Boolean) (Objects.requireNonNull(configMap.get("fcm_push")));
        zpnsConfig.miAppID = (String) (Objects.requireNonNull(configMap.get("miAppID")));
        zpnsConfig.miAppKey = (String) (Objects.requireNonNull(configMap.get("miAppKEY")));
        zpnsConfig.oppoAppID = (String) (Objects.requireNonNull(configMap.get("oppoAppID")));
        zpnsConfig.oppoAppSecret = (String) (Objects.requireNonNull(configMap.get("oppoAppSecret")));
        zpnsConfig.oppoAppKey = (String) (Objects.requireNonNull(configMap.get("oppoAppKey")));
        zpnsConfig.vivoAppID = (String) (Objects.requireNonNull(configMap.get("vivoAppID")));
        zpnsConfig.vivoAppKey = (String) (Objects.requireNonNull(configMap.get("vivoAppKey")));
        zpnsConfig.hwAppID = (String) (Objects.requireNonNull(configMap.get("hwAppID")));
        zpnsConfig.setAppType((int)(Objects.requireNonNull(configMap.get("appType"))));
        zpnsConfig.enableHwBadge((Boolean) Objects.requireNonNull(configMap.get("enableHwBadge")));
        return zpnsConfig;
    }

    static public HashMap<String,Object> cnvZPNsConfigObjectToMap(ZPNsConfig zpnsConfig){
        HashMap<String,Object> zpnsConfigMap = new HashMap<>();
        zpnsConfigMap.put("hw_push",zpnsConfig.enableHWPush);
        zpnsConfigMap.put("xiaomi_push",zpnsConfig.enableMiPush);
        zpnsConfigMap.put("vivo_push",zpnsConfig.enableVivoPush);
        zpnsConfigMap.put("oppo_push",zpnsConfig.enableOppoPush);
        zpnsConfigMap.put("fcm_push",zpnsConfig.enableFCMPush);
        zpnsConfigMap.put("miAppID",zpnsConfig.miAppID);
        zpnsConfigMap.put("miAppKEY",zpnsConfig.miAppKey);
        zpnsConfigMap.put("oppoAppID",zpnsConfig.oppoAppID);
        zpnsConfigMap.put("oppoAppSecret",zpnsConfig.oppoAppSecret);
        zpnsConfigMap.put("oppoAppKey",zpnsConfig.oppoAppKey);
        zpnsConfigMap.put("vivoAppID",zpnsConfig.vivoAppID);
        zpnsConfigMap.put("vivoAppKey",zpnsConfig.vivoAppKey);
        zpnsConfigMap.put("hwAppID",zpnsConfig.hwAppID);
        zpnsConfigMap.put("appType",zpnsConfig.getAppType());
        zpnsConfigMap.put("enableHwBadge",zpnsConfig.isEnableHWBadge());
        return zpnsConfigMap;
    }

    static public HashMap<String,Object> cnvZPNsMessageObjectToMap(ZPNsMessage message) {

        HashMap<String,Object> messageMap = new HashMap<>();
        messageMap.put("title",message.getTitle());
        messageMap.put("content",message.getContent());
        messageMap.put("pushType",message.getPushType().code());
        messageMap.put("pushSourceType",message.getPushSource().code());
        messageMap.put("extras",ZPNsConverter.convertExtras(message.getExtras()));
        messageMap.put("payload", message.getPayload());


        messageMap.put("notifyId",message.getNotifyId());

        return messageMap;
    }

    static public HashMap<String,Object> cnvZPNsRegisterMessageObjectToMap(ZPNsRegisterMessage registerMessage){
        HashMap<String,Object> messageMap = new HashMap<>();
        messageMap.put("errorCode",registerMessage.getErrorCode().getCode());
        messageMap.put("msg",registerMessage.getMsg());
        messageMap.put("pushID",registerMessage.getCommandResult());
        messageMap.put("commandResult",registerMessage.getCommandResult());
        messageMap.put("pushSourceType",registerMessage.getPushSource().code());
        return  messageMap;
    }
}
