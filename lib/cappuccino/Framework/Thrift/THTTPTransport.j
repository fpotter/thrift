
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
    // Appending base64=true tells the server that we wish to encode everything in Base64
    var url = [CPString stringWithFormat:"%@?base64=true", _URL];
    var request = [CPURLRequest requestWithURL:url];
    [request setHTTPMethod:"POST"];
    [request setHTTPBody:[self contentsAsBase64]];

    var data = [CPURLConnection sendSynchronousRequest:request returningResponse:nil];

    [self setBufferContents:CFData.decodeBase64ToArray(unescape([data rawString]))];
}

@end