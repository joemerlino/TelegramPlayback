#import <UIKit/UIKit.h>

%group MIC
	BOOL first = YES;
	%hook TGModernConversationInputTextPanel
	- (void)micButtonInteractionBegan{
		if(first)
			%orig;
	}
	- (void)micButtonInteractionCompleted:(CGFloat)velocity{
		if(!first){
			first = YES;
			%orig;
		}
		else
			first = NO;
	}
	%end
%end

%group MOD
	%hook TGModernConversationController
	- (void)viewWillDisappear:(BOOL)animated{
		return ;
	}
	%end
	%hook TGModernConversationAudioPlayer
	- (void)dealloc{
		return ;
	}
	%end
	%hook TGNativeAudioPlayer
	- (void)dealloc{
		return ;
	}
	%end
%end

static void PreferencesCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	CFPreferencesAppSynchronize(CFSTR("com.joemerlino.telegramplayback"));
}

%ctor
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesCallback, CFSTR("com.joemerlino.telegramplayback.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.joemerlino.telegramplayback.plist"];
	BOOL enabled = ([prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES);
	BOOL mic = ([prefs objectForKey:@"mic"] ? [[prefs objectForKey:@"mic"] boolValue] : NO);
	NSLog(@"[TELEGRAMPLAYBACK] ENABLED %d MIC %d", enabled, mic);   
    if (enabled)
        %init(MOD);
    if (mic)
    	%init(MIC);
}