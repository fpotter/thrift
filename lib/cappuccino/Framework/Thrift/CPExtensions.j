
@implementation CPSet (EnhancedDescriptions)

- (CPString)description
{
    return "[ " + [[self allObjects] componentsJoinedByString:", "] + "]";
}

@end

// @implementation CP (EnhancedDescriptions)
// 
// - (CPString)description
// {
//     var description = "[ ";
//     var enumerator = [self objectEnumerator];
//     while (obj = [enumerator nextObject])
//     {
//         description = description + [obj description] + ", ";
//     }
//     description = description + "]";
//     return description;
// }
// 
// @end