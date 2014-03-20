# RPJSONValidator #

Validate JSON before it is mapped

## Given ##
```Objective-C
NSDictionary *json = @{
            @"phoneNumber" : @"123-555-6789",
            @"name" : @"Johnny Ringo",
            @"age" : @"BANANA",
            @"weight" : @"130.3",
            @"ssn" : [NSNull null],
            @"children" : @[],
            @"parents" : @[
                    @{
                            @"name" : @"Mickey"
                    },
                    @{
                            @"name" : @"Minnie"
                    }
            ]
    };
```

## Before ##
```Objective-C
BOOL validated = YES;

NSString *phoneNumber = [json objectForKey:@"phoneNumber"];
if(!phoneNumber || ![phoneNumber isKindOfClass:[NSString class] || [phoneNumber length] < 7) {
  NSLog(@"Phone number didn't validate (not found or not an NSString or length < 7)");
  validated = NO;
}

NSString *name = [json objectForKey:@"name"];
if(!name || ![phoneNumber isKindOfClass:[NSString class]) {
  NSLog(@"Phone number didn't validate (not found or not an NSString)");
  validated = NO;
}

NSNumber *age = [json objectForKey:@"age"];
if(age && ![age isKindOfClass:[NSNumber class]) {
  NSLog(@"Age exists but didn't validate (not an NSNumber)");
  validated = NO;
}

NSNumber *weight = [json objectForKey:@"weight"];
if(weight && ![weight isKindOfClass:[NSString class]) {
  NSLog(@"Weight exists but didn't validate (not an NSString)");
  validated = NO;
}

NSString *ssn = [json objectForKey:@"ssn"];
if(ssn != [NSNull null]) {
  NSLog(@"ssn should be null");
  validated = NO;
}

NSString *height = [json objectForKey:@"height"];
if(height && ![weight isKindOfClass:[NSString class]) {
  NSLog(@"Height exists but didn't validate (not an NSString)");
  validated = NO;
}

NSArray *children = [json objectForKey:@"children"];
if(children && ![children isKindOfClass:[NSArray class]) {
  NSLog(@"Children exists but didn't validate (not an NSArray)");
  validated = NO;
}

NSArray *parents = [json objectForKey:@"parents"];
if(parents && ![parents isKindOfClass:[NSArray class] && [parents count] <= 1) {
  NSLog(@"Parents exists but didn't validate (not an NSArray or count <= 1)");
  validated = NO;
}
```

## After ##
```Objective-C
NSError *error;

[RPJSONValidator validateValuesFrom:json
                   withRequirements:@{
                           @"phoneNumber" : [RPValidatorPredicate.isString lengthIsGreaterThanOrEqualTo:@7],
                           @"name" : RPValidatorPredicate.isString,
                           @"age" : RPValidatorPredicate.isNumber.isOptional,
                           @"weight" : RPValidatorPredicate.isString,
                           @"ssn" : RPValidatorPredicate.isNull,
                           @"height" : RPValidatorPredicate.isString,
                           @"children" : RPValidatorPredicate.isArray,
                           @"parents" : [RPValidatorPredicate.isArray lengthIsGreaterThan:@1]
                   } error:&error];

if(error) {
    NSLog(@"%@", [RPJSONValidator prettyStringGivenRPJSONValidatorError:error]);
} else {
    NSLog(@"Woohoo, no errors!");
}
```

## Explanation ##
Each key-value pair describes requirements for each JSON value. For example, the key-value pair `@"name" : RPValidatorPredicate.isString` will place a requirement on the JSON value with key "name" to be an NSString. We can also chain requirements. For example, `@"age" : RPValidatorPredicate.isNumber.isOptional` will place a requirement on the value of "age" to be an NSNumber, but only if it exists in the JSON.

## Predicates ##
* isOptional
  * Evaluate the other predicates only if the key exists
* hasSubstring:(NSString *)substring
  * Require NSString with substring
* isString
* isNumber
* isDictionary
* isArray
* isBoolean
* isNull
  * Require value == [NSNull null]
* isNotNull
  * Require value != [NSNull null]
* validateValueWithBlock:(BOOL (^)(NSString *jsonKey, id jsonValue))block
  * For custom validations, given the JSON key and corresponding value (could be nil, [NSNull null], NSNumber, NSArray, NSDictionary, or NSString), return YES if valid and NO if invalid
* lengthIsLessThan:(NSNumber *)value
* lengthIsLessThanOrEqualTo:(NSNumber *)value
* lengthIsEqualTo:(NSNumber *)value
* lengthIsNotEqualTo:(NSNumber *)value
* lengthIsGreaterThanOrEqualTo:(NSNumber *)value
* lengthIsGreaterThan:(NSNumber *)value
* valueIsLessThan:(NSNumber *)value
* valueIsLessThanOrEqualTo:(NSNumber *)value
* valueIsEqualTo:(NSNumber *)value
* valueIsNotEqualTo:(NSNumber *)value
* valueIsGreaterThanOrEqualTo:(NSNumber *)value
* valueIsGreaterThan:(NSNumber *)value
* matchesRegularExpression:(NSRegularExpression *)expression

## But Wait, There's More! ##
### Pretty Printing ###
```Objective-C
NSDictionary *json = @{...};
NSError *error;

[RPJSONValidator validateValuesFrom:json
                   withRequirements:@{...}
                              error:&error];

NSLog(@"%@", [RPJSONValidator prettyStringGivenRPJSONValidatorError:error];

// Output:
// 2014-03-19 23:08:02.451 RPJSONValidator[42273:60b] 
// * age
//      * Requires NSNumber, given (__NSCFConstantString)
// * height
//      * Key not found
// * parents
//      * Requires NSString, given (__NSArrayI)
//      * Requires length or count less than or equal to (3)
```

### Sub-JSON Validating ###
```Objective-C
NSDictionary *json = @{
        @"car" : @{
                @"make" : @"Ford",
                @"model" : @"Mustang"
        },
};

[RPJSONValidator validateValuesFrom:json
                           withRequirements:@{
                                   @"car" : @{
                                           @"make" : [RPValidatorPredicate valueIsEqualTo:@"Ford"],
                                           @"model" : [RPValidatorPredicate valueIsEqualTo:@"Mustang"]
                                   }
                                      error:&error]
```

### Validate by Index ###
```Objective-C
NSDictionary *json = @{
        @"cars" : @[
            @{
                 @"make" : @"Ford",
                 @"model" : @"Mustang"
            },
            @{
                 @"make" : "Tesla Motors",
                 @"model" : "Model S"
            },
            ...
        ],
};

[RPJSONValidator validateValuesFrom:json
                           withRequirements:@{
                                   @"cars" : @{
                                        @0 : @{ // Access the first element
                                             @"make" : RPValidatorPredicate.isString,
                                             @"model" : RPValidatorPredicate.isString
                                        }
                                   }
                                      error:&error]
```

## Requirements ##
* [ARC](http://en.wikipedia.org/wiki/Automatic_Reference_Counting)

## Install ##
* Use [CocoaPods](http://cocoapods.org)

Or

* Copy files in RPJSONValidator to your project
