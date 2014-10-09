//
//  RPValidatorPredicate.m
//  RPJSONValidator
//
//  Created by Reynaldo on 3/13/14.
//  Copyright (c) 2014 Reynaldo. All rights reserved.
//

#import "RPValidatorPredicate.h"
#import "RPJSONValidator.h"

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
    RPValidatorPredicate *predicate = [self new];
    return [predicate isOptional];
}

+ (instancetype)hasSubstring:(NSString *)substring {
    RPValidatorPredicate *predicate = [self new];
    return [predicate hasSubstring:substring];
}

+ (instancetype)isString {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isString];
}

+ (instancetype)isNumber {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isNumber];
}

+ (instancetype)isDictionary {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isDictionary];
}

+ (instancetype)isArray {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isArray];
}

+ (instancetype)isBoolean {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isBoolean];
}

+ (instancetype)isNull {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isNull];
}

+ (instancetype)isNotNull {
    RPValidatorPredicate *predicate = [self new];
    return [predicate isNotNull];
}

+ (instancetype)validateValueWithBlock:(ValidatorBlock)block {
    RPValidatorPredicate *predicate = [self new];
    return [predicate validateValueWithBlock:block];
}

+ (instancetype)lengthIsLessThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate lengthIsLessThan:value];
}

+ (instancetype)valuesWithRequirements:(NSDictionary *)requirements {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valuesWithRequirements:requirements];
}

+ (instancetype)lengthIsLessOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate lengthIsLessOrEqualTo:value];
}

+ (instancetype)lengthIsEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate lengthIsEqualTo:value];
}

+ (instancetype)lengthIsNotEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate lengthIsNotEqualTo:value];
}

+ (instancetype)lengthIsGreaterThanOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate lengthIsGreaterThanOrEqualTo:value];
}

+ (instancetype)lengthIsGreaterThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate lengthIsGreaterThan:value];
}

+ (instancetype)valueIsLessThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valueIsLessThan:value];
}

+ (instancetype)valueIsLessOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valueIsLessThanOrEqualTo:value];
}

+ (instancetype)valueIsEqualTo:(id)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valueIsEqualTo:value];
}

+ (instancetype)valueIsNotEqualTo:(id)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valueIsNotEqualTo:value];
}

+ (instancetype)valueIsGreaterThanOrEqualTo:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valueIsGreaterThanOrEqualTo:value];
}

+ (instancetype)valueIsGreaterThan:(NSNumber *)value {
    RPValidatorPredicate *predicate = [self new];
    return [predicate valueIsGreaterThan:value];
}

+ (instancetype)matchesRegularExpression:(NSRegularExpression *)expression {
    RPValidatorPredicate *predicate = [self new];
    return [predicate matchesRegularExpression:expression];
}

#pragma mark - Instance Methods

- (instancetype)isOptional {
    self.optional = YES;
    return self;
}

- (instancetype)hasSubstring:(NSString *)substring {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSString class]] && [substring isKindOfClass:[NSString class]]) {
            return [(NSString *)jsonValue rangeOfString:substring].location != NSNotFound;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Value (%@) must contain substring %@", jsonValue, substring]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isString {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSString class]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSString, given (%@)", [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isNumber {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSNumber class]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSNumber, given (%@)", [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isDictionary {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSDictionary class]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSDictionary, given (%@)", [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isArray {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSArray class]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSArray, given (%@)", [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isBoolean {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSNumber class]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires BOOL (NSNumber), given (%@)", [jsonValue class]]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isNull {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isEqual:[NSNull null]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires null, given (%@)", jsonValue]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)isNotNull {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if(![jsonValue isEqual:[NSNull null]]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires non-null value, given (%@)", jsonValue]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)validateValueWithBlock:(ValidatorBlock)developerBlock {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        BOOL developerReturnValue = developerBlock(jsonKey, jsonValue);
        if(developerReturnValue) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Custom block for with value (%@) returned NO", jsonValue]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valuesWithRequirements:(NSDictionary *)requirements {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if ([jsonValue isKindOfClass:[NSArray class]]) {
            BOOL isValid = YES;
            
            for (id object in (NSArray *)jsonValue)
            {
                NSError *error = nil;
                
                if (![RPJSONValidator validateValuesFrom:object
                                        withRequirements:requirements
                                                   error:&error]) {
                    isValid = NO;
                    
                    id errorMessageObject = error.userInfo[RPJSONValidatorFailingKeys];
                    if (errorMessageObject != nil) {
                        [weakSelf.failedRequirementDescriptions addObject:error.userInfo[RPJSONValidatorFailingKeys]];
                    }
                }
            }
            
            return isValid;
        }
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSArray, given (%@)", [jsonValue class]]];
            return NO;
        }
    };
    
    [self.requirements addObject:block];
    
    return self;
}

