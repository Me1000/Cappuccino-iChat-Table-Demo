/*
 * AppController.j
 * chatdemo
 *
 * Created by You on February 24, 2011.
 * Copyright 2011, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "ChatWindowController.j"
@import "BuddyListController.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
}
        
- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(50,50,320,550) styleMask:CPClosableWindowMask|CPResizableWindowMask],
        newChatButton = [[CPButton alloc] initWithFrame:CGRectMake(15, 15, 290, 24)];

    [newChatButton setTitle:"Open New Chat Window"];
    [newChatButton setTarget:self];
    [newChatButton setAction:@selector(openNewChatWindow:)];

//    [[theWindow contentView] addSubview:newChatButton];

    var controller = [[BuddyListController alloc] initWithNewBuddyListForWinodw:theWindow];

    [theWindow orderFront:self];
}

@end
