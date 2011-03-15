@import "ChatTableDataView.j"

var botReplies = ["Hello", "How are you?", "I think Cappuccino is awesome.", "CPTableView is a very powerful component. with features like variable row height, group rows, and custom data views it can be used just about anywhere.", "I am a bot.", "Some of my replies are smart, some are random."];

@implementation ChatWindowController : CPWindowController
{
    CPScrollView tableScrollView;
    CPTableView  chatTableView;
    CPArray      chatLogData;

    CPTextField  chatTextField;

    ChatTableDataView  cachedChatBubbleView;

    CPSound      messageAlertSound;

    CPDictionary theUser;
}

- (id)initWithNewChatWindow
{
    self = [super init];

    if (self)
    {
        var chatWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(100,100,320,350) styleMask:CPClosableWindowMask|CPResizableWindowMask],
            contentView = [chatWindow contentView];

        [chatWindow setMinSize:CGSizeMake(310, 150)];
        [chatWindow setDelegate:self];

        [self setWindow:chatWindow];

        // position the textfield at the bottom of the window
        chatTextField = [[CPTextField alloc] initWithFrame:CGRectMake(20, 310, 280, 29)];

        [chatTextField setEditable:YES];
        [chatTextField setBezeled:YES];
        [chatTextField setTarget:self];
        [chatTextField setAction:@selector(sendMessage:)];

        [chatTextField setAutoresizingMask:CPViewWidthSizable|CPViewMinYMargin];
        [contentView addSubview:chatTextField];

        chatLogData = [ ];


        chatTableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero()];
        [chatTableView setHeaderView:nil];
        [chatTableView setCornerView:nil];
//        [chatTableView setSelectionHighlightStyle:CPTableViewSelectionHighlightStyleNone];
        [chatTableView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];

        var chatColumn = [[CPTableColumn alloc] initWithIdentifier:"chatColumn"];
        [chatColumn setWidth:320];
        [chatColumn setDataView:[[ChatTableDataView alloc] init]];
        [chatTableView addTableColumn:chatColumn];


        tableScrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(-1,-1,322, 296)];
        [tableScrollView setAutohidesScrollers:YES];
        [tableScrollView setBorderType:CPLineBorder];
        [tableScrollView setDocumentView:chatTableView];
        [tableScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [contentView addSubview:tableScrollView];

        [chatTableView setDataSource:self];
        [chatTableView setDelegate:self];

        // for variable row height calculations
        cachedChatBubbleView  = [[ChatTableDataView alloc] initWithFrame:CGRectMakeZero()];

        [chatWindow makeFirstResponder:chatTextField];

        messageAlertSound = [[CPSound alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:"whoop.mp3"] byReference:nil];
    }

    return self;
}

- (void)windowDidMove:(CPNotification)aNote
{
    [[self window] makeFirstResponder:chatTextField];
}

- (BOOL)windowShouldClose:(CPWindow)aWindow
{
    [theUser setObject:nil forKey:"chat"];
    return YES;
}

- (void)setChatPerson:(CPDictionary)aUser
{


    theUser = aUser;

    [[self window] setTitle:[aUser objectForKey:"name"]];
    [aUser setObject:self forKey:"chat"];
}

- (void)sendMessage:(id)sender
{
    var value = [sender stringValue];

    if (!value)
        return;

    var message = [CPDictionary dictionary];

    [message setObject:"Me" forKey:"user"];
    [message setObject:value forKey:"message"];

    [chatLogData addObject:message];

    [sender setStringValue:""];

    [chatTableView reloadData];

    [chatTableView scrollRowToVisible:[chatTableView numberOfRows] - 1];
    [messageAlertSound play];

    window.setTimeout(function(){
        [self generateBotReplyWithMessage:value];
        [chatTableView reloadData];

        [chatTableView scrollRowToVisible:[chatTableView numberOfRows] - 1];
        [messageAlertSound play];
    },800)
}

- (void)generateBotReplyWithMessage:(CPString)aMessage
{
    aMessage = [aMessage lowercaseString];

    if (aMessage.match("hello") || aMessage.match("hi"))
        var reply = "Hello";
    else if (aMessage.match("bye") || aMessage.match("goodbye"))
        var reply = "Goodbye";
    else
        var reply = botReplies[FLOOR(([botReplies count])*RAND())];

    var message = [CPDictionary dictionary];

    [message setObject:"Guest" forKey:"user"];
    [message setObject:reply forKey:"message"];

    [chatLogData addObject:message];
}

- (int)numberOfRowsInTableView:(CPTableView)aTableView
{
    return [chatLogData count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aColumn row:(int)aRow
{
    return [chatLogData objectAtIndex:aRow];
}

- (int)tableView:(CPTableView)aTableView heightOfRow:(int)aRow
{

    [cachedChatBubbleView setObjectValue:[chatLogData objectAtIndex:aRow]];
    [cachedChatBubbleView setFrameSize:CGSizeMake(CGRectGetWidth([chatTableView frame]), 35)];

    return [cachedChatBubbleView minHeightOfRow];
}


- (BOOL)tableView:(CPTableView)aTableView isGroupRow:(int)aRow
{
    return YES;
}
- (void)windowDidResize:(CPWindow)aWindow
{
    [chatTableView noteHeightOfRowsWithIndexesChanged:[CPIndexSet indexSetWithIndexesInRange:CPMakeRange(0, [chatTableView numberOfRows])]];
}

@end