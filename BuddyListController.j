/*ChatStatus*/
ChatStatusOffline = 0;
ChatStatusActive  = 1;
ChatStatusAway    = 2;
ChatStatusIdle    = 3;

var resourceImage = function (resourcePath, size)
{
    return [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:resourcePath] size:size];
}

var buddies1 = 
[
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Francisco", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Tom", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Nick", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Koen", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Klapy", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Alexander", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Ross", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusAway}]
],

buddies2 = 
[
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Bob", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"John", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Sam", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Ross", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusActive}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Bill", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusAway}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Alex", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusAway}],
    [CPDictionary dictionaryWithJSObject:{"type":"user", "chat":nil, "name":"Scott", "avatar":resourceImage("guest-avatar.png", CGSizeMake(30, 30)), "status":ChatStatusAway}]
]

@implementation BuddyListController : CPObject
{
    CPOutlineView buddyList;
    CPScrollView  buddyListScrollView;

    CPArray       buddyGroups;
}

- (id)initWithNewBuddyListForWinodw:(CPWindow)aWindow
{
    self = [super init];

    if (self)
    {
        [aWindow setMinSize:CGSizeMake(310, 150)];
        var contentView = [aWindow contentView];

        buddyListScrollView = [[CPScrollView alloc] initWithFrame:[contentView bounds]];
        [buddyListScrollView setAutoresizingMask:CPViewWidthSizable|CPViewHeightSizable];
        buddyList = [[CPOutlineView alloc] initWithFrame:CGRectMakeZero()];
        [buddyList setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleRegular];
        [buddyList setUsesAlternatingRowBackgroundColors:YES];

        var buddiesColumn = [[CPTableColumn alloc] initWithIdentifier:"buddieslist"];
        [buddiesColumn setDataView:[[BuddyListDataView alloc] init]];
        [buddyList addTableColumn:buddiesColumn];

        [buddyListScrollView setDocumentView:buddyList];
        [contentView addSubview:buddyListScrollView];

        var group1 = [CPDictionary dictionaryWithObjects:["Buddies", buddies2, "group"] forKeys:["value", "buddies", "type"]];
        var group2 = [CPDictionary dictionaryWithObjects:["Co-Workers", buddies1, "group"] forKeys:["value", "buddies", "type"]];

        buddyGroups = [group1, group2];

        [buddyList setDelegate:self];
        [buddyList setDataSource:self];

        [buddyList sizeLastColumnToFit];
        [buddyList setHeaderView:nil];
        [buddyList setCornerView:nil];
        [buddyList setTarget:self];
        [buddyList setDoubleAction:@selector(openChat:)];
        [buddyList setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];

        [buddyList expandItem:nil expandChildren:YES];
    }

    return self;
}

- (void)openChat:(id)sender
{
    var point = [buddyList convertPoint:[[CPApp currentEvent] locationInWindow] fromView:nil];

    var item = [buddyList itemAtRow:[buddyList rowAtPoint:point]];


    if (!item || [item objectForKey:"type"] === "group")
        return;

    var controller = [item objectForKey:"chat"];

    if (controller && ![controller isKindOfClass:[CPNull class]])
    {
        [controller showWindow:self];
        return;
    }

    var controller = [[ChatWindowController alloc] initWithNewChatWindow];
    [controller showWindow:self];
    [controller setChatPerson:item];
}

