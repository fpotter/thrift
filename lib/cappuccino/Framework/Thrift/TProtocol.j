
@import <Foundation/Foundation.j>

// enum {
TMessageType_CALL = 1;
TMessageType_REPLY = 2;
TMessageType_EXCEPTION = 3;
TMessageType_ONEWAY = 4;
// };

TType_STOP   = 0;
TType_VOID   = 1;
TType_BOOL   = 2;
TType_BYTE   = 3;
TType_DOUBLE = 4;
TType_I16    = 6;
TType_I32    = 8;
TType_I64    = 10;
TType_STRING = 11;
TType_STRUCT = 12;
TType_MAP    = 13;
TType_SET    = 14;
TType_LIST   = 15;

@implementation TProtocol : CPObject
{
}

- (id)init {
    if (self = [super init])
    {
    }
    return self;
}

// - (id <TTransport>) transport;

//- (void)readStructBeginReturningName: (NSString **) name;
// - (void) readStructEnd;
// 
- (CPString)readString
{
    [CPException raise:CPUnsupportedMethodException reason:"readString must be implemented by subclass"];
}

- (BOOL)readBool
{
    [CPException raise:CPUnsupportedMethodException reason:"readBool must be implemented by subclass"];
}

- (int)readByte
{
    [CPException raise:CPUnsupportedMethodException reason:"readByte must be implemented by subclass"];
}

- (short)readI16
{
    [CPException raise:CPUnsupportedMethodException reason:"readI16 must be implemented by subclass"];
}

- (int)readI32
{
    [CPException raise:CPUnsupportedMethodException reason:"readI32 must be implemented by subclass"];
}
// 
- (long)readI64
{
    [CPException raise:CPUnsupportedMethodException reason:"readI64 must be implemented by subclass"];
}

- (double)readDouble
{
    [CPException raise:CPUnsupportedMethodException reason:"readDouble must be implemented by subclass"];
}

- (CPString)readBinary
{
    [CPException raise:CPUnsupportedMethodException reason:"readBinary must be implemented by subclass"];
}

// - (void) readMapBeginReturningKeyType: (int *) keyType
//                             valueType: (int *) valueType
//                                  size: (int *) size;
// - (void) readMapEnd;
// 
// 
// - (void) readSetBeginReturningElementType: (int *) elementType
//                                      size: (int *) size;
// - (void) readSetEnd;
// 
// 
// 
// - (void)writeMessageBeginWithName: (NSString *) name
// //                               type: (int) messageType
// //                         sequenceID: (int) sequenceID;
// - (void) writeMessageEnd;
// 
- (void)writeStructBeginWithName:(CPString)name
{
    [CPException raise:CPUnsupportedMethodException reason:"writeStructBeginWithName must be implemented by subclass"];
}

- (void)writeStructEnd
{
    [CPException raise:CPUnsupportedMethodException reason:"writeStructEnd must be implemented by subclass"];
}

- (void)writeFieldBeginWithName:(CPString)name
                           type:(int)fieldType
                         fieldID:(int)fieldID
{
    [CPException raise:CPUnsupportedMethodException reason:"writeFieldBeginWithName:type:fieldID must be implemented by subclass"];
}

- (void)writeI32:(int)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeI32 must be implemented by subclass"];
}

- (void)writeI64:(long)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeI64 must be implemented by subclass"];
}

- (void)writeI16:(short)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeI16 must be implemented by subclass"];
}

- (void)writeByte:(int)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeByte must be implemented by subclass"];
}

- (void)writeString:(CPString)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeString must be implemented by subclass"];
}

- (void)writeDouble:(double)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeDouble must be implemented by subclass"];
}

- (void)writeBool:(BOOL)value
{
    [CPException raise:CPUnsupportedMethodException reason:"writeBool must be implemented by subclass"];
}

- (void)writeBinary:(CPString)data
{
    [CPException raise:CPUnsupportedMethodException reason:"writeBinary must be implemented by subclass"];
}
// 
// - (void) writeFieldStop;
// 
// - (void) writeFieldEnd;
// 
// - (void) writeMapBeginWithKeyType: (int) keyType
//                         valueType: (int) valueType
//                              size: (int) size;
// - (void) writeMapEnd;
// 
// 
// - (void) writeSetBeginWithElementType: (int) elementType
//                                  size: (int) size;
// - (void) writeSetEnd;
// 
// 
// - (void) writeListBeginWithElementType: (int) elementType
//                                   size: (int) size;
// 
// - (void) writeListEnd;

@end
