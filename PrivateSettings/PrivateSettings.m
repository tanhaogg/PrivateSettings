//
//  PrivateSettings.m
//  PrivateSettings
//
//  Created by Hao Tan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PrivateSettings.h"
#import "STPrivilegedTask.h"

@implementation PrivateSettings

#define kPrivateSettingsTypeBool    @"-bool"
#define kPrivateSettingsTypeString  @"-string"

#define kPrivateSettingsKeyShowFile         @"tanhao.me.showFile"
#define kPrivateSettingsKeyShowFilePath     @"tanhao.me.showFilePath"
#define kPrivateSettingsKeyCaptureFormat    @"tanhao.me.captureFormat"
#define kPrivateSettingsKeyCapturePath      @"tanhao.me.capturePath"
#define kPrivateSettingsKeyDockKind         @"tanhao.me.dockKind"
#define kPrivateSettingsKeyDockMinEffect    @"tanhao.me.dockMinEffect"

#define kPrivateSettingsKeyAirDropForce     @"tanhao.me.airDropForce"
#define kPrivateSettingsKeyStartBg          @"tanhao.me.startBg"
#define kPrivateSettingsKeySafeSleepModel   @"tanhao.me.safeSleepMode"

- (void)mainViewDidLoad
{
    [super mainViewDidLoad];   
    
    allBoolValue = [[NSArray alloc] initWithObjects:@"false",@"true", nil];
    allStartBg = [[NSArray alloc] initWithObjects:@"系统默认",@"用户定义",nil];
    allMinEffect = [[NSArray alloc] initWithObjects:@"genie",@"scale",@"suck",nil];
    allFormat = [[NSArray alloc] initWithObjects:@"png",@"tiff",@"jpg",@"gif",@"pdf",nil];
    
    NSNumber *showFile = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyShowFile];
    if (showFile)
    {
        [showFileButton setState:[showFile intValue]];
    }
    
    NSNumber *showFilePath = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyShowFilePath];
    if (showFilePath)
    {
        [showFilePathButton setState:[showFilePath intValue]];
    }
    
    NSNumber *captureFormat = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyCaptureFormat];
    if (captureFormat) 
    {
        [captureFormatButton selectItemAtIndex:[captureFormat intValue]];
    }
    
    NSString *capturePath = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyCapturePath];
    if (capturePath) 
    {
        [capturePathControl setURL:[NSURL fileURLWithPath:capturePath]];
    }else 
    {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
        if ([pathArray count] > 0)
        {
            [capturePathControl setURL:[NSURL fileURLWithPath:[pathArray objectAtIndex:0]]];
        }
    }
    
    NSNumber *dockKind = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyDockKind];
    [dockKindMatrix selectCellAtRow:0 column:[dockKind intValue]];
    
    NSNumber *dockMinEffect = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyDockMinEffect];
    if (dockMinEffect)
    {
        [dockMinEffectButton selectItemAtIndex:[dockMinEffect intValue]];
    }
    
    NSNumber *forceAirDrop = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyAirDropForce];
    if (forceAirDrop)
    {
        [forceAirDropButton setState:[forceAirDrop intValue]];
    }
    
    NSNumber *startBgType = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeyStartBg];
    int startBgTypeIdx = [startBgType intValue];
    NSString *startBgTypeString = [NSString stringWithString:[allStartBg objectAtIndex:startBgTypeIdx]];
    [startBgPathField setStringValue:startBgTypeString];
    
    NSNumber *safeSleepMode = [[NSUserDefaults standardUserDefaults] objectForKey:kPrivateSettingsKeySafeSleepModel];
    [safeSleepModeButton setState:[safeSleepMode intValue]];
}

- (void)defaultsTaskWithPlistFile:(NSString *)fileName changeKey:(NSString *)key changeType:(NSString *)type changeValue:(NSString *)value
{
    NSArray *arguments = [NSArray arrayWithObjects:@"write",fileName,key,type,value, nil];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    [task waitUntilExit];
}

- (void)killAllTaskWithName:(NSString *)name
{
    NSArray *arguments = [NSArray arrayWithObjects:name, nil];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:arguments];
    [task launch];
}

- (IBAction)showFileClick:(NSButton *)sender
{   
    [self defaultsTaskWithPlistFile:@"com.apple.finder" changeKey:@"AppleShowAllFiles" changeType:kPrivateSettingsTypeBool changeValue:[allBoolValue objectAtIndex:sender.state]];
    [self killAllTaskWithName:@"Finder"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:sender.state] forKey:kPrivateSettingsKeyShowFile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showFilePathClick:(NSButton *)sender
{
    [self defaultsTaskWithPlistFile:@"com.apple.finder" changeKey:@"_FXShowPosixPathInTitle" changeType:kPrivateSettingsTypeBool changeValue:[allBoolValue objectAtIndex:sender.state]];
    [self killAllTaskWithName:@"Finder"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:sender.state] forKey:kPrivateSettingsKeyShowFilePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)captureFormatClick:(NSPopUpButton *)sender
{    
    NSInteger index = [sender indexOfSelectedItem];
    NSString * currentType = [allFormat objectAtIndex:index];
    [self defaultsTaskWithPlistFile:@"com.apple.screencapture" changeKey:@"type" changeType:kPrivateSettingsTypeString changeValue:currentType];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyCaptureFormat];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)capturePathClick:(NSPathControl *)sender
{
    NSString * currentPath = [sender.URL path];
    [self defaultsTaskWithPlistFile:@"com.apple.screencapture" changeKey:@"location" changeType:kPrivateSettingsTypeString changeValue:currentPath];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentPath forKey:kPrivateSettingsKeyCapturePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)dockKinkClick:(NSMatrix *)sender
{
    NSInteger index = [sender selectedColumn];    
    [self defaultsTaskWithPlistFile:@"com.apple.dock" changeKey:@"no-glass" changeType:kPrivateSettingsTypeBool changeValue:[allBoolValue objectAtIndex:index]];
    [self killAllTaskWithName:@"Dock"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyDockKind];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)dockMinEffectClick:(NSPopUpButton *)sender
{
    NSInteger index = [sender indexOfSelectedItem];
    [self defaultsTaskWithPlistFile:@"com.apple.dock" changeKey:@"mineffect" changeType:kPrivateSettingsTypeString changeValue:[allMinEffect objectAtIndex:index]];
    [self killAllTaskWithName:@"Dock"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyDockMinEffect];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)forceAirDropClick:(NSButton *)sender
{
    [self defaultsTaskWithPlistFile:@"com.apple.NetworkBrowser" changeKey:@"BrowseAllInterfaces" changeType:kPrivateSettingsTypeBool changeValue:[allBoolValue objectAtIndex:sender.state]];
    [self killAllTaskWithName:@"Finder"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[sender state]] forKey:kPrivateSettingsKeyAirDropForce];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)startBgSettingClick:(NSPopUpButton *)sender
{
    NSString *sysStartBgFilePath = @"/System/Library/Frameworks/AppKit.framework/Versions/C/Resources/NSTexturedFullScreenBackgroundColor.png";
    NSString *userStartBgFilePath = nil;
    
    if ([sender indexOfSelectedItem] == 1)
    {
        [startBgPathField setStringValue:@"系统默认"];
        
        userStartBgFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"NSTexturedFullScreenBackgroundColor" ofType:@"png"];        
    }else 
    {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setCanChooseDirectories:NO];
        [openPanel setCanChooseFiles:YES];
        [openPanel setAllowsMultipleSelection:NO];
        
        NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"png", nil];
        int i = [openPanel runModalForTypes:fileTypes];
        if(i == NSOKButton)
        {
            NSString *selectedFilePath = [[openPanel filenames] objectAtIndex:0];
            [startBgPathField setStringValue:selectedFilePath];
            userStartBgFilePath = selectedFilePath;
        }
    }
    
    if (userStartBgFilePath)
    {
        NSArray *arguments = [NSArray arrayWithObjects:userStartBgFilePath,sysStartBgFilePath,nil];
        [STPrivilegedTask launchedPrivilegedTaskWithLaunchPath:@"/bin/cp" arguments:arguments];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[sender indexOfSelectedItem]] forKey:kPrivateSettingsKeyStartBg];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)safeSleepModeClick:(NSButton *)sender
{
    NSString *flag = nil;
    if (sender.state)
    {
        flag = @"3";
    }else {
        flag = @"0";
    }
    
    NSArray *arguments = [NSArray arrayWithObjects:@"-a",@"hibernatemode",flag,nil];
    [STPrivilegedTask launchedPrivilegedTaskWithLaunchPath:@"/usr/bin/pmset" arguments:arguments];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:sender.state] forKey:kPrivateSettingsKeySafeSleepModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)purgeRAMClick:(id)sender
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/purge"];
    [task launch];
}

- (IBAction)diskutilClick:(id)sender
{
    NSArray *arguments = [NSArray arrayWithObjects:@"repairpermissions",@"/",nil];
    NSTask *task = [[NSTask alloc] init];
    [task setArguments:arguments];
    [task setLaunchPath:@"/usr/sbin/diskutil"];
    [task launch];
}

- (IBAction)uninstall:(id)sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"你确认要删除我吗？" defaultButton:@"下定决心" alternateButton:@"我后悔了" otherButton:nil informativeTextWithFormat:@"删除后重新启动\"系统偏好设置\",我就彻底与你告别了！"];
    
    [alert beginSheetModalForWindow:[self.mainView window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == NSAlertDefaultReturn)
    {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle bundlePath];
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
}

- (IBAction)aboutClidk:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.tanhao.me"]];
}

#pragma mark -
#pragma mark NSPathControlDelegate

- (void)pathControl:(NSPathControl *)pathControl willDisplayOpenPanel:(NSOpenPanel *)openPanel
{
    [openPanel setCanChooseFiles:NO];
}

@end
