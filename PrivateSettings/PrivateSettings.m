//
//  PrivateSettings.m
//  PrivateSettings
//
//  Created by Hao Tan on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PrivateSettings.h"

@implementation PrivateSettings

static NSString * allFormat[] = {@"png",@"tiff",@"jpg",@"gif",@"pdf"};
static NSString * allMinEffect[] = {@"genie",@"scale",@"suck"};

#define kPrivateSettingsKeyShowFile         @"showFile"
#define kPrivateSettingsKeyShowFilePath     @"showFilePath"
#define kPrivateSettingsKeyCaptureFormat    @"captureFormat"
#define kPrivateSettingsKeyCapturePath      @"capturePath"
#define kPrivateSettingsKeyDockKind         @"dockKind"
#define kPrivateSettingsKeyDockMinEffect    @"dockMinEffect"
#define kPrivateSettingsKeyAirDropForce     @"airDropForce"

- (void)mainViewDidLoad
{
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
}

- (IBAction)showFileClick:(NSButton *)sender
{   
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.finder",@"AppleShowAllFiles",@"-bool", nil];
    
    if ([sender state]) 
    {
        [arguments addObject:@"true"];
    }else {
        [arguments addObject:@"false"];
    }
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    NSAppleScript *restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to quit"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"delay 1"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to activate"];
    [restartFinder executeAndReturnError:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[sender state]] forKey:kPrivateSettingsKeyShowFile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)showFilePathClick:(id)sender
{
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.finder",@"_FXShowPosixPathInTitle",@"-bool", nil];
    
    if ([sender state]) 
    {
        [arguments addObject:@"true"];
    }else {
        [arguments addObject:@"false"];
    }
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    NSAppleScript *restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to quit"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"delay 1"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to activate"];
    [restartFinder executeAndReturnError:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[sender state]] forKey:kPrivateSettingsKeyShowFilePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)captureFormatClick:(NSPopUpButton *)sender
{
    NSInteger index = [sender indexOfSelectedItem];
    NSString * currentType = allFormat[index];
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.screencapture",@"type",currentType, nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyCaptureFormat];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)capturePathClick:(NSPathControl *)sender
{
    NSString * currentPath = [sender.URL path];
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.screencapture",@"location",currentPath, nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentPath forKey:kPrivateSettingsKeyCapturePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)dockKinkClick:(NSMatrix *)sender
{
    NSInteger index = [sender selectedColumn];
    
    NSString *kind = nil;
    if (index == 0)
    {
        kind = @"false";
    }else {
        kind = @"true";
    }
    
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.dock",@"no-glass",@"-bool",kind, nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyDockKind];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSAppleScript *restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Dock\" to quit"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"delay 1"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Dock\" to activate"];
    [restartFinder executeAndReturnError:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyDockKind];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)dockMinEffectClick:(NSPopUpButton *)sender
{
    NSInteger index = [sender indexOfSelectedItem];
    NSString * currentType = allMinEffect[index];
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.dock",@"mineffect",currentType, nil];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    NSAppleScript *restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Dock\" to quit"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"delay 1"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Dock\" to activate"];
    [restartFinder executeAndReturnError:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:index] forKey:kPrivateSettingsKeyDockMinEffect];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)forceAirDropClick:(NSButton *)sender
{
    NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"write",@"com.apple.NetworkBrowser",@"BrowseAllInterfaces",@"-bool", nil];
    
    if ([sender state]) 
    {
        [arguments addObject:@"true"];
    }else {
        [arguments addObject:@"false"];
    }
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/defaults"];
    [task setArguments:arguments];
    [task launch];
    
    NSAppleScript *restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to quit"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"delay 1"];
    [restartFinder executeAndReturnError:nil];
    
    restartFinder = [[NSAppleScript alloc] initWithSource:@"tell application \"Finder\" to activate"];
    [restartFinder executeAndReturnError:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[sender state]] forKey:kPrivateSettingsKeyAirDropForce];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
