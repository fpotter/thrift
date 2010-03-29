
@import <Foundation/Foundation.j>
@import "TMemoryBuffer.j"

@implementation THTTPTransport : TMemoryBuffer
{
    CPString _URL;
}

- (id)initWithURL:(CPString)URL {
    if (self = [super init])
    {
        _URL = URL;
    }
    return self;
}

- (void)flush
{
    var url = [CPString stringWithFormat:"%@", _URL];
    var request = [CPURLRequest requestWithURL:url];
    [request setHTTPMethod:"POST"];
    [request setHTTPBody:[self contentsAsBase64]];

    var data = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];

    CPLog.info("in <<<< " + [data rawString]);

    [self setBufferContents:CFData.decodeBase64ToArray(unescape([data rawString]))];
}

@end