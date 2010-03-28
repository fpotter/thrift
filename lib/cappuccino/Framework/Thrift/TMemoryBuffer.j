
@import <Foundation/Foundation.j>
@import "TTransport.j"

@implementation TMemoryBuffer : TTransport
{
    CPMutableArray _bytes;
    int _readPosition;
}

- (id)init {
    if (self = [super init])
    {
        _bytes = [[CPMutableArray alloc] initWithCapacity:0];
        _readPosition = 0;
    }
    return self;
}

- (int)readAll:(CPArray)buffer offset:(int)offset length:(int)length
{
    var bytesAvailable = _bytes.length - _readPosition;
    
    if (length > bytesAvailable)
    {
        [CPException raise:CPInvalidArgumentException reason:"Asked to read " + length + " bytes, but only " + bytesAvailable + " bytes are available."];
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            buffer[offset + i] = _bytes[_readPosition++];
        }
    }
}

- (void)write:(CPArray)buffer offset:(int)offset length:(int)length
{
    if ((offset + length) > buffer.length)
    {
        [CPException raise:CPInvalidArgumentException reason:"(offset + length) == " + (offset + length) + " which is > bufffer.length of " + buffer.length];
        return;
    }
    else
    {
        for (var i = 0; i < length; i++)
        {
            [_bytes addObject:buffer[offset + i]];
        }
    }
}

- (CPString)contentsAsBase64
{
    return CFData.encodeBase64Array(_bytes);
}

@end