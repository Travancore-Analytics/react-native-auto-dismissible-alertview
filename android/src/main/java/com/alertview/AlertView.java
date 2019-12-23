package com.alertview;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import java.util.Arrays;

public class AlertView extends ReactContextBaseJavaModule  {

    public static final String REACT_CLASS = "AlertView";
    AlertDialog dialog;

    public AlertView(ReactApplicationContext context) {
        super(context);
    }

    @ReactMethod
    public void showAlert(String title, String message, Boolean cancelable, ReadableArray buttons, final Callback callback){


        if (dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }
        AlertDialog.Builder builder = new AlertDialog.Builder(getCurrentActivity());
        if (title != null){
            builder.setTitle(title);
        }
        if (message != null){
            builder.setMessage(message);
        }
        if (buttons != null && buttons.size() > 0){


            if (buttons.size() >1){
                builder.setPositiveButton(buttons.getString(1),new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        WritableMap selectedButton = new WritableNativeMap();
                        selectedButton.putInt("buttonIndex",1);
                        dialog.dismiss();
                        callback.invoke(null,selectedButton);
                    }
                });
                builder.setNegativeButton(buttons.getString(0),new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        WritableMap selectedButton = new WritableNativeMap();
                        selectedButton.putInt("buttonIndex",0);
                        dialog.dismiss();
                        callback.invoke(null,selectedButton);
                    }
                });
            }else {
                builder.setPositiveButton(buttons.getString(0),new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        WritableMap selectedButton = new WritableNativeMap();
                        selectedButton.putInt("buttonIndex",0);
                        dialog.dismiss();
                        callback.invoke(null,selectedButton);
                    }
                });
            }
            builder.setCancelable(cancelable);
            // create and show the alert dialog
            dialog = builder.create();
            dialog.show();
        }
    }
    @Override
    public String getName() {
        return REACT_CLASS;
    }
}
