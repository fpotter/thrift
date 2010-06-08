
@implementation TProtocolUtilTest : OJTestCase
{
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
} 

- (void)testCanSkipAMap
{
    var buffer = [[TMemoryBuffer alloc] init];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];

    // Write out a map
    [protocol writeMapBeginWithKeyType:TType_STRING valueType:TType_I32 size:3];
    [protocol writeString:"one"];
    [protocol writeI32:1];
    [protocol writeString:"two"];
    [protocol writeI32:2];
    [protocol writeString:"three"];
    [protocol writeI32:3];    
    [protocol writeMapEnd]

    // We'll test to see if this is at the end later
    [protocol writeString:"Can you see me?"];
    
    [TProtocolUtil skipType:TType_MAP onProtocol:protocol];

    [self assert:"Can you see me?" equals:[protocol readString]];
}

- (void)testCanSkipAList
{
    var buffer = [[TMemoryBuffer alloc] init];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];

    // Write out a list
    [protocol writeListBeginWithElementType:TType_STRING size:3];
    [protocol writeString:"one"];
    [protocol writeString:"two"];
    [protocol writeString:"three"];
    [protocol writeListEnd]

    // We'll test to see if this is at the end later
    [protocol writeString:"Can you see me?"];
    
    [TProtocolUtil skipType:TType_LIST onProtocol:protocol];

    [self assert:"Can you see me?" equals:[protocol readString]];
}

- (void)testCanSkipASet
{
    var buffer = [[TMemoryBuffer alloc] init];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];

    // Write out a list
    [protocol writeSetBeginWithElementType:TType_STRING size:3];
    [protocol writeString:"one"];
    [protocol writeString:"two"];
    [protocol writeString:"three"];
    [protocol writeSetEnd]

    // We'll test to see if this is at the end later
    [protocol writeString:"Can you see me?"];
    
    [TProtocolUtil skipType:TType_SET onProtocol:protocol];

    [self assert:"Can you see me?" equals:[protocol readString]];
}

@end