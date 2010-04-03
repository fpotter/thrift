@import <Foundation/Foundation.j>
@import "TTransport.j"

var DefaultTimeout = 30;

@implementation TJSONPTransport : TTransport
{
    CPString _URL;
    Function _requestFinishedCallback;
    
    CPArray _requestData;
    CPArray _responseData;
    int _responsePosition;
    
    CPJSONPConnection _activeConnection;
    CPTimer _timeoutTimer;
}

- (id)initWithURL:(CPString)URL {
    if (self = [super init])
    {
        _URL = URL;
        _requestData = [];
        _responseData = [];
        _responsePosition = 0;
    }
    return self;
}

- (int)readAll:(CPArray)buffer offset:(int)offset length:(int)length
{
    var bytesAvailable = _responseData.length - _responsePosition;
    
    if (length > bytesAvailable)
    {
        [CPException raise:CPInvalidArgumentException reason:"Asked to read " + length + " bytes, but only " + bytesAvailable + " bytes are available."];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            buffer[offset + i] = _responseData[_responsePosition++];
        }
    }
}

- (void)write:(CPArray)buffer offset:(int)offset length:(int)length
{
    if ((offset + length) > buffer.length)
    {
        [CPException raise:CPInvalidArgumentException reason:"(offset + length) == " + (offset + length) + " which is > bufffer.length of " + buffer.length];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            [_requestData addObject:buffer[offset + i]];
        }
    }
}

- (void)flush
{
    if (_activeConnection != nil)
    {
        [CPException raise:CPInternalInconsistencyException reason:"Cannot flush transport while a flush is already in progress."];
    }
    else
    {    
        var body = CFData.encodeBase64Array(_requestData);
        _requestData = [];

        var url = [CPString stringWithFormat:"%@?body=%@", _URL, escape(body)];
        var request = [CPURLRequest requestWithURL:url];
    
        CPLog.info("TJSONPTransport: Sent " + body.length + " bytes to " + _URL);

        _timeoutTimer = [CPTimer scheduledTimerWithTimeInterval:DefaultTimeout target:self selector:@selector(connectionTimedOut) userInfo:nil repeats:NO];
        _activeConnection = [[CPJSONPConnection alloc] initWithRequest:request callback:"callback" delegate:self startImmediately:YES];
    }
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPString)data
{
    var error = nil;

    CPLog.info("TJSONPTransport: Received " + data.length + " bytes from " + _URL);

    if (data != nil && [data length] > 0)
    {
        try 
        {
            _responsePosition = 0;
            _responseData = CFData.decodeBase64ToArray(unescape(data));
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
    
    [_activeConnection cancel];
    _activeConnection = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    
    // This should always be the last thing we do, as the callback could immediately
    // trigger another flush.  We need all our state to be cleaned up before that happens.
    [self performCallbackWithError:error];    
}

- (void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
    _activeConnection = nil;
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;

    // This should always be the last thing we do, as the callback could immediately
    // trigger another flush.  We need all our state to be cleaned up before that happens.
    [self performCallbackWithError:true];
}

- (void)connectionTimedOut
{
    [_activeConnection cancel];
    _activeConnection = nil;
    
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
    
    // This should always be the last thing we do, as the callback could immediately
    // trigger another flush.  We need all our state to be cleaned up before that happens.
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
}

- (void)setRequestFinishedCallack:(Function)callback
{
    _requestFinishedCallback = callback;
}

@end