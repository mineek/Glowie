#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>

/*

Headers

*/

@interface _UILegibilityView : UIView {
	BOOL _hidesImage;
	UIImage* _image;
	UIImage* _shadowImage;
	double _strength;
	UIImageView* _imageView;
	UIImageView* _shadowImageView;
	long long _options;
}
@property (nonatomic,retain) UIImage * image;                               //@synthesize image=_image - In the implementation block
@property (nonatomic,retain) UIImage * shadowImage;                         //@synthesize shadowImage=_shadowImage - In the implementation block
@property (nonatomic,retain) UIImageView * imageView;                       //@synthesize imageView=_imageView - In the implementation block
@property (nonatomic,retain) UIImageView * shadowImageView;                 //@synthesize shadowImageView=_shadowImageView - In the implementation block
@property (assign,nonatomic) long long options;                             //@synthesize options=_options - In the implementation block
@property (nonatomic,readonly) long long style; 
@property (assign,nonatomic) double strength;                               //@synthesize strength=_strength - In the implementation block
@property (assign,nonatomic) BOOL hidesImage;                               //@synthesize hidesImage=_hidesImage - In the implementation block
@property (nonatomic,readonly) BOOL usesColorFilters; 
@property (retain, nonatomic) CALayer *fillLayer;
@property (retain, nonatomic) CALayer *pinLayer; 
@property (copy, nonatomic) UIColor *pinColor;
@property (nonatomic) CGFloat pinColorAlpha; 
@property (nonatomic) CGFloat bodyColorAlpha;
- (id)_labelborderFillColor;
- (id)_labelTextColor;
@end

@interface SBIconLegibilityLabelView : _UILegibilityView
@property (nonatomic, retain) UIImage *image;
@end

UIColor* colorFromHexString(NSString* hexString) {
    NSString *daString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![daString containsString:@"#"]) {
        daString = [@"#" stringByAppendingString:daString];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:daString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

/*

Glow

*/
NSUserDefaults *_preferences;
BOOL _enabled;


%hook SBIconLegibilityLabelView
//this method is for _UILegibilityView and we return the color we want the label to be
-(UIColor *)drawingColor {
 NSString *bgColorString = [_preferences objectForKey:@"backgroundColor"];
 if (bgColorString) {
  self.backgroundColor = colorFromHexString(bgColorString);
 }
 UIColor *ret;
 NSString *colorString = [_preferences objectForKey:@"colorOneString"];
 if (colorString) {
  ret = colorFromHexString(colorString);
 }
 return ret ? ret : [UIColor cyanColor];
}
-(CALayer *)layer {
 CALayer *origLayer = %orig; //our origLayer is what this method would have originally returned
 CGFloat setCornerRadius = [_preferences floatForKey:@"cornerRadius"];
    if (!(setCornerRadius >= 0)){
        setCornerRadius = 4;
    }
origLayer.cornerRadius = setCornerRadius;
 CGFloat setBorderWidth = [_preferences floatForKey:@"borderWidth"];
    if (!(setBorderWidth >= 0)){
        setBorderWidth = 4;
    }
origLayer.borderWidth = setBorderWidth;
 UIColor *one;
 NSString *colorString = [_preferences objectForKey:@"colorTwoString"];
 if (colorString) {
  one = colorFromHexString(colorString);
  origLayer.borderColor = one.CGColor;
 }
 return origLayer;
}
%end

%ctor {
	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"online.transrights.glow"];
	_enabled = [_preferences boolForKey:@"enabled"];
	if(_enabled) {
		NSLog(@"[Glow] Enabled");
		%init();
	} else {
		NSLog(@"[Glow] Disabled, heading out!");
	}
}
