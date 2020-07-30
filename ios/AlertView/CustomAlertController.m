
#import "CustomAlertController.h"

@interface CustomAlertController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *messageLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *centerImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *closeButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *secondaryButton;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *centerImageHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *centerImageTopConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *primaryButton;

@end

//typealias v2CB = (infoToReturn :String) ->()

@implementation CustomAlertController
@synthesize delegate;

- (void) primaryButtonCallback {
    
    [self.delegate primaryButtonDelegate:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) secondaryButtonCallback {
    
    [self.delegate secondaryButtonDelegate:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) closeButtonCallback {
    
    [self.delegate onCloseDelegate:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleLabel];
    [self setupMessageLabel];
    [self setupCentreImage];
    [self setupCloseButton];
    [self setupPrimaryButton];
    [self setupSecondaryButton];
    
}

- (void) setupMessageLabel {
    NSString *font = [[_styleData valueForKey:@"messageStyle"] valueForKey:@"font"];
    NSString *fontName = [font componentsSeparatedByString:@"."].firstObject;
    NSString *fontSize =  [[_styleData valueForKey:@"messageStyle"] valueForKey:@"fontSize"];
    NSString *fontColorString =  [[_styleData valueForKey:@"messageStyle"] valueForKey:@"color"];
    _messageLabel.text = _message;
    
    if (fontColorString != nil) {
        UIColor *fontColor = [self colorFromHexString:fontColorString];
        _messageLabel.textColor = fontColor;
    }
    if (fontSize != nil) {
        _messageLabel.font = [UIFont fontWithName:fontName size:[fontSize floatValue]];
    }
}

- (void) setupTitleLabel {
    
    NSString *font = [[_styleData valueForKey:@"messageStyle"] valueForKey:@"font"];
    NSString *fontName = [font componentsSeparatedByString:@"."].firstObject;
    NSString *fontSize =  [[_styleData valueForKey:@"titleStyle"] valueForKey:@"fontSize"];
    NSString *fontColorString =  [[_styleData valueForKey:@"titleStyle"] valueForKey:@"color"];
    
    _titleLabel.text = _titleText;
    if (fontColorString != nil) {
        UIColor *fontColor = [self colorFromHexString:fontColorString];
        _titleLabel.textColor = fontColor;
    }
    if (fontSize != nil) {
        _titleLabel.font = [UIFont fontWithName:fontName size:[fontSize floatValue]];
    }
}

- (void) setupCentreImage {
    if([_styleData valueForKey:@"centerImage"] != nil){
        NSString *urlStar = [[_styleData valueForKey:@"centerImage"] valueForKey:@"uri"];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlStar]];
        _centerImageView.image = [UIImage imageWithData:imageData scale:1.0f];
        _centerImageTopConstraint.constant = 20;
        _centerImageHeightConstraint.constant = 37;
    }else{
        _centerImageTopConstraint.constant = 0;
        _centerImageHeightConstraint.constant = 0;
    }
}

- (void) setupCloseButton {
    
    if (_showClose) {
        NSString *urlButton = [[_styleData valueForKey:@"closeButtonImage"] valueForKey:@"uri"];
        NSData *closeImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlButton]];
        UIImage *buttonImage = [UIImage imageWithData:closeImage scale:1.0f];
        _closeButton.accessibilityLabel = @"AlertClose";
        [_closeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }else{
        [_closeButton setHidden:YES];
    }
    
    
}

- (void) setupPrimaryButton {
    
    NSString *font = [[_styleData valueForKey:@"primaryButtonStyle"] valueForKey:@"font"];
    NSString *fontName = [font componentsSeparatedByString:@"."].firstObject;
    NSString *fontSize =  [[_styleData valueForKey:@"primaryButtonStyle"] valueForKey:@"fontSize"];
    NSString *fontColorString =  [[_styleData valueForKey:@"primaryButtonStyle"] valueForKey:@"color"];
    [_primaryButton setTitle:_primaryButtonText forState:UIControlStateNormal];
    
    if (fontColorString != nil) {
        UIColor *fontColor = [self colorFromHexString:fontColorString];
        [_primaryButton setTitleColor:fontColor forState:UIControlStateNormal];
    }
    if (fontSize != nil) {
        [_primaryButton.titleLabel setFont:[UIFont fontWithName:fontName size:[fontSize floatValue]]];
    }
}

- (void) setupSecondaryButton {
    
    NSString *font = [[_styleData valueForKey:@"seecondaryButtonStyle"] valueForKey:@"font"];
    NSString *fontName = [font componentsSeparatedByString:@"."].firstObject;
    NSString *fontSize =  [[_styleData valueForKey:@"seecondaryButtonStyle"] valueForKey:@"fontSize"];
    NSString *fontColorString =  [[_styleData valueForKey:@"seecondaryButtonStyle"] valueForKey:@"color"];
    [_secondaryButton setTitle:_secondaryButtonText forState:UIControlStateNormal];
    
    if (fontColorString != nil) {
        UIColor *fontColor = [self colorFromHexString:fontColorString];
        [_secondaryButton setTitleColor:fontColor forState:UIControlStateNormal];
    }
    if (fontSize != nil) {
        [_secondaryButton.titleLabel setFont:[UIFont fontWithName:fontName size:[fontSize floatValue]]];
    }
}

- (IBAction)closeAction:(UIButton *)sender {
    [self closeButtonCallback];
}

- (IBAction)secondaryAction:(id)sender {
    [self secondaryButtonCallback];
}
- (IBAction)primaryAction:(id)sender {
    [self primaryButtonCallback];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    if (![hexString isEqual: @""]) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }else {
        return [UIColor clearColor];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
