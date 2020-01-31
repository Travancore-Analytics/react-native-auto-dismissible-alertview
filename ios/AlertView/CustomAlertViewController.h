
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CustomAlertViewController;  

@protocol CustomAlertDelegate <NSObject>
- (void) submitButtonDelegate: (CustomAlertViewController *) sender;
- (void) closeButtonDelegate: (CustomAlertViewController *) sender;

@end

@interface CustomAlertViewController : UIViewController

    @property (nonatomic, retain) NSDictionary *styleData;
    @property (nonatomic, retain) NSString *titleText;
    @property (nonatomic, retain) NSString *message;
    @property (nonatomic, retain) NSString *submitText;
    @property (nonatomic, weak) id <CustomAlertDelegate> delegate;

@end
NS_ASSUME_NONNULL_END
