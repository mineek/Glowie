#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <objc/runtime.h>

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
 id origSubviews = %orig; //origSubviews is what this method would have originally returned, ex the original subviews for this UIView - credit to Snoolie for the code snippet :3
 //loop through the original subviews
 for (id i in origSubviews){
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
-(id)layer {
 id origLayer = %orig; //our origLayer is what this method would have originally returned
 origLayer.cornerRadius = 2.0; //set corner radius to 2.0
}
%end