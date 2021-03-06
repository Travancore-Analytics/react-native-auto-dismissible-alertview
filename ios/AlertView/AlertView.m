//  Created by react-native-create-bridge

#import <UIKit/UIKit.h>
#import "AlertView.h"
#import "CustomAlertViewController.h"
#import "CustomAlertController.h"
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


RCT_EXPORT_METHOD(showAlert:(NSString *) title message:(NSString *) message cancelable:(BOOL) cancelable buttons:(NSArray *)buttons  callback:(RCTResponseSenderBlock)callback){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *alertTitle     = @"";
        NSString *alertMessage   = @"";
        NSArray *alertButtons    =   [[NSArray alloc] init];
        
        if (title != nil) {
            alertTitle = title;
        }
        if (message != nil) {
            alertMessage = message;
        }
        if (buttons.count > 0) {
            alertButtons = buttons;
        }
        
        UIAlertController* alerViewController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                    message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        if (alertButtons.count > 0) {
            if (alertButtons.count > 1) {
                UIAlertAction *primaryAction = [UIAlertAction actionWithTitle:alertButtons[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSNumber *selectedIndex = [NSNumber numberWithInt:0];
                    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
                    callback(@[[NSNull null], selectedButton]);
                }];
                
                UIAlertAction *secondaryAction = [UIAlertAction actionWithTitle:alertButtons[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSNumber *selectedIndex = [NSNumber numberWithInt:1];
                    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
                    callback(@[[NSNull null], selectedButton]);
                }];
                [alerViewController addAction:primaryAction];
                [alerViewController addAction:secondaryAction];
            }else{
                UIAlertAction *primaryAction = [UIAlertAction actionWithTitle:alertButtons[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSNumber *selectedIndex = [NSNumber numberWithInt:0];
                    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
                    callback(@[[NSNull null], selectedButton]);
                }];
                [alerViewController addAction:primaryAction];
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
        }
    });
}

RCT_EXPORT_METHOD(showCustomizedAlert:(NSString *) title message:(NSString *) message buttonText:(NSString *) buttonText style:(NSDictionary *)style autoDismiss:(BOOL)autoDismiss showClose:(BOOL)showClose callback:(RCTResponseSenderBlock)callback) {
    
    self.alertCallback = callback;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MyBundle" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        CustomAlertViewController *popupViewController = [[CustomAlertViewController alloc] initWithNibName:@"CustomAlertViewController" bundle:bundle];
        popupViewController.delegate = self;
        
        if (title != nil) {
            popupViewController.titleText = title;
        }
        if (style != nil) {
            popupViewController.styleData = style;
        }
        if (message != nil) {
            popupViewController.message = message;
        }
        if (buttonText != nil) {
            popupViewController.submitText = buttonText;
        }
        popupViewController.showClose = showClose;
        
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIViewController *previousVC = nil;
        
        while (root.presentedViewController) {
            
            if ([root.presentedViewController isKindOfClass:[UIViewController class]]) {
                previousVC = root.presentedViewController;
                break;
            }
            
            root = root.presentedViewController;
        }
        
        if (previousVC != nil && !previousVC.isBeingDismissed) {
            [previousVC dismissViewControllerAnimated:true completion:^{
                [popupViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                [root presentViewController:popupViewController animated:NO completion:nil];
            }];
        }else{
            [popupViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [root presentViewController:popupViewController animated:NO completion:nil];
        }
        
    });
}

RCT_EXPORT_METHOD(dismissAllAlerts){
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIViewController *previousVC = nil;
        
        while (root.presentedViewController) {
            
            if ([root.presentedViewController isKindOfClass:[UIViewController class]]) {
                previousVC = root.presentedViewController;
                break;
            }
            
            root = root.presentedViewController;
        }
        
        if (previousVC != nil && !previousVC.isBeingDismissed) {
            [previousVC dismissViewControllerAnimated:true completion:^{
               
            }];
        }
    });
    
}

RCT_EXPORT_METHOD(showCustomAlert:(NSString *) title message:(NSString *) message buttonNames:(NSArray *) buttonNames style:(NSDictionary *)style autoDismiss:(BOOL)autoDismiss showClose:(BOOL)showClose callback:(RCTResponseSenderBlock)callback) {
    
    self.customAlertCallback = callback;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSBundle *bundle = [NSBundle mainBundle];
        
        CustomAlertController *popupViewController = [[CustomAlertController alloc] initWithNibName:@"CustomAlertController" bundle:bundle];
        popupViewController.delegate = self;
        
        if (title != nil) {
            popupViewController.titleText = title;
        }
        if (style != nil) {
            popupViewController.styleData = style;
        }
        if (message != nil) {
            popupViewController.message = message;
        }
        if (buttonNames.count == 2) {
            popupViewController.primaryButtonText = buttonNames[0];
            popupViewController.secondaryButtonText = buttonNames[1];
        }
        popupViewController.showClose = showClose;
        
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIViewController *previousVC = nil;
        
        while (root.presentedViewController) {
            
            if ([root.presentedViewController isKindOfClass:[UIViewController class]]) {
                previousVC = root.presentedViewController;
                break;
            }
            
            root = root.presentedViewController;
        }
        
        if (previousVC != nil && !previousVC.isBeingDismissed) {
            [previousVC dismissViewControllerAnimated:true completion:^{
                [popupViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                [root presentViewController:popupViewController animated:NO completion:nil];
            }];
        }else{
            [popupViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [root presentViewController:popupViewController animated:NO completion:nil];
        }
        
    });
}

- (void) submitButtonDelegate: (CustomAlertViewController *) sender {
    
    NSNumber *selectedIndex = [NSNumber numberWithInt:1];
    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
    self.alertCallback(@[[NSNull null], selectedButton]);
    
}

- (void) closeButtonDelegate: (CustomAlertViewController *) sender {
    
    NSNumber *selectedIndex = [NSNumber numberWithInt:0];
    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
    self.alertCallback(@[[NSNull null], selectedButton]);
    
}

-(void) primaryButtonDelegate:(CustomAlertController *)sender{
    NSNumber *selectedIndex = [NSNumber numberWithInt:1];
    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
    self.customAlertCallback(@[[NSNull null], selectedButton]);
}

-(void) secondaryButtonDelegate:(CustomAlertController *)sender{
    NSNumber *selectedIndex = [NSNumber numberWithInt:2];
    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
    self.customAlertCallback(@[[NSNull null], selectedButton]);
}

-(void) onCloseDelegate:(CustomAlertController *)sender{
    NSNumber *selectedIndex = [NSNumber numberWithInt:0];
    NSDictionary *selectedButton = [[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"buttonIndex", nil];
    self.customAlertCallback(@[[NSNull null], selectedButton]);
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[];
}


@end
