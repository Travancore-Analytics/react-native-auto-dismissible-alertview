
import React, { Component } from "react";
import {
    View,
    Text,
    StyleSheet,
    TouchableOpacity
} from "react-native";
import AlertView from 'react-native-auto-dismissible-alertview';

export default class home extends Component {

    constructor(props) {
        super(props);
    }

    showSingleButtonAlert = () => {
        let buttons = ["OK"];
        let cancelable = false;
        AlertView.showAlert("title","message",cancelable,buttons,(error, selectedButton) => {
            if (!error) {
              console.warn(selectedButton);
            }
          });
    }

    showDoubleButtonAlert = () => {
        let buttons = ["OK","Update"];
        let cancelable = true;
        AlertView.showAlert("title","message",cancelable,buttons,(error, selectedButton) => {
            if (!error) {
              console.warn(selectedButton);
            }
          });
    }

    render() {

        return (
            <View style={styles.outerView}>
                <TouchableOpacity onPress={this.showSingleButtonAlert} >
                    <View style={styles.innerView}>
                        <Text style={styles.customText}>Single Button</Text>
                    </View>
                </TouchableOpacity>
                <TouchableOpacity onPress={this.showDoubleButtonAlert} >
                    <View style={styles.innerView}>
                        <Text style={styles.customText}>Double Button</Text>
                    </View>
                </TouchableOpacity>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        backgroundColor: 'grey'
    },
    buttonContainer: {
        margin: 20
    },
    alternativeLayoutButtonContainer: {
        margin: 20,
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    textCustom: {
        margin: 20,
        height: 40,
        backgroundColor: 'white'
    },
    outerView:{
        width : '100%',
        height : '100%',
        justifyContent: 'center',
        alignItems: 'center'
      },
      innerView:{
        width : 100,
        height : 40,
        backgroundColor: 'black',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 30
      },
      customText:{
        color: 'white'
      }

});