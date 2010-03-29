
@import <Foundation/Foundation.j>

@implementation TException : CPException

+ (id) exceptionWithName: (CPString) aName
{
  return [self exceptionWithName: aName reason: @"unknown" error: nil];
}


+ (id) exceptionWithName: (CPString) aName
                  reason: (CPString) aReason
{
    return [self exceptionWithName: aName reason: aReason error: nil];
}


+ (id) exceptionWithName: (CPString) aName
                  reason: (CPString) aReason
                   error: (id) anError
{
    var userInfo = nil;
    if (anError != nil) {
        userInfo = [CPDictionary dictionaryWithObject: anError forKey: @"error"];
    }

    return [super exceptionWithName: aName
                             reason: aReason
                           userInfo: anError];
}


- (CPString) description
{
    var result = [self name];
    result = result + [CPString stringWithFormat: ": %@", [self reason]];
    if ([self userInfo] != nil) {
        result = result + [CPString stringWithFormat: @"\n  userInfo = %@", [self userInfo]];
    }

    return result;
}

@end

