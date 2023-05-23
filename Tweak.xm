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

%hook SBIconLegibilityLabelView {
  -(CGColor*)_createCGColorWithAlpha : (CGFloat);
  return ^(CGColor =);
  _preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.mineek.glowieprefs"];
  _enabled = [_preferences objectForKey:@"enabled"] ? [[_preferences objectForKey:@"enabled"] boolValue] : YES;
  if (_enabled) {
    @property (nonatomic, copy, readwrite) UIColor;
    *backgroundColor = UIExtendedSRGBColorSpace 1 0 1 0.644175;
    % init();
  } else {
    return ();
  }
}