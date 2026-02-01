part of 'adapter_service.dart';

typedef ZegoPluginAdapterMessageHandler = Function(
  AppLifecycleState appLifecycleState,
);

/// @nodoc
mixin ZegoSystemService {
  final _messageHandlerNotifier = ValueNotifier<AppLifecycleState>(
    AppLifecycleState.resumed,
  );
  final List<ZegoPluginAdapterMessageHandler> _messageHandlers = [];

  /// init
  void initSystemService() {
    ZegoAdapterLoggerService.logInfo(
      'init system service',
      tag: 'adapter',
      subTag: 'system service',
    );

    /// Due to the fact that SystemChannels.lifecycle.setMessageHandler
    /// can only be listened to once in the entire app,
    /// if you also want to listen to this event,
    /// please use ZegoUIKit().adapterService().registerMessageHandler
    /// or ZegoPluginAdapter().service().registerMessageHandler to listen.
    SystemChannels.lifecycle.setMessageHandler((stateString) async {
      ZegoAdapterLoggerService.logInfo(
        'SystemChannels.lifecycle.MessageHandler, $stateString',
        tag: 'adapter',
        subTag: 'system service',
      );

      final appLifecycleState = _parseStateFromString(stateString ?? '');
      ZegoAdapterLoggerService.logInfo(
        'app lifecycle state:$appLifecycleState(from $stateString)',
        tag: 'adapter',
        subTag: 'system service',
      );
      WidgetsBinding.instance.handleAppLifecycleStateChanged(appLifecycleState);

      for (var messageHandler in _messageHandlers) {
        messageHandler.call(appLifecycleState);
      }
      _messageHandlerNotifier.value = appLifecycleState;

      return null;
    });
  }

  /// Due to the fact that SystemChannels.lifecycle.setMessageHandler
  /// can only be listened to once in the entire app,
  /// if you also want to listen to this event,
  /// please use ZegoUIKit().adapterService().registerMessageHandler
  /// or ZegoPluginAdapter().service().registerMessageHandler to listen.
  void registerMessageHandler(ZegoPluginAdapterMessageHandler handler) {
    ZegoAdapterLoggerService.logInfo(
      'register message handler:${handler.hashCode}',
      tag: 'adapter',
      subTag: 'system service',
    );

    _messageHandlers.add(handler);
  }

  /// unregister
  void unregisterMessageHandler(ZegoPluginAdapterMessageHandler handler) {
    ZegoAdapterLoggerService.logInfo(
      'unregister message handler:${handler.hashCode}',
      tag: 'adapter',
      subTag: 'system service',
    );

    _messageHandlers.remove(handler);
  }

  /// get microphone state notifier
  ValueNotifier<AppLifecycleState> getMessageHandlerNotifier() {
    return _messageHandlerNotifier;
  }

  AppLifecycleState _parseStateFromString(String state) {
    var values = <String, AppLifecycleState>{};
    for (var appLifecycleState in AppLifecycleState.values) {
      values[appLifecycleState.toString()] = appLifecycleState;
    }

    final retValue = values[state] ?? AppLifecycleState.resumed;

    ZegoAdapterLoggerService.logInfo(
      '_parseStateFromString from $state to $retValue, ',
      tag: 'adapter',
      subTag: 'system service',
    );

    return retValue;
  }
}
