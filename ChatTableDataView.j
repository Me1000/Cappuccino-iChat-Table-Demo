var recievedBubbleImage = nil,
    sentBubbleImage = nil,
    guestAvatar = nil,
    cappAvatar = nil;

@implementation ChatTableDataView : CPView
{
    CPTextField messageText;
    CPImageView userAvatar;

    CPDictionary representedMessage;
}

+ (void)initialize
{
    var bundle = [CPBundle mainBundle];

    var recievedImageParts = [
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_01.png"] size:CGSizeMake(22, 21)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_02.png"] size:CGSizeMake(7, 21)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_03.png"] size:CGSizeMake(11, 21)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_04.png"] size:CGSizeMake(22, 2)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_05.png"] size:CGSizeMake(7, 2)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_06.png"] size:CGSizeMake(11, 2)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_07.png"] size:CGSizeMake(22, 13)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_08.png"] size:CGSizeMake(7, 13)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"blue-bubble_09.png"] size:CGSizeMake(11, 13)]
    ];

    recievedBubbleImage = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:recievedImageParts]];

    var sentImageParts = [
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_01.png"] size:CGSizeMake(11, 21)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_02.png"] size:CGSizeMake(7, 21)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_03.png"] size:CGSizeMake(22, 21)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_04.png"] size:CGSizeMake(11, 2)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_05.png"] size:CGSizeMake(7, 2)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_06.png"] size:CGSizeMake(22, 2)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_07.png"] size:CGSizeMake(11, 13)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_08.png"] size:CGSizeMake(7, 13)],
        [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:"green-bubble_09.png"] size:CGSizeMake(22, 13)]
    ];

    sentBubbleImage = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:sentImageParts]];
}

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        messageText = [aCoder decodeObjectForKey:"messageText"];
        userAvatar = [aCoder decodeObjectForKey:"userAvatar"];
    }

    return self;
}

- (void)encodeWithCoder(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:messageText forKey:"messageText"];
    [aCoder encodeObject:userAvatar forKey:"userAvatar"];
}

- (void)layoutSubviews
{
    // set up the ivars if they dont exist.
    if (!messageText)
    {
        messageText = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [messageText setLineBreakMode:CPLineBreakByWordWrapping];
        [self addSubview:messageText];
    }

    if (!userAvatar)
    {
        userAvatar = [[CPImageView alloc] initWithFrame:CGRectMakeZero()];
        [userAvatar setImageScaling:CPScaleProportionally];
        [self addSubview:userAvatar];
    }

    if (!guestAvatar)
        guestAvatar = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:"guest-avatar.png"] size:CGSizeMake(35, 35)];

    if (!cappAvatar)
        cappAvatar = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:"cappuccino-avatar.png"] size:CGSizeMake(35, 35)];

    // If the message is from "me"
    var frame = [self frame];
    if ([representedMessage objectForKey:"user"] === "Me")
    {
        [userAvatar setImage:cappAvatar];
        [userAvatar setFrame:CGRectMake(CGRectGetMaxX(frame) - 40, 5, 35, 35)];

        [messageText setFrame:CGRectMake(65, 2, CGRectGetWidth(frame) - 102, 36)];
        [messageText setStringValue:[representedMessage objectForKey:"message"]];
        [messageText setValue:CGInsetMake(10.0, 25.0, 10.0, 5.0) forThemeAttribute:"content-inset"];
        [messageText setAlignment:CPRightTextAlignment];

        [messageText setBackgroundColor:sentBubbleImage];
    }
    else
    {
        [userAvatar setImage:guestAvatar];
        [userAvatar setFrame:CGRectMake(5, 5, 35, 35)];

        [messageText setFrame:CGRectMake(45, 2, CGRectGetWidth(frame) - 102, 36)];
        [messageText setStringValue:[representedMessage objectForKey:"message"]];
        [messageText setValue:CGInsetMake(10.0, 5.0, 10.0, 25.0) forThemeAttribute:"content-inset"];
        [messageText setAlignment:CPLeftTextAlignment];

        [messageText setBackgroundColor:recievedBubbleImage];
    }

    [messageText sizeToFit];

    if (CGRectGetHeight([messageText bounds]) < 36)
        [messageText setFrameSize:CGSizeMake(CGRectGetWidth([messageText bounds]), 36)];

}

- (int)minHeightOfRow
{
    [self layoutSubviews];
    return MAX(CGRectGetHeight([messageText bounds]) + 15, 36);
}

- (void)setObjectValue:(id)anObjectValue
{
    representedMessage = anObjectValue;
    [self setNeedsLayout];
}

@end