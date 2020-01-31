//
//  CustomAlertViewController.m
//  DoubleConversion
//
//  Created by Senorita Jose on 14/01/20.
//

#import "CustomAlertViewController.h"

@interface CustomAlertViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *messageLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *centerImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *closeButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *submitButton;

@end

//typealias v2CB = (infoToReturn :String) ->()

@implementation CustomAlertViewController
@synthesize delegate;

- (void) submitButtonCallback {
    
    [self.delegate submitButtonDelegate:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) closeButtonCallback {
    
    [self.delegate closeButtonDelegate:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTitleLabel];
    [self setupMessageLabel];
    [self setupCentreImage];
    [self setupCloseButton];
    [self setupSubmitButton];
    
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
    
    NSString *urlStar = [[_styleData valueForKey:@"centerImage"] valueForKey:@"uri"];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlStar]];
    _centerImageView.image = [UIImage imageWithData:imageData scale:1.0f];
}

- (void) setupCloseButton {
    
    NSString *urlButton = [[_styleData valueForKey:@"closeButtonImage"] valueForKey:@"uri"];
    NSData *closeImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlButton]];
    UIImage *buttonImage = [UIImage imageWithData:closeImage scale:1.0f];
    [_closeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
}

- (void) setupSubmitButton {
    
    NSString *font = [[_styleData valueForKey:@"messageStyle"] valueForKey:@"font"];
    NSString *fontName = [font componentsSeparatedByString:@"."].firstObject;
    NSString *fontSize =  [[_styleData valueForKey:@"buttonStyle"] valueForKey:@"fontSize"];
    NSString *fontColorString =  [[_styleData valueForKey:@"buttonStyle"] valueForKey:@"color"];
    [_submitButton setTitle:_submitText forState:UIControlStateNormal];
    
    if (fontColorString != nil) {
        UIColor *fontColor = [self colorFromHexString:fontColorString];
        [_submitButton setTitleColor:fontColor forState:UIControlStateNormal];
    }
    if (fontSize != nil) {
        [_submitButton.titleLabel setFont:[UIFont fontWithName:fontName size:[fontSize floatValue]]];
    }
}

- (IBAction)closeAction:(UIButton *)sender {
    [self closeButtonCallback];
}

- (IBAction)submitAction:(id)sender {
    [self submitButtonCallback];
    // Handle Submit action here
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