- (instancetype)lengthIsLessThan:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length (NSString) or count (NSArray)"]];
            return NO;
        }

        if(length < [value unsignedIntegerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length or count greater than or equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsLessOrEqualTo:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length (NSString) or count (NSArray)"]];
            return NO;
        }

        if(length <= [value unsignedIntegerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length or count greater than (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsEqualTo:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length (NSString) or count (NSArray)"]];
            return NO;
        }

        if(length == [value unsignedIntegerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length or count equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsNotEqualTo:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length (NSString) or count (NSArray)"]];
            return NO;
        }

        if(length != [value unsignedIntegerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length or count equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsGreaterThanOrEqualTo:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length (NSString) or count (NSArray)"]];
            return NO;
        }

        if(length >= [value unsignedIntegerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length or count less than (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)lengthIsGreaterThan:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSUInteger length;

        if([jsonValue isKindOfClass:[NSArray class]])
            length = [(NSArray *)jsonValue count];
        else if([jsonValue isKindOfClass:[NSString class]])
            length = [(NSString *)jsonValue length];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length (NSString) or count (NSArray)"]];
            return NO;
        }

        if(length > [value unsignedIntegerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires length or count less than or equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsLessThan:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSNumber, given (%@)", [jsonValue class]]];
            return NO;
        }

        if(integerValue < [value integerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value greater than or equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsLessThanOrEqualTo:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSNumber, given (%@)", [jsonValue class]]];
            return NO;
        }

        if(integerValue <= [value integerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value greater than (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsEqualTo:(id)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if([jsonValue isKindOfClass:[NSNumber class]] && [value isKindOfClass:[NSNumber class]]) {
            if([(NSNumber *)jsonValue isEqualToNumber:value] ) {
                return YES;
            } else {
                [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value not equal to (%@)", value]];
                return NO;
            }
        } else if([jsonValue isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            if([(NSString *)jsonValue isEqualToString:jsonValue]) {
                return YES;
            } else {
                [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value not equal to (%@)", value]];
                return NO;
            }
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Error comparing value (%@) with value (%@)", jsonValue, value]];
            return NO;
        }


    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsNotEqualTo:(id)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSNumber, given (%@)", [jsonValue class]]];
            return NO;
        }

        if(integerValue != [value integerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsGreaterThanOrEqualTo:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSNumber, given (%@)", [jsonValue class]]];
            return NO;
        }

        if(integerValue >= [value integerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value less than (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)valueIsGreaterThan:(NSNumber *)value {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        NSInteger integerValue;

        if([jsonValue isKindOfClass:[NSNumber class]])
            integerValue = [(NSNumber *)jsonValue integerValue];
        else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSNumber, given (%@)", [jsonValue class]]];
            return NO;
        }

        if(integerValue > [value integerValue]) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires value less than or equal to (%@)", value]];
            return NO;
        }
    };

    [self.requirements addObject:block];

    return self;
}

- (instancetype)matchesRegularExpression:(NSRegularExpression *)expression {
    __weak typeof (self) weakSelf = self;
    ValidatorBlock block = ^BOOL(NSString *jsonKey, id jsonValue) {
        if(![jsonValue isKindOfClass:[NSString class]]) {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Requires NSString, given (%@)", [jsonValue class]]];
            return NO;
        }

        if(![expression isKindOfClass:[NSRegularExpression class]]) {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"matchesRegularExpression: called with parameter that must be an NSRegularExpression with value (%@)", jsonValue]];
            return NO;
        }

        NSTextCheckingResult *firstMatch = [expression firstMatchInString:jsonValue
                                                                  options:0
                                                                    range:NSMakeRange(0, [jsonValue length])];

        if(firstMatch && firstMatch.range.location != NSNotFound) {
            return YES;
        } else {
            [weakSelf.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Must match regular expression (%@)", expression]];
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
            [self.failedRequirementDescriptions addObject:[NSString stringWithFormat:@"Key not found"]];
        }
    }
}

@end
