
@import "../Framework/Thrift/Thrift.j"

// This file gets generated when you run the tests with "jake test"
@import "../gen-cappuccino/DebugProtoTest.j"

@implementation StructFieldTestCase : CPObject
{
    byte _type @accessors(property=type);
    short _fieldID @accessors(property=fieldID);
    Function _writeFunction @accessors(property=writeFunction);
    Function _readFunction @accessors(property=readFunction);
}

- (id)initWithType:(byte)type fieldID:(short)fieldID writeFunction:(Function)writeFunction readFunction:(Function)readFunction
{
    if (self = [super init])
    {
        _type = type;
        _fieldID = fieldID;
        _writeFunction = writeFunction;
        _readFunction = readFunction;
    }
    return self;
}

@end

@implementation TBinaryProtocolTest : OJTestCase
{
}

- (void)setUp
{
    [super setUp];
    
    // Show pretty stack traces
    objj_msgSend_decorate(objj_backtrace_decorator);
    
}

- (void)tearDown
{
} 

- (void)testNakedByte
{
    var buffer = [[TMemoryBuffer alloc] init];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
    
    [protocol writeByte:123];
    
    var out = [protocol readByte];
    
    [self assert:123 equals:out message:"Byte was supposed to be 123 but was " + out];
}

- (void)testNakedI16
{
    var testValue = function(input)
    {
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        [protocol writeI16:input];
        var output = [protocol readI16];
        
        if (input != output)
        {
            [self fail:"We should get the same thing back that we put in. [ Sent " + input + ", Recv " + output + "]"];            
        }
    }
    
    var testValues = [0, 1, 7, 150, 15000, 0x7fff, -1, -7, -150, -15000, -0x7fff];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testNakedI32
{
    var testValue = function(input)
    {
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        [protocol writeI32:input];
        var output = [protocol readI32];
        
        //print([CPString stringWithFormat:"input: %X output: %X", input, output]);
        
        if (input != output)
        {
            [self fail:"We should get the same thing back that we put in. [ Sent " + input + ", Recv " + output + "]"];            
        }
    }
    
    var testValues = [0, 1, 7, 150, 15000, 31337, 0xffff, 0xffffff, -1, -7, -150, -15000, -0xffff, -0xffffff];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testNakedI64
{
    var testValue = function(input)
    {
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        [protocol writeI64:input];
        var output = [protocol readI64];
        
        if (input != output)
        {
            [self fail:"We should get the same thing back that we put in. [ Sent " + input + ", Recv " + output + "]"];            
        }
    }
    
    var testValues = [];
    
    for (var i = 0; i < 62; i++)
    {
        testValues.push(1 << i);
    }
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testDouble
{
    var testValue = function(input)
    {
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        [protocol writeDouble:input];
        var output = [protocol readDouble];
        
        if (input != output)
        {
            [self fail:"We should get the same thing back that we put in. [ Sent " + input + ", Recv " + output + "]"];
        }
    }
    
    var testValues = [123.456];//, 0.0, 1232.402];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testNakedString
{
    var testValue = function(input)
    {
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        [protocol writeString:input];
        var output = [protocol readString];
        
        [self assert:input equals:output message:"Should get the same thing back that we put in."];
    }
    
    var testValues = ["", "short", "borderlinetiny", "a bit longer than the smallest possible"];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testNakedBinary
{
    var testValue = function(input)
    {
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        var inputBase64 = [CPData dataWithRawString:CFData.encodeBase64Array(input)];
        
        [protocol writeBinary:inputBase64];
        var outputBase64 = [protocol readBinary];
        
        var output = CFData.decodeBase64ToArray([outputBase64 rawString]);
        
        [self assert:input equals:output message:"Should get the same thing back that we put in."];
    }
    
    var testValues = [
        [],
        [0,1,2,3,4,5,6,7,8,9,10],
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    ];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testByteField
{    
    var testValue = function(input)
    {
        var writeFunction = function(protocol)
        {
            [protocol writeByte:input];
        };
        
        var readFunction = function(protocol)
        {
            var result = [protocol readByte];
            
            [self assert:result equals:input message:"Should get back what we put in."];
        };

        var testCase = [[StructFieldTestCase alloc] initWithType:TType_BYTE fieldID:15 writeFunction:writeFunction readFunction:readFunction];
        
        [self _testStructFieldHelper:testCase];
    }
    
    for (var i = 0; i < 128; i++)
    {
        testValue(i);
        testValue(-i);
    }
}

- (void)testI16Field
{    
    var testValue = function(input)
    {
        var writeFunction = function(protocol)
        {
            [protocol writeI16:input];
        };
        
        var readFunction = function(protocol)
        {
            var result = [protocol readI16];
            
            [self assert:result equals:input message:"Should get back what we put in."];
        };

        var testCase = [[StructFieldTestCase alloc] initWithType:TType_I16 fieldID:15 writeFunction:writeFunction readFunction:readFunction];
        
        [self _testStructFieldHelper:testCase];
    }
    
    var testValues = [0, 1, 7, 150, 15000, 0x7fff, -1, -7, -150, -15000, -0x7fff];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testI32Field
{    
    var testValue = function(input)
    {
        var writeFunction = function(protocol)
        {
            [protocol writeI32:input];
        };
        
        var readFunction = function(protocol)
        {
            var result = [protocol readI32];
            
            [self assert:input equals:result message:"Should get back what we put in."];
        };

        var testCase = [[StructFieldTestCase alloc] initWithType:TType_I32 fieldID:15 writeFunction:writeFunction readFunction:readFunction];
        
        [self _testStructFieldHelper:testCase];
    }
    
    var testValues = [0, 1, 7, 150, 15000, 31337, 0xffff, 0xffffff, -1, -7, -150, -15000, -0xffff, -0xffffff, -2147418111];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testI64Field
{    
    var testValue = function(input)
    {
        var writeFunction = function(protocol)
        {
            [protocol writeI64:input];
        };
        
        var readFunction = function(protocol)
        {
            var result = [protocol readI64];
            
            [self assert:result equals:input message:"Should get back what we put in."];
        };

        var testCase = [[StructFieldTestCase alloc] initWithType:TType_I32 fieldID:15 writeFunction:writeFunction readFunction:readFunction];
        
        [self _testStructFieldHelper:testCase];
    }
    
    var testValues = [];
    
    for (var i = 0; i < 62; i++)
    {
        testValues.push(1 << i);
    }
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testStringField
{    
    var testValue = function(input)
    {
        var writeFunction = function(protocol)
        {
            [protocol writeString:input];
        };
        
        var readFunction = function(protocol)
        {
            var result = [protocol readString];
            
            [self assert:result equals:input message:"Should get back what we put in."];
        };

        var testCase = [[StructFieldTestCase alloc] initWithType:TType_STRING fieldID:15 writeFunction:writeFunction readFunction:readFunction];
        
        [self _testStructFieldHelper:testCase];
    }
    
    var testValues = ["", "short", "borderlinetiny", "a bit longer than the smallest possible"];
    
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testBinaryField
{    
    var testValue = function(input)
    {
        var writeFunction = function(protocol)
        {
            [protocol writeBinary:[CPData dataWithRawString:CFData.encodeBase64Array(input)]];
        };
        
        var readFunction = function(protocol)
        {
            var result = CFData.decodeBase64ToArray([[protocol readBinary] rawString]);
            
            [self assert:result equals:input message:"Should get back what we put in."];
        };

        var testCase = [[StructFieldTestCase alloc] initWithType:TType_STRING fieldID:15 writeFunction:writeFunction readFunction:readFunction];
        
        [self _testStructFieldHelper:testCase];
    }
    
    var testValues = [
        [],
        [0,1,2,3,4,5,6,7,8,9,10],
        [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    ];
       
    for (var i = 0; i < testValues.length; i++)
    {
        testValue(testValues[i]);
    }
}

- (void)testMessage
{
    var testMessages = [
        ["short message name", TMessageType_CALL, 0],
        ["1", TMessageType_REPLY, 12345],
        ["loooooooooooooooooong", TMessageType_EXCEPTION, 1 << 16],
        ["Janky", TMessageType_CALL, 0]
    ];
    
    for (var i = 0; i < testMessages.length; i++)
    {
        var message = testMessages[i];
        var buffer = [[TMemoryBuffer alloc] init];
        var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
        [protocol writeMessageBeginWithName:message[0] type:message[1] sequenceID:message[2]];
        [protocol writeMessageEnd];
        
        var output = [protocol readMessageBeginReturningNameTypeSequenceID];
        
        [self assert:message[0] equals:output[0] message:"Should get back the same name we put in."];
        [self assert:message[1] equals:output[1] message:"Should get back the same type we put in."];
        [self assert:message[2] equals:output[2] message:"Should get back the same sequence ID we put in."];
    }
}

- (void)testSerialization
{
    [self _testSerializationHelper:[OneOfEach class] instance:[self fixtureForOneOfEach]];
    [self _testSerializationHelper:[Nesting class] instance:[self fixtureForNesting]];
}

- (id)fixtureForOneOfEach
{
    var oneOfEach = [[OneOfEach alloc] 
        initWithIm_true:true 
        im_false:false 
        a_bite:(0x42)
        integer16:27000 
        integer32:(1 << 24)
        integer64:6000 * 1000 * 1000
        double_precision:3.14
        some_characters:"JSON THIS!"
        zomg_unicode:"This should be some unicode"
        what_who:YES
        base64:[CPData dataWithRawString:"blah"]
        byte_list:[0, 1, 2, 3]
        i16_list:[0, 1, 2, 3, 4]
        i64_list:[0, 1, 2, 3, 5]];
    
    return oneOfEach;
}

- (id)fixtureForNesting
{
    var bonk = [[Bonk alloc] init];
    [bonk setType: 31337];
    [bonk setMessage:"I am a bonk... xor!"];

    var nesting = [[Nesting alloc] initWithMy_bonk:bonk my_ooe:[self fixtureForOneOfEach]];
    
    return nesting;
}

- (void)_testSerializationHelper:(Class)structClass instance:(id)instance
{
    var buffer = [[TMemoryBuffer alloc] init];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
        
    [instance write:protocol];

    var newInstance = [[structClass alloc] init];
    [newInstance read:protocol];

    [self assert:[instance description] equals:[newInstance description]];
}

- (void)_testStructFieldHelper:(StructFieldTestCase)structFieldTestCase
{
    var buffer = [[TMemoryBuffer alloc] init];
    var protocol = [[TBinaryProtocol alloc] initWithTransport:buffer];
    
    [protocol writeStructBeginWithName:"test_struct"];
    [protocol writeFieldBeginWithName:"test_field" type:[structFieldTestCase type] fieldID:[structFieldTestCase fieldID]];
    [structFieldTestCase writeFunction](protocol);
    [protocol writeFieldEnd]
    [protocol writeStructEnd];
    
    [protocol readStructBeginReturningName];
    var fieldBegin = [protocol readFieldBeginReturningNameTypeFieldID];
    
    [self assert:[structFieldTestCase type] equals:fieldBegin[1] message:"Field type should match the type we sent in."];
    [self assert:[structFieldTestCase fieldID] equals:fieldBegin[2] message:"Field ID should match the id we sent in."];
    
    [structFieldTestCase readFunction](protocol);
    [protocol readStructEnd];
};


@end