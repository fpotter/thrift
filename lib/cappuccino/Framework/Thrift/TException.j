
@import <Foundation/Foundation.j>

@implementation TException : CPException

// + (id) exceptionWithName: (CPString) name
// {
//   return [self exceptionWithName: name reason: @"unknown" error: nil];
// }


// + (id) exceptionWithName: (CPString) name
//                   reason: (CPString) reason
// {
//   return [self exceptionWithName: name reason: reason error: nil];
// }
// 
// 
// + (id) exceptionWithName: (CPString) name
//                   reason: (CPString) reason
//                    error: (id) error
// {
//     var userInfo = nil;
//     if (error != nil) {
//         userInfo = [CPDictionary dictionaryWithObject: error forKey: @"error"];
//     }
// 
//     return [super exceptionWithName: name
//                              reason: reason
//                            userInfo: userInfo];
// }
// 
// 
// - (CPString) description
// {
//     var result = [self name];
//     result = result + [CPString stringWithFormat: ": %@", [self reason]];
//     if ([self userInfo] != nil) {
//         result = result + [CPString stringWithFormat: @"\n  userInfo = %@", [self userInfo]];
//     }
// 
//     return result;
// }

@end

