//
//  RPValidatorPredicate.h
//  RPJSONValidator
//
//  Created by Reynaldo on 3/13/14.
//  Copyright (c) 2014 Reynaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPValidatorPredicate;

typedef BOOL (^ValidatorBlock)(NSString *jsonKey, id jsonValue);

@interface RPValidatorPredicate : NSObject
+ (instancetype)isOptional;
+ (instancetype)hasSubstring:(NSString *)substring;
+ (instancetype)isString;
+ (instancetype)isNumber;
+ (instancetype)isDictionary;
+ (instancetype)isArray;
+ (instancetype)isBoolean;
+ (instancetype)isNull;
+ (instancetype)isNotNull;
+ (instancetype)validateValueWithBlock:(ValidatorBlock)block;

// Array
+ (instancetype)valuesWithRequirements:(NSDictionary *)requirements;

// Array/String methods
+ (instancetype)lengthIsLessThan:(NSNumber *)value;
+ (instancetype)lengthIsLessOrEqualTo:(NSNumber *)value;
+ (instancetype)lengthIsEqualTo:(NSNumber *)value;
+ (instancetype)lengthIsNotEqualTo:(NSNumber *)value;
+ (instancetype)lengthIsGreaterThanOrEqualTo:(NSNumber *)value;
+ (instancetype)lengthIsGreaterThan:(NSNumber *)value;

// Number/String methods
+ (instancetype)valueIsLessThan:(NSNumber *)value;
+ (instancetype)valueIsLessOrEqualTo:(NSNumber *)value;
+ (instancetype)valueIsEqualTo:(id)value;
+ (instancetype)valueIsNotEqualTo:(id)value;
+ (instancetype)valueIsGreaterThanOrEqualTo:(NSNumber *)value;
+ (instancetype)valueIsGreaterThan:(NSNumber *)value;

// String only methods
+ (instancetype)matchesRegularExpression:(NSRegularExpression *)expression;

#pragma mark - Corresponding Instance Methods
- (instancetype)isOptional;
- (instancetype)hasSubstring:(NSString *)substring;
- (instancetype)isString;
- (instancetype)isNumber;
- (instancetype)isDictionary;
- (instancetype)isArray;
- (instancetype)isBoolean;
- (instancetype)isNull;
- (instancetype)isNotNull;
- (instancetype)validateValueWithBlock:(ValidatorBlock)block;

// Array
- (instancetype)valuesWithRequirements:(NSDictionary *)requirements;

// Array/String methods
- (instancetype)lengthIsLessThan:(NSNumber *)value;
- (instancetype)lengthIsLessOrEqualTo:(NSNumber *)value;
- (instancetype)lengthIsEqualTo:(NSNumber *)value;
- (instancetype)lengthIsNotEqualTo:(NSNumber *)value;
- (instancetype)lengthIsGreaterThanOrEqualTo:(NSNumber *)value;
- (instancetype)lengthIsGreaterThan:(NSNumber *)value;

// Number/String methods
- (instancetype)valueIsLessThan:(NSNumber *)value;
- (instancetype)valueIsLessThanOrEqualTo:(NSNumber *)value;
- (instancetype)valueIsEqualTo:(id)value;
- (instancetype)valueIsNotEqualTo:(id)value;
- (instancetype)valueIsGreaterThanOrEqualTo:(NSNumber *)value;
- (instancetype)valueIsGreaterThan:(NSNumber *)value;

// String only methods
- (instancetype)matchesRegularExpression:(NSRegularExpression *)expression;
@end
