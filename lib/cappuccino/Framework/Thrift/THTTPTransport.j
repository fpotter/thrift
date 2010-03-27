
@implementation THTTPTransport
{
    CPURL _URL;
}

- (id)initWithURL:(CPURL)URL {
    if (self = [super init])
    {
        _URL = URL;
    }
    return self;
}

- (BOOL)isOpen {
    return false;
}

- (CPString)contentsAsBase64 {
    return "";
}

@end