%group DISABLED
	%hook TGModernViewInlineMediaContext
	- (_Bool)isPlaybackActive{
		return YES;
	}
	%end
%end

%group MOD
	%hook TGModernViewInlineMediaContext
	- (_Bool)isPlaybackActive{
		return YES;
	}
	%end
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
	BOOL enabled = ([prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : NO);
	NSLog(@"[TELEGRAMPLAYBACK] %d",enabled);   
    if (enabled) {
        %init(MOD);
    }
    else{
    	%init(DISABLED);
    }
}