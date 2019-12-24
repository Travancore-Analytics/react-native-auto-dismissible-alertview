import { NativeModules } from "react-native";

const { AlertView } = NativeModules;

export default {
  showAlert(title,message,cancelable,buttons,callback) {
    return AlertView.showAlert(title,message,cancelable,buttons,callback);
  }
};
