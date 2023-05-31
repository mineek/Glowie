#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>
/*
                                                                                                           
 ██████╗ ██╗      ██████╗ ██╗    ██╗██╗███████╗                                                                                                                                                    
██╔════╝ ██║     ██╔═══██╗██║    ██║██║██╔════╝                                                                                                                                                    
██║  ███╗██║     ██║   ██║██║ █╗ ██║██║█████╗                                                                                                                                                      
██║   ██║██║     ██║   ██║██║███╗██║██║██╔══╝                                                                                                                                                      
╚██████╔╝███████╗╚██████╔╝╚███╔███╔╝██║███████╗                                                                                                                                                    
 ╚═════╝ ╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═╝╚══════╝
Created by: 
  - Kota
  - Snoolie
  - Mineek



    Let's Start with some Headers!
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
@property CGFloat shadowRadius;
@property float shadowOpacity;
@property CGColorRef shadowColor;
- (id)_labelborderFillColor;
- (id)_labelTextColor;
@end

/*

Attach to the view

*/


@interface SBIconLegibilityLabelView : _UILegibilityView
@property (nonatomic, retain) UIImage *image;
@end

/*

Convert our Color HEX

*/

UIColor* colorFromHexString(NSString* hexString) {
    NSString *daString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![daString containsString:@"#"]) {
        daString = [@"#" stringByAppendingString:daString];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:daString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

    NSRange range = [hexString rangeOfString:@":" options:NSBackwardsSearch];
    NSString* alphaString;
    if (range.location != NSNotFound) {
        alphaString = [hexString substringFromIndex:(range.location + 1)];
    } else {
        alphaString = @"1.0"; //no opacity specified - just return 1 :/
    }

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:[alphaString floatValue]];
}
/*

Define preferences

*/
NSUserDefaults *_preferences;
BOOL _enabled;

/*

Our Hook Below

*/
%hook SBIconLegibilityLabelView
//this method is for _UILegibilityView and we return the color we want the label to be
-(UIColor *)drawingColor {
  NSString *bgColorString = [_preferences objectForKey:@"backgroundColor"];
  if (bgColorString) {
    self.backgroundColor = colorFromHexString(bgColorString);
  }
  UIColor *ret;
  NSString *colorString = [_preferences objectForKey:@"colorOneString"];
  NSLog(@"[*]Glowie: %@",colorString);
  if (colorString) {
    ret = colorFromHexString(colorString);
  }
  return ret ? ret : [UIColor cyanColor];
}
/*

More method magic

*/
-(CALayer *)layer {
  CALayer *origLayer = %orig; //our origLayer is what this method would have originally returned
  CGFloat setCornerRadius = [_preferences floatForKey:@"cornerRadius"];
  if (!(setCornerRadius >= 0)){
    setCornerRadius = 1;
  }
  origLayer.cornerRadius = setCornerRadius;
  CGFloat setBorderWidth = [_preferences floatForKey:@"borderWidth"];
  if (!(setBorderWidth >= 0)){
    setBorderWidth = 1;
  }
  origLayer.borderWidth = setBorderWidth;
  UIColor *one;
  NSString *colorString = [_preferences objectForKey:@"colorTwoString"];
  if (colorString) {
    NSLog(@"[*]We Set Border Colors!: %@",colorString);
    one = colorFromHexString(colorString);
    origLayer.borderColor = one.CGColor;
  }
  origLayer.shadowOffset = CGSizeMake(4.0f,-4.0f);
  origLayer.shadowRadius = 3.0;
  origLayer.shadowOpacity = 0.5;
  NSString *shadowColorString = [_preferences objectForKey:@"shadowColor"];
  NSLog(@"[*]Real Glow Started: %@",shadowColorString);
  if (shadowColorString) {
   origLayer.shadowColor = colorFromHexString(shadowColorString).CGColor; 
  }
  else {
    NSLog(@"[*]Glowie failed: %@",shadowColorString);
  }
  return origLayer;
}
%end
/*

Attach to preferences & Enable it.

*/
%ctor {
	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"online.transrights.glow"];
	[_preferences registerDefaults:@{
		@"enabled" : @YES,

	}];
	_enabled = [_preferences boolForKey:@"enabled"];
	if(_enabled) {
		NSLog(@"[Glow] Enabled");
		%init();
	} else {
		NSLog(@"[Glow] Disabled, heading out!");
	}
}
