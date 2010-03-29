
@import "../Framework/Thrift/Thrift.j"

@implementation TMemoryBufferTest : OJTestCase
{
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
} 

- (void)testCanCreateInstance
{
    var instance = [[TMemoryBuffer alloc] init];
}

- (void)testCanWriteASeriesOfBytesAndGetBase64Result
{
    instance = [[TMemoryBuffer alloc] init];
    
    [instance write:[77, 97, 110] offset:0 length:3];  // M, a, n
    
    var string = [instance contentsAsBase64];
    
    [self assert:string equals:"TWFu" message:"Writing many bytes at once works."];
}

- (void)testCanRestoreMemoryBufferFromBase64
{
    var instance = [TMemoryBuffer memoryBufferFromBase64:"TWFu"];
    
    var bytes = [-1, -1, -1];
    [instance readAll:bytes offset:0 length:3];
    
    [self assert:[77, 97, 110] equals:bytes message:"Should get back what we put in."];
}

@end