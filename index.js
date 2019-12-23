import { NativeModules } from "react-native";

const { AlertView } = NativeModules;

export default {
  showAlert(msgInfo,callback) {
    return AlertView.showAlert(msgInfo,callback);
  }
};
