import { NativeModules, Platform} from "react-native";

const { AlertView } = NativeModules;

export default {
  showAlert(title,message,cancelable,buttons,callback) {
    return AlertView.showAlert(title,message,cancelable,buttons,callback);
  },
  showCustomizedAlert(title,message,buttonText,style,autoDismiss,showClose,callback){
      return AlertView.showCustomizedAlert(title,message,buttonText,style,autoDismiss,showClose,callback);
  },
  showCustomAlert(title,message,buttonNames,style,autoDismiss,showClose,callback){
    return AlertView.showCustomAlert(title,message,buttonNames,style,autoDismiss,showClose,callback);
  },
  dismissAllAlerts(){
    return AlertView.dismissAllAlerts();
  }
};
