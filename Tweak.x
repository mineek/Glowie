@import Alderis;
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>
#import "iOSPalette/Palette.h"
#import "iOSPalette/UIImage+Palette.h"
#import "ColorFlowAPI.h"
#import "AlderisColorPicker.h"
/*
Vars
*/
CAGradientLayer *gradientLayer;
SBFloatingDockPlatterView *floatingDockView;
SBDockView *stockDockView;
UIColor *colorOne;
UIColor *colorTwo;
UIColor *borderColor;
/*
Prefs
*/
static BOOL usingFloatingDock;
static NSInteger gradientDirection;
static CGFloat dockAlpha;
static NSString *colorOneString;
static NSString *colorTwoString;
static BOOL overrideCornerRadius;
static NSInteger cornerRadius;
static NSString *borderColorString;
static NSInteger borderWidth;

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
@end

@interface SBIconLegibilityLabelView : _UILegibilityView
@property (nonatomic, retain) UIImage *image;
@end

/*

Glow

*/
NSUserDefaults *_preferences;
BOOL _enabled;


%hook SBIconLegibilityLabelView
//this method is for _UILegibilityView and we return the color we want the label to be
-(UIColor *)drawingColor {
CGFloat setBackgroundColorTransparency = [preferences floatForKey:@"backgroundColorTransparency"];
    if (!(setBackgroundColorTransparency >= 1)){
        setBackgroundColorTransparency = 100;
    }
[self setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 setBackgroundColorTransparency]];
 return [UIColor cyanColor];
}
-(CALayer *)layer {
 CALayer *origLayer = %orig; //our origLayer is what this method would have originally returned
 origLayer.cornerRadius = 4.0; //set corner radius to 2.0
 origLayer.borderWidth = 1.0;
 origLayer.borderColor = [UIColor systemPinkColor].CGColor;
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