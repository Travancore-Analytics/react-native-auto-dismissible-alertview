import { NativeModules, Platform} from "react-native";

const { AlertView } = NativeModules;

export default {
  showAlert(title,message,cancelable,buttons,callback) {
    return AlertView.showAlert(title,message,cancelable,buttons,callback);
  },
  showCustomizedAlert(title,message,buttonText,style,callback){
    if(Platform.OS == "android"){
      return AlertView.showCustomizedAlert(title,message,buttonText,style,callback);
    }
  }
};
