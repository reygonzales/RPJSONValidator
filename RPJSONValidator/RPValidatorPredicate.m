//
//  RPValidatorPredicate.m
//  RPJSONValidator
//
//  Created by Reynaldo on 3/13/14.
//  Copyright (c) 2014 Reynaldo. All rights reserved.
//

#import "RPValidatorPredicate.h"

@interface RPValidatorPredicate()
@property (nonatomic, strong) NSMutableArray *requirements; // An array of ValidatorBlocks
@property (nonatomic) BOOL optional;
@property (nonatomic, strong) NSMutableArray *failedRequirementDescriptions; // An array of descriptions for failures. ValidatorBlocks are supposed to populate them
@end

@interface RPValidatorPredicate(Protected)
- (void)validateValue:(id)value withKey:(NSString *)key;
- (NSMutableArray *)failedRequirementDescriptions;
@end

@implementation RPValidatorPredicate

- (id)init {
    if((self = [super init])) {
        self.requirements = [NSMutableArray array];
        self.failedRequirementDescriptions = [NSMutableArray array];
    }

    return self;
}

+ (instancetype)isOptional {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isOptional];
}

+ (instancetype)hasSubstring:(NSString *)substring {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate hasSubstring:substring];
}

+ (instancetype)isString {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isString];
}

+ (instancetype)isNumber {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isNumber];
}

+ (instancetype)isDictionary {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isDictionary];
}

+ (instancetype)isArray {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isArray];
}

+ (instancetype)isBoolean {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isBoolean];
}

+ (instancetype)isNull {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isNull];
}

+ (instancetype)isNotNull {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate isNotNull];
}

+ (instancetype)validateValueWithBlock:(ValidatorBlock)block {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate validateValueWithBlock:block];
}

+ (instancetype)lengthIsLessThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate lengthIsLessThan:value];
}

+ (instancetype)lengthIsLessOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate lengthIsLessOrEqualTo:value];
}

+ (instancetype)lengthIsEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate lengthIsEqualTo:value];
}

+ (instancetype)lengthIsNotEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate lengthIsNotEqualTo:value];
}

+ (instancetype)lengthIsGreaterThanOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate lengthIsGreaterThanOrEqualTo:value];
}

+ (instancetype)lengthIsGreaterThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate lengthIsGreaterThan:value];
}

+ (instancetype)valueIsLessThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate valueIsLessThan:value];
}

+ (instancetype)valueIsLessOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate valueIsLessThanOrEqualTo:value];
}

+ (instancetype)valueIsEqualTo:(id)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate valueIsEqualTo:value];
}

+ (instancetype)valueIsNotEqualTo:(id)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate valueIsNotEqualTo:value];
}

+ (instancetype)valueIsGreaterThanOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate valueIsGreaterThanOrEqualTo:value];
}

+ (instancetype)valueIsGreaterThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate valueIsGreaterThan:value];
}

+ (instancetype)matchesRegularExpression:(NSRegularExpression *)expression {
    RPValidatorPredicate *predicate = [RPValidatorPredicate new];
    return [predicate matchesRegularExpression:expression];
}

#pragma mark - Instance Methods

- (instancetype)isOptional {
    self.optional = YES;
    return self;
}

- (instancetype)hasSubstring:(NSString *)substring {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSString class]] && [substring isKindOfClass:[NSString class]]) {
            return [(NSString *)jsonValue rangeOfString:substring].location != NSNotFound;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) with value (%@) must contain substring %@", jsonKey, jsonValue, substring]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isString {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSString class]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSString, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isNumber {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSNumber class]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSNumber, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isDictionary {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSDictionary class]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSDictionary, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isArray {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSArray class]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSArray, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isBoolean {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSNumber class]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires BOOL (NSNumber), given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isNull {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isEqual:[NSNull null]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires null, given (%@)", jsonKey, jsonValue]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isNotNull {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if(![jsonValue isEqual:[NSNull null]]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires non-null value, given (%@)", jsonKey, jsonValue]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)validateValueWithBlock:(ValidatorBlock)developerBlock {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        BOOL developerReturnValue = developerBlock(jsonKey, jsonValue);
        if(developerReturnValue) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Custom block for key (%@) with value (%@) returned NO", jsonKey, jsonValue]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsLessThan:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length (NSString) or count (NSArray)", jsonKey]];
            return NO;
        }

        if(length < [value unsignedIntegerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length or count greater than or equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsLessOrEqualTo:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length (NSString) or count (NSArray)", jsonKey]];
            return NO;
        }

        if(length <= [value unsignedIntegerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length or count greater than (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsEqualTo:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length (NSString) or count (NSArray)", jsonKey]];
            return NO;
        }

        if(length == [value unsignedIntegerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length or count equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsNotEqualTo:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length (NSString) or count (NSArray)", jsonKey]];
            return NO;
        }

        if(length != [value unsignedIntegerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length or count equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsGreaterThanOrEqualTo:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length (NSString) or count (NSArray)", jsonKey]];
            return NO;
        }

        if(length >= [value unsignedIntegerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length or count less than (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsGreaterThan:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length (NSString) or count (NSArray)", jsonKey]];
            return NO;
        }

        if(length > [value unsignedIntegerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires length or count less than or equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsLessThan:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSNumber, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }

        if(integerValue < [value integerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value greater than or equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsLessThanOrEqualTo:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSNumber, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }

        if(integerValue <= [value integerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value greater than (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsEqualTo:(id)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSNumber class]] && [value isKindOfClass:[NSNumber class]]) {
            if([(NSNumber *)jsonValue isEqualToNumber:value] ) {
                return YES;
            } else {
                [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value not equal to (%@)", jsonKey, value]];
                return NO;
            }
        } else if([jsonValue isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            if([(NSString *)jsonValue isEqualToString:jsonValue]) {
                return YES;
            } else {
                [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value not equal to (%@)", jsonKey, value]];
                return NO;
            }
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Error comparing value (%@) with value (%@) for key (%@)", jsonValue, value, jsonKey]];
            return NO;
        }


    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsNotEqualTo:(id)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSNumber, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }

        if(integerValue != [value integerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsGreaterThanOrEqualTo:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSNumber, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }

        if(integerValue >= [value integerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value less than (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsGreaterThan:(NSNumber *)value {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSNumber, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }

        if(integerValue > [value integerValue]) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires value less than or equal to (%@)", jsonKey, value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)matchesRegularExpression:(NSRegularExpression *)expression {
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if(![jsonValue isKindOfClass:[NSString class]]) {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) requires NSString, given (%@)", jsonKey, [jsonValue class]]];
            return NO;
        }

        if(![expression isKindOfClass:[NSRegularExpression class]]) {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"matchesRegularExpression: called with parameter that must be an NSRegularExpression for Key (%@) with value (%@)", jsonKey, jsonValue]];
            return NO;
        }

        NSTextCheckingResult *firstMatch = [expression firstMatchInString:jsonValue
                                                                  options:0
                                                                    range:NSMakeRange(0, [jsonValue length])];

        if(firstMatch && firstMatch.range.location != NSNotFound) {
            return YES;
        } else {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) must match regular expression (%@)", jsonKey, jsonValue, expression]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

#pragma mark - Protected method

- (void)validateValue:(id)value withKey:(NSString *)key {
    if(value) {
        for(ValidatorBlock block in self.requirements) {
            block(key, value);
        }
    } else {
        if(!self.optional) {
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key (%@) not found", key]];
        }
    }
}

@end
