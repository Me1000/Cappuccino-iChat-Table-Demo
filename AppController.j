/*
 * AppController.j
 * chatdemo
 *
 * Created by Randy Luecke on February 24, 2011.
 * Copyright 2011, RCLConcepts All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "ChatWindowController.j"
@import "BuddyListController.j"

@implementation AppController : CPObject

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var controller = [[BuddyListController alloc] init];
    [controller showWindow:self];
}

@end
