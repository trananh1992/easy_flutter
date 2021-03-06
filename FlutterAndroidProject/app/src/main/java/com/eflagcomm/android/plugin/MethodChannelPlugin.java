package com.eflagcomm.android.plugin;

import com.eflagcomm.android.IShowMessage;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterView;

/**
 * <p>{d}</p>
 *
 * @author zhenglecheng
 * @date 2020-01-14
 */
public class MethodChannelPlugin implements MethodChannel.MethodCallHandler {

    private IShowMessage mShowMessage;
    private final MethodChannel mMethodChannel;

    public static MethodChannelPlugin registerPlugin(FlutterView flutterView, IShowMessage showMessage) {
        return new MethodChannelPlugin(flutterView, showMessage);
    }

    private MethodChannelPlugin(FlutterView flutterView, IShowMessage showMessage) {
        this.mShowMessage = showMessage;
        mMethodChannel = new MethodChannel(flutterView, "MethodChannelPlugin");
        mMethodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        switch (methodCall.method) {
            case "showMessage":
                showMessage(methodCall.arguments());
                result.success("你好，flutter，收到消息了");
                break;
            case "sum":
                int sum = sum(methodCall.arguments());
                result.success("原生计算结果为： " + sum);
                break;
            default:
                result.notImplemented();
        }
    }

    /// 原生方法 给flutter调用
    private void showMessage(String message) {
        if (mShowMessage != null) {
            mShowMessage.showMessage(message);
        }
    }

    /// 原生方法 给flutter调用
    private int sum(int a) {
        return a + 100;
    }

    /**
     * 调用flutter的方法
     *
     * @param method 方法名
     * @param params 参数
     */
    public void callFlutterMethod(String method, Object params) {
        if (mMethodChannel != null) {
            mMethodChannel.invokeMethod(method, params, new MethodChannel.Result() {
                @Override
                public void success(Object o) {
                    if (mShowMessage != null) {
                        mShowMessage.showMessage(o.toString());
                    }
                }

                @Override
                public void error(String s, String s1, Object o) {
                    if (mShowMessage != null) {
                        mShowMessage.showMessage(s);
                    }
                }

                @Override
                public void notImplemented() {

                }
            });
        }
    }
}
