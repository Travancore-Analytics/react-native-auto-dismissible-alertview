package com.alertview;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class AlertView extends ReactContextBaseJavaModule  {

    public static final String REACT_CLASS = "AlertView";
    AlertDialog dialog;

    public AlertView(ReactApplicationContext context) {
        super(context);
    }


    private void applyCustomStyles(TextView textView,ReadableMap styles){
        if(styles.hasKey("text")){
            textView.setText(styles.getString("text"));
        }
        if(styles.hasKey("font")){
            Typeface font=Typeface.createFromAsset(getCurrentActivity().getAssets(),"fonts/"+styles.getString("font"));
            textView.setTypeface(font);
        }
        if(styles.hasKey("fontSize")){
            textView.setTextSize(styles.getInt("fontSize"));
        }
        if(styles.hasKey("color")){
            textView.setTextColor(Color.parseColor(styles.getString("color")));
        }
    }

    private void setImage(ImageView imageView,ReadableMap imageData){
        if(imageData.hasKey("uri")){
            Uri imgUri = Uri.parse(imageData.getString("uri"));
            int imageResource = getCurrentActivity().getResources().getIdentifier("@drawable/"+imgUri, null, getCurrentActivity().getPackageName());
            if (imageResource != 0){
                Drawable res = getCurrentActivity().getResources().getDrawable(imageResource);
                imageView.setImageDrawable(res);
            }else {
                try {
                    imageView.setImageBitmap(drawable_from_url(imageData.getString("uri")));
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    static Bitmap drawable_from_url(String url) throws java.net.MalformedURLException, java.io.IOException {

        HttpURLConnection connection = (HttpURLConnection)new URL(url) .openConnection();
        connection.setRequestProperty("User-agent","Mozilla/4.0");

        connection.connect();
        InputStream input = connection.getInputStream();

        return BitmapFactory.decodeStream(input);
    }

    @ReactMethod public void showCustomizedAlert(String title, String message,String buttonText,ReadableMap styles ,final Callback callback){

        if (dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(getCurrentActivity());
        builder.setCancelable(false);
        builder.setView(R.layout.customalert);
        dialog = builder.create();
        dialog.show();

        TextView titleTextView      = (TextView)  dialog.findViewById(R.id.titleTextView);
        TextView messageTextView    = (TextView)  dialog.findViewById(R.id.messageTextView);
        TextView submitButton       = (TextView)  dialog.findViewById(R.id.submitButton);
        ImageView centerImageView   = (ImageView) dialog.findViewById(R.id.centerImageView);
        ImageView closeButton       = (ImageView) dialog.findViewById(R.id.closeButton);

        titleTextView.setText(title);
        messageTextView.setText(message);
        submitButton.setText(buttonText);

        submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                WritableMap selectedButton = new WritableNativeMap();
                selectedButton.putInt("buttonIndex",1);
                dialog.dismiss();
                callback.invoke(null,selectedButton);
            }
        });
        closeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                WritableMap selectedButton = new WritableNativeMap();
                selectedButton.putInt("buttonIndex",0);
                dialog.dismiss();
                callback.invoke(null,selectedButton);
            }
        });

        if(styles.hasKey("titleStyle")){
            applyCustomStyles(titleTextView,styles.getMap("titleStyle"));
        }
        if(styles.hasKey("messageStyle")){
            applyCustomStyles(messageTextView,styles.getMap("messageStyle"));
        }
        if(styles.hasKey("buttonStyle")){
            applyCustomStyles(submitButton,styles.getMap("buttonStyle"));
        }
        if(styles.hasKey("closeButtonImage")){
            setImage(closeButton,styles.getMap("closeButtonImage"));
        }
        if(styles.hasKey("centerImage")){
            setImage(centerImageView,styles.getMap("centerImage"));
        }

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