- (id)outlineView:(CPOutlineView)outlineView child:(CPInteger)index ofItem:(id)item
{
    if (!item)
        return buddyGroups[index];

    return [[item objectForKey:"buddies"] objectAtIndex:index];
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    return [buddyGroups containsObject:item];
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    if (!item)
        return [buddyGroups count];

    if ([item isKindOfClass:[CPDictionary class]] && [item objectForKey:"type"] === "group")
        return [[item objectForKey:"buddies"] count];

    return 0;
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item;
{
    return item;
}


- (BOOL)outlineView:(CPOutlineView)outlineView isGroupItem:(id)item
{
    return [item isKindOfClass:[CPDictionary class]] && [item objectForKey:"type"] === "group";
}

- (int)outlineView:(CPOutlineView)outlineView heightOfRowByItem:(id)item
{
    return ([item isKindOfClass:[CPDictionary class]] && [item objectForKey:"type"] === "group") ? 20 : 35;
}

- (BOOL)outlineView:(CPOutlineView)outlineView shouldSelectItem:(id)item
{
    return !([item isKindOfClass:[CPDictionary class]] && [item objectForKey:"type"] === "group");
}

@end



@implementation BuddyListDataView : CPView
{
    CPImageView avatar;
    CPTextField displayName;
    CPImageView statusIcon;
    CPTextField statusText;

    CPTextField groupName;

    id          representedObjectValue;
}


- (void)layoutSubviews
{
    if ([representedObjectValue objectForKey:"type"] !== "group")
    {
        var frame = [self frame];
        [self setFrame:CGRectMake(0, frame.origin.y, frame.size.width + frame.origin.x, frame.size.height)];

        [avatar setFrame:CGRectMake(frame.size.width - 35, 2, 30, 30)];
    }

    [super layoutSubviews];
        
}

- (void)setObjectValue:(id)aValue
{
    representedObjectValue = aValue
    // Two types of JS objects can be expected:
    // 1. group {"type":"group", "value":"A Group Name"}
    // 2. user {"type":"user", "name":"My Buddy", "avatar":"url to avatar", "status":"ChatStatus"}

    if ([representedObjectValue objectForKey:"type"] === "group")
    {
        [avatar removeFromSuperview];
        [displayName removeFromSuperview];
        [statusIcon removeFromSuperview];
        [statusText removeFromSuperview];

        if (!groupName)
        {
            // MAKE IT!
            groupName = [[CPTextField alloc] initWithFrame:[self bounds]];
            [groupName setThemeState:CPThemeStateTableDataView|CPThemeStateGroupRow];
        }

        [self addSubview:groupName];

        [groupName setStringValue:[representedObjectValue objectForKey:"value"]];
    }
    else
    {
        // quick hack
        var frame = [self frame];
        [self setFrame:CGRectMake(0, frame.origin.y, frame.size.width + frame.origin.x, frame.size.height)];

        // normal shit
        [groupName removeFromSuperview];

        if (!displayName)
        {
            // Make all of them
            var totalWidth = CGRectGetWidth([self bounds]),
                totalHeight = CGRectGetHeight([self bounds]);

            displayName = [[CPTextField alloc] initWithFrame:CGRectMake(25, 5, totalWidth - 70, 16)];
            statusText  = [[CPTextField alloc] initWithFrame:CGRectMake(25, 20, totalWidth - 70, 16)];

            [statusText setFont:[CPFont systemFontOfSize:11]];
            [statusText setTextColor:[CPColor grayColor]];

            avatar      = [[CPImageView alloc] initWithFrame:CGRectMake(totalWidth - 35, 2, 30, 30)];
            statusIcon  = [[CPImageView alloc] initWithFrame:CGRectMake(5, (totalHeight / 2 - 8), 16, 16)];

            [avatar setAutoresizingMask:CPViewMinXMargin];
        }

        [displayName setStringValue:[representedObjectValue objectForKey:"name"]];
        [avatar setImage:[representedObjectValue objectForKey:"avatar"]];
        [statusText setStringValue:[self stringValueForStatus:[representedObjectValue objectForKey:"status"]]];
        [statusIcon setImage:[self imageValueForStatus:[representedObjectValue objectForKey:"status"]]];


        [self addSubview:avatar];
        [self addSubview:displayName];
        [self addSubview:statusIcon];
        [self addSubview:statusText];
    }
}

- (CPString)stringValueForStatus:(id)aStatus
{
    switch (aStatus)
    {
        case ChatStatusOffline:
            return "Offline";
            break;

        case ChatStatusActive:
            return "Online";
            break;

        case ChatStatusAway:
            return "Away";
            break;

        case ChatStatusIdle:
            return "Idle";
            break;
    }
}

- (CPString)imageValueForStatus:(id)aStatus
{
    switch (aStatus)
    {
        case ChatStatusOffline:
            return resourceImage("status-away.png", CGSizeMake(16, 16));
            break;

        case ChatStatusActive:
            return resourceImage("status-available.png", CGSizeMake(16, 16));
            break;

        case ChatStatusAway:
            return resourceImage("status-away.png", CGSizeMake(16, 16));
            break;

        case ChatStatusIdle:
            return resourceImage("status-away.png", CGSizeMake(16, 16));
            break;
    }
}

- (void)setThemeState:(id)aState
{
    if (aState === CPThemeStateSelectedTableDataView)
    {
        [displayName setTextColor:[CPColor whiteColor]];
        [statusText setTextColor:[CPColor whiteColor]];
    }
}

- (void)unsetThemeState:(id)aState
{
    if (aState === CPThemeStateSelectedTableDataView)
    {
        [displayName setTextColor:[CPColor blackColor]];
        [statusText setTextColor:[CPColor grayColor]];
    }
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    groupName = [aCoder decodeObjectForKey:"ChatDataViewGroupName"];
    avatar = [aCoder decodeObjectForKey:"ChatDataViewAvatar"];
    displayName = [aCoder decodeObjectForKey:"ChatDataViewDisplayName"];
    statusIcon = [aCoder decodeObjectForKey:"ChatDataViewStatusIcon"];

    return self;
}

- (void)encoderWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:groupName forKey:"ChatDataViewGroupName"];
    [aCoder encodeObject:avatar forKey:"ChatDataViewAvatar"];
    [aCoder encodeObject:displayName forKey:"ChatDataViewDisplayName"];
    [aCoder encodeObject:statusIcon forKey:"ChatDataViewStatusIcon"];

    [super encodeWithCoder:aCoder];
}

@end








