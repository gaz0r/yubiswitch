//  PreferencesController.m
//  yubiswitch

/*
 yubiswitch - enable/disable yubikey
 Copyright (C) 2013  Angelo "pallotron" Failla <pallotron@freaknet.org>
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "PreferencesController.h"

@interface PreferencesController ()

@end

@implementation PreferencesController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        controller = [NSUserDefaultsController sharedUserDefaultsController];
        NSString *defaultPrefsFile = [[NSBundle mainBundle]
                                      pathForResource:@"DefaultPreferences"
                                      ofType:@"plist"];
        NSDictionary *defaultPrefs = [NSDictionary
                                dictionaryWithContentsOfFile:defaultPrefsFile];
        
        [controller setInitialValues:defaultPrefs];
        [controller setAppliesImmediately:FALSE];
        SRrecorder = [[SRRecorderControl alloc] init];
    }
    return self;
}

-(IBAction)SetDefaultsButton:(id)sender {
    NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]
     removePersistentDomainForName:domainName];
    [controller revertToInitialValues:self];
}

-(IBAction)OKButton:(id)sender {
    [controller save:self];
    // TODO: notify YubiKey and AppDelegate classes
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"changeDefaultsPrefs" object:self];
    [[self window] close];
}

-(IBAction)CancelButton:(id)sender {
    [controller revert:self];
    [[self window] close];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window
    // controller's window has been loaded from its nib file.
}

@end