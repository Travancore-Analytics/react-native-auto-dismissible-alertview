
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class CustomAlertController;

@protocol CustomAlertViewDelegate <NSObject>
- (void) primaryButtonDelegate: (CustomAlertController *) sender;
- (void) secondaryButtonDelegate: (CustomAlertController *) sender;
- (void) onCloseDelegate: (CustomAlertController *) sender;

@end

@interface CustomAlertController : UIViewController

    @property (nonatomic, retain) NSDictionary *styleData;
    @property (nonatomic, retain) NSString *titleText;
    @property (nonatomic, retain) NSString *message;
    @property (nonatomic, retain) NSString *primaryButtonText;
    @property (nonatomic, retain) NSString *secondaryButtonText;
    @property (nonatomic, assign) BOOL showClose;
    @property (nonatomic, weak) id <CustomAlertViewDelegate> delegate;

@end
NS_ASSUME_NONNULL_END
