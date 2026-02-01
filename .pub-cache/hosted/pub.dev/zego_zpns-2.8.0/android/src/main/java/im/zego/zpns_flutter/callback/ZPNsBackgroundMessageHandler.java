package im.zego.zpns_flutter.callback;

import android.content.Context;

import im.zego.zpns.entity.ZPNsMessage;

public interface ZPNsBackgroundMessageHandler {
    void onThroughMessageReceived(Context context, ZPNsMessage message);
}
