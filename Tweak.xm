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
@end

@interface SBIconLegibilityLabelView : _UILegibilityView
@property (nonatomic, retain) UIImage *image;
@end

/*

Glowie

*/

NSUserDefaults *_preferences;
BOOL _enabled;

%ctor {
	_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.mineek.glowieprefs"];
	_enabled = [_preferences objectForKey:@"enabled"] ? [[_preferences objectForKey:@"enabled"] boolValue] : YES;
	if(_enabled) {
		NSLog(@"[Glowie] Enabled");
		%init();
	} else {
		NSLog(@"[Glowie] Disabled, heading out!");
	}
}

%hook SBIconLegibilityLabelView
-(NSArray *)subviews {
 id origSubviews = %orig; //origSubviews is what this method would have originally returned, ex the original subviews for this UIView
 //loop through the original subviews
 for (UIImageView* i in origSubviews){
  //SBIconLegibilityLabelView should only have UIImageView's - but just in case, check if the subview we are looping with has setTintColor method.
  if ([i respondsToSelector:@selector(setTintColor:)]) {
   [i setTintColor:[UIColor purpleColor]];
   //check that this UIImageView... well... actually has an image :P
   if (i.image) {
    i.image = [i.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
   }
  }
 }
 return origSubviews;
}
-(UIColor *)backgroundColor {
 return [UIColor purpleColor];
}
-(CALayer*)layer {
 CALayer* origLayer = %orig; //our origLayer is what this method would have originally returned
 origLayer.cornerRadius = 2.0; //set corner radius to 2.0
 return origLayer;
}
%end
