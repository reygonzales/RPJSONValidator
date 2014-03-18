//
//  RPJSONValidator.m
//  RPJSONValidator
//
//  Created by Reynaldo on 3/13/14.
//  Copyright (c) 2014 Reynaldo. All rights reserved.
//

#import "RPJSONValidator.h"
#import "RPValidatorPredicate.h"

static BOOL RPJSONValidatorShouldSuppressWarnings;

@interface RPValidatorPredicate(Protected)
- (void)validateValue:(id)value withKey:(NSString *)key;
- (NSMutableArray *)failedRequirementDescriptions;
@end

@implementation RPJSONValidator

+ (BOOL)validateValuesFrom:(id)json
          withRequirements:(NSDictionary *)requirements
                     error:(NSError **)error {
    // The json parameter must be an NSArray or NSDictionary with
    // NSString keys and NSString/NSNumber/NSNull/NSDictionary/NSArray values
    //
    // The requirements parameter must be an NSDictionary with these specifications:
    // * Keys: NSString/NSNumber
    // * Values: RPValidatorPredicate/NSDictionary
    //
    // The error parameter may be nil. Otherwise, it must be an NSError class

    if(!json) {
        [RPJSONValidator log:@"RPJSONValidator Error: json parameter is nil -- there is nothing to validate. Returning NO"];
        return NO;
    }

    if(!requirements) {
        [RPJSONValidator log:@"RPJSONValidator Error: requirements parameter is nil -- there are no requirements. Returning NO"];
        return NO;
    }

    if(![json isKindOfClass:[NSDictionary class]] && ![json isKindOfClass:[NSArray class]]) {
        [RPJSONValidator log:@"RPJSONValidator Error: json parameter is not valid JSON (it is not an NSArray or NSDictionary). Returning NO"];
        return NO;
    }

    if(![requirements isKindOfClass:[NSDictionary class]]) {
        [RPJSONValidator log:@"RPJSONValidator Error: requirements parameter is not an NSDictionary. Returning NO"];
        return NO;
    }

    if(*error && ![*error isKindOfClass:[NSError class]]) {
        [RPJSONValidator log:@"RPJSONValidator Error: error parameter is not an NSError **. Returning NO"];
        return NO;
    }

    return [RPJSONValidator validateValuesFrom:json
                              withRequirements:requirements
                                         error:error
                                      userInfo:[@{} mutableCopy]];
}

+ (BOOL)validateValuesFrom:(id)json
          withRequirements:(NSDictionary *)requirements
                     error:(NSError **)error
                  userInfo:(NSMutableDictionary *)userInfo {
    // The json parameter must be an NSArray or NSDictionary with
    // NSString keys and NSString/NSNumber/NSNull/NSDictionary/NSArray values
    //
    // The requirements parameter must be an NSDictionary with these specifications:
    // * Keys: NSString/NSNumber
    //      * Keys correspond to JSON keys or indices of arrays
    // * Values: RPValidatorPredicate/NSDictionary

    for(id requirementsKey in [requirements allKeys]) {
        id requirementsValue = [requirements objectForKey:requirementsKey];
        id jsonValue;

        if([json isKindOfClass:[NSArray class]] && [requirementsKey isKindOfClass:[NSNumber class]] && [json count] > [requirementsKey unsignedIntegerValue]) {
            jsonValue = [json objectAtIndex:[requirementsKey unsignedIntegerValue]];
        } else if([json isKindOfClass:[NSDictionary class]]) {
            jsonValue = [json objectForKey:requirementsKey];
        } else {
            jsonValue = nil;
        }

        if([requirementsValue isKindOfClass:[RPValidatorPredicate class]] && [requirementsKey isKindOfClass:[NSString class]]) {
            [(RPValidatorPredicate *)requirementsValue validateValue:jsonValue withKey:requirementsKey];

            if([[(RPValidatorPredicate *)requirementsValue failedRequirementDescriptions] count]) {
                [userInfo setObject:[(RPValidatorPredicate *)requirementsValue failedRequirementDescriptions] forKey:requirementsKey];
            }
        } else if([requirementsValue isKindOfClass:[NSDictionary class]]) {
            [RPJSONValidator validateValuesFrom:jsonValue
                               withRequirements:requirementsValue
                                          error:error
                                       userInfo:userInfo];
        } else {
            [RPJSONValidator log:[NSString stringWithFormat:@"RPJSONValidator Error: requirements parameter isn't valid. Value (%@) isn't an RPValidatorPredicate or NSDictionary or NSNumber. Returning NO", requirementsValue]];
            return NO;
        }
    }

    if([[userInfo allKeys] count]) {
        *error = [NSError errorWithDomain:@"Banana" code:314159 userInfo:userInfo];
        return NO;
    }
    return YES;
}

+ (void)setShouldSuppressLogging:(BOOL)shouldSuppressLogging {
    RPJSONValidatorShouldSuppressWarnings = shouldSuppressLogging;
}

+ (void)log:(NSString *)warning {
    if(RPJSONValidatorShouldSuppressWarnings)
        NSLog(@"%@", warning);
}

@end
