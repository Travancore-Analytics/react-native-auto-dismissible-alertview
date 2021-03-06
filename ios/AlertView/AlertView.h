//  Created by react-native-create-bridge

#import "CustomAlertViewController.h"
#import "CustomAlertController.h"
// import RCTBridgeModule
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include(“RCTBridgeModule.h”)
#import “RCTBridgeModule.h”
#else
#import “React/RCTBridgeModule.h” // Required when used as a Pod in a Swift project
#endif

// import RCTEventEmitter
#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#elif __has_include(“RCTEventEmitter.h”)
#import “RCTEventEmitter.h”
#else
#import “React/RCTEventEmitter.h” // Required when used as a Pod in a Swift project
#endif

@interface AlertView : RCTEventEmitter <RCTBridgeModule, CustomAlertDelegate, CustomAlertViewDelegate>
@property (nonatomic, copy) RCTResponseSenderBlock alertCallback;
@property (nonatomic, copy) RCTResponseSenderBlock customAlertCallback;
@end


