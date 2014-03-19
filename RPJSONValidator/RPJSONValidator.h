//
//  RPJSONValidator.h
//  RPJSONValidator
//
//  Created by Reynaldo on 3/13/14.
//  Copyright (c) 2014 Reynaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RPJSONValidatorErrorDomain @"RPJSONValidatorErrorDomain"
#define RPJSONValidatorFailingKeys @"RPJSONValidatorFailingKeys"
#define RPJSONValidatorErrorBadRequirementsParameter 0
#define RPJSONValidatorErrorBadJSONParameter 1
#define RPJSONValidatorErrorInvalidJSON 2

@interface RPJSONValidator : NSObject

// Returns YES when json is "valid", i.e., all the requirements are met
+ (BOOL)validateValuesFrom:(id)json
          withRequirements:(NSDictionary *)requirements
                     error:(NSError **)error;

+ (NSString *)prettyStringGivenRPJSONValidatorError:(NSError *)error;

+ (void)setShouldSuppressLogging:(BOOL)shouldSuppressLogging;
@end
