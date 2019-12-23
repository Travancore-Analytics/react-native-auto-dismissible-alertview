//  Created by react-native-create-bridge

#import <UIKit/UIKit.h>
#import "AlertView.h"
// import RCTBridge
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#elif __has_include(“RCTBridge.h”)
#import “RCTBridge.h”
#else
#import “React/RCTBridge.h” // Required when used as a Pod in a Swift project
#endif

// import RCTEventDispatcher
#if __has_include(<React/RCTEventDispatcher.h>)
#import <React/RCTEventDispatcher.h>
#elif __has_include(“RCTEventDispatcher.h”)
#import “RCTEventDispatcher.h”
#else
#import “React/RCTEventDispatcher.h” // Required when used as a Pod in a Swift project
#endif


@interface AlertView ()
{
    
}
@end
@implementation AlertView
@synthesize bridge = _bridge;

// Export a native module
// https://facebook.github.io/react-native/docs/native-modules-ios.html
RCT_EXPORT_MODULE();

// Export methods to a native module
// https://facebook.github.io/react-native/docs/native-modules-ios.html


RCT_EXPORT_METHOD(showAlert:(NSDictionary *) msgInfo callback:(RCTResponseSenderBlock)callback){
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title     = @"";
        NSString *message   = @"";
        NSArray *buttons    =   [[NSArray alloc] init];
        if ([msgInfo valueForKey:@"title"] != nil) {
            title = [msgInfo valueForKey:@"title"];
        }
        if ([msgInfo valueForKey:@"message"] != nil) {
            message = [msgInfo valueForKey:@"message"];
        }
        if ([msgInfo valueForKey:@"buttons"] != nil) {
            buttons = [msgInfo valueForKey:@"buttons"];
        }
        UIAlertController* alerViewController = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        for (int index = 0; index < [buttons count];index++ ) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttons[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSNumber *selectedIndex = [NSNumber numberWithInt:index];
                NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
                callback(@[[NSNull null], selectedButton]);
            }];
            [alerViewController addAction:action];
        }
        
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIViewController *previousVC = nil;
        while (root.presentedViewController) {
            if ([root.presentedViewController isKindOfClass:[UIAlertController class]]) {
                previousVC = root.presentedViewController;
                break;
            }
            root = root.presentedViewController;
        }
        if (previousVC != nil) {
            [previousVC dismissViewControllerAnimated:true completion:^{
                [root presentViewController:alerViewController animated:YES completion:nil];
            }];
        }else{
            [root presentViewController:alerViewController animated:YES completion:nil];
        }
    });
    
}
- (NSArray<NSString *> *)supportedEvents
{
    return @[];
}

- (NSDictionary *)constantsToExport
{
    return @{  };
}

@end
