
@import <Foundation/Foundation.j>
@import "TMemoryBuffer.j"

var DefaultTimeout = 30;

@implementation TJSONPTransport : TMemoryBuffer
{
    CPString _URL;
    Function _requestFinishedCallback;
    
    CPJSONPConnection _activeConnection;
    CPTimer _timeoutTimer;
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
    var body = [self contentsAsBase64];

    var url = [CPString stringWithFormat:"%@?body=%@", _URL, escape(body)];
    var request = [CPURLRequest requestWithURL:url];

    _timeoutTimer = [CPTimer scheduledTimerWithTimeInterval:DefaultTimeout target:self selector:@selector(connectionTimedOut) userInfo:nil repeats:NO];
    _activeConnection = [[CPJSONPConnection alloc] initWithRequest:request callback:"callback" delegate:self startImmediately:YES];
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPString)data
{
    var error = nil;

    if (data != nil && [data length] > 0)
    {
        try 
        {
            [self setBufferContents:CFData.decodeBase64ToArray(unescape(data))];
        }
        catch (e)
        {
            // It probably wasn't valid base64
            error = [CPException exceptionWithName:"TTransportException" reason:"Failed to parse base64 response from server." userInfo:nil];
        }
    }
    else
    {
        error = [CPException exceptionWithName:"TTransportException" reason:"Got empty response from server." userInfo:nil];
    }

    [self performCallbackWithError:error];
    _activeConnection = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
}

- (void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
    [self performCallbackWithError:true];
    _activeConnection = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
}

- (void)connectionTimedOut
{
    [_activeConnection cancel];
    _activeConnection = nil;
    
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    
    [self performCallbackWithError:[CPException exceptionWithName:"TTransportException" reason:"Timed out while waiting for response." userInfo:nil]];
}

- (void)performCallbackWithError:(id)error
{
    if (_requestFinishedCallback != nil)
    {
        _requestFinishedCallback(error);
    }
    else
    {
        [CPException raise:CPInternalInconsistencyException reason:"Got result from Thrift server but no callback function was set."];
    }
    _requestFinishedCallback = nil;
}

- (void)setRequestFinishedCallack:(Function)callback
{
    _requestFinishedCallback = callback;
}

@end