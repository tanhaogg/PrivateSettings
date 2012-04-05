//
//  PrivateSettings.h
//  PrivateSettings
//
//  Created by Hao Tan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface PrivateSettings : NSPreferencePane<NSAlertDelegate>
{
    IBOutlet NSButton *showFileButton;
    IBOutlet NSButton *showFilePathButton;
    
    IBOutlet NSPopUpButton *captureFormatButton;
    IBOutlet NSPathControl *capturePathControl;
    
    IBOutlet NSMatrix *dockKindMatrix;
    IBOutlet NSPopUpButton *dockMinEffectButton;
    
    IBOutlet NSButton *forceAirDropButton;
    IBOutlet NSPopUpButton *startBgButton;
    IBOutlet NSTextField *startBgPathField;
    IBOutlet NSButton *safeSleepModeButton;
    
    NSArray *allBoolValue;
    NSArray *allStartBg;
    NSArray *allMinEffect;
    NSArray *allFormat;
}

- (void)mainViewDidLoad;

- (IBAction)showFileClick:(NSButton *)sender;
- (IBAction)showFilePathClick:(id)sender;

- (IBAction)captureFormatClick:(NSPopUpButton *)sender;
- (IBAction)capturePathClick:(NSPathControl *)sender;

- (IBAction)dockKinkClick:(NSMatrix *)sender;
- (IBAction)dockMinEffectClick:(NSPopUpButton *)sender;

- (IBAction)forceAirDropClick:(NSButton *)sender;

- (IBAction)startBgSettingClick:(NSPopUpButton *)sender;
- (IBAction)safeSleepModeClick:(NSButton *)sender;

- (IBAction)purgeRAMClick:(id)sender;
- (IBAction)diskutilClick:(id)sender;

- (IBAction)uninstall:(id)sender;
- (IBAction)aboutClidk:(id)sender;

@end
