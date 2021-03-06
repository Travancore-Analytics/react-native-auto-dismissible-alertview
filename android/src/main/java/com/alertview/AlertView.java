package com.alertview;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
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

import static android.view.View.GONE;

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

    private void setImage(final ImageView imageView, final ReadableMap imageData){
        if(imageData.hasKey("uri")){
            Uri imgUri = Uri.parse(imageData.getString("uri"));
            int imageResource = getCurrentActivity().getResources().getIdentifier("@drawable/"+imgUri, null, getCurrentActivity().getPackageName());
            if (BuildConfig.DEBUG){
                Thread thread = new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try  {
                            imageView.setImageBitmap(drawable_from_url(imageData.getString("uri")));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });
                thread.start();
            }else {
                Drawable res = getCurrentActivity().getResources().getDrawable(imageResource);
                imageView.setImageDrawable(res);
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

    private void showDialog(final AlertDialog dialog,String title, String message,String buttonText,ReadableMap styles,boolean showClose, final Callback callback){
        dialog.show();
        // Set the alert size, to solve issues while coming back from landscape activity
        dialog.getWindow().setLayout((int) getCurrentActivity().getResources().getDimension(R.dimen.alert_width),
                RelativeLayout.LayoutParams.WRAP_CONTENT);
        configureDialog(dialog,title,message,buttonText,styles,showClose,callback);
    }

    private void showCustomizedDialog(final AlertDialog dialog,String title, String message,ReadableArray buttonNames,ReadableMap styles,boolean showClose, final Callback callback){
        dialog.show();
        // Set the alert size, to solve issues while coming back from landscape activity
        dialog.getWindow().setLayout((int) getCurrentActivity().getResources().getDimension(R.dimen.alert_width),
                RelativeLayout.LayoutParams.WRAP_CONTENT);
        configureCustomizedDialog(dialog,title,message,buttonNames,styles,showClose,callback);
    }

    private void configureCustomizedDialog(final AlertDialog dialog,String title, String message,ReadableArray buttonNames,ReadableMap styles,boolean showClose, final Callback callback){


        TextView titleTextView      = (TextView)  dialog.findViewById(R.id.titleTextView);
        TextView messageTextView    = (TextView)  dialog.findViewById(R.id.messageTextView);
        TextView primaryButton       = (TextView)  dialog.findViewById(R.id.primaryButton);
        TextView secondaryButton       = (TextView)  dialog.findViewById(R.id.secondaryButton);
        ImageView centerImageView   = (ImageView) dialog.findViewById(R.id.centerImageView);
        ImageView closeButton       = (ImageView) dialog.findViewById(R.id.closeButton);

        titleTextView.setText(title);
        messageTextView.setText(message);
        if(buttonNames.size() == 2){
            primaryButton.setText(buttonNames.getString(0));
            secondaryButton.setText(buttonNames.getString(1));
        }

        primaryButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                WritableMap selectedButton = new WritableNativeMap();
                selectedButton.putInt("buttonIndex",1);
                dialog.dismiss();
                callback.invoke(null,selectedButton);
            }
        });
        secondaryButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                WritableMap selectedButton = new WritableNativeMap();
                selectedButton.putInt("buttonIndex",2);
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
        if(styles.hasKey("primaryButtonStyle")){
            applyCustomStyles(primaryButton,styles.getMap("primaryButtonStyle"));
        }
        if(styles.hasKey("seecondaryButtonStyle")){
            applyCustomStyles(secondaryButton,styles.getMap("seecondaryButtonStyle"));
        }
        if (showClose){
            if(styles.hasKey("closeButtonImage")){
                setImage(closeButton,styles.getMap("closeButtonImage"));
            }
        }else{
            closeButton.setVisibility(GONE);
        }
        if(styles.hasKey("centerImage")){
            centerImageView.setVisibility(View.VISIBLE);
            setImage(centerImageView,styles.getMap("centerImage"));
        }

    }

    private void configureDialog(final AlertDialog dialog,String title, String message,String buttonText,ReadableMap styles,boolean showClose, final Callback callback){


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
        if (showClose){
            if(styles.hasKey("closeButtonImage")){
                setImage(closeButton,styles.getMap("closeButtonImage"));
            }
        }else{
            closeButton.setVisibility(GONE);
        }
        if(styles.hasKey("centerImage")){
            centerImageView.setVisibility(View.VISIBLE);
            setImage(centerImageView,styles.getMap("centerImage"));
        }

    }
    @ReactMethod public void dismissAllAlerts(){
        if (dialog != null && dialog.isShowing()){
            dialog.dismiss();
        }
    }

    @ReactMethod public void showCustomizedAlert(final String title, final String message, final String buttonText, final ReadableMap styles, final boolean autoDismiss, final boolean showClose, final Callback callback){

        getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog.Builder builder = new AlertDialog.Builder(getCurrentActivity());
                builder.setCancelable(false);
                builder.setView(R.layout.customalert);

                // Dismissing any auto-dismissible alerts if already showing.
                if (dialog != null && dialog.isShowing()){
                    dialog.dismiss();
                }

                if(!autoDismiss) {
                    // Creates an alert that doesn't have any reference that will not be dismissed automatically
                    showDialog(builder.create(),title,message,buttonText,styles,showClose,callback);
                } else {
                    // Creates an alert and will keep reference and will be dismissed automatically.
                    dialog = builder.create();
                    showDialog(dialog,title,message,buttonText,styles,showClose,callback);
                }
            }
        });
    }

    @ReactMethod public void showCustomAlert(final String title, final String message, final ReadableArray buttonNames, final ReadableMap styles, final boolean autoDismiss, final boolean showClose, final Callback callback){

        getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog.Builder builder = new AlertDialog.Builder(getCurrentActivity());
                builder.setCancelable(false);
                builder.setView(R.layout.customizedalert);

                // Dismissing any auto-dismissible alerts if already showing.
                if (dialog != null && dialog.isShowing()){
                    dialog.dismiss();
                }

                if(!autoDismiss) {
                    // Creates an alert that doesn't have any reference that will not be dismissed automatically
                    showCustomizedDialog(builder.create(),title,message,buttonNames,styles,showClose,callback);
                } else {
                    // Creates an alert and will keep reference and will be dismissed automatically.
                    dialog = builder.create();
                    showCustomizedDialog(dialog,title,message,buttonNames,styles,showClose,callback);
                }
            }
        });
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
