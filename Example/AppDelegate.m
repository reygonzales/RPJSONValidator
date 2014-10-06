//
//  AppDelegate.m
//  RPJSONValidator
//
//  Created by Reynaldo on 3/13/14.
//  Copyright (c) 2014 Reynaldo. All rights reserved.
//

#import "AppDelegate.h"
#import "RPJSONValidator.h"
#import "RPValidatorPredicate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
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
            ],
            @"car" : @{
                    @"make" : @"Ford",
                    @"model" : @"Mustang"
            },
            @"address" : @"123 3rd Street, Neverland, California, 94555",
            @"friends" : @[
                           @{@"name" : @"Anna",
                             @"age"  : @25},
                           @{@"name" : @"Maria",
                             @"age"  : @19},
                           @{@"name" : @"WrongObject",
                             @"counry" : @"UA"}]
                           };
    
    NSError *error;
    
    if(![RPJSONValidator validateValuesFrom:json
                           withRequirements:@{
                                   @"phoneNumber" : [RPValidatorPredicate.isString lengthIsGreaterThanOrEqualTo:@7],
                                   @"name" : RPValidatorPredicate.isString,
                                   @"age" : RPValidatorPredicate.isNumber.isOptional,
                                   @"weight" : RPValidatorPredicate.isNotNull.isString,
                                   @"ssn" : RPValidatorPredicate.isNull,
                                   @"height" : RPValidatorPredicate.isString,
                                   @"children" : RPValidatorPredicate.isArray,
                                   @"parents" : [RPValidatorPredicate.isArray.isString lengthIsGreaterThan:@3],
                                   @"car" : @{
                                           @"make" : [RPValidatorPredicate valueIsEqualTo:@"Ford"],
                                           @"model" : [RPValidatorPredicate valueIsEqualTo:@"Mustang"]
                                   },
                                   @"address" : [RPValidatorPredicate.isString matchesRegularExpression:[NSRegularExpression regularExpressionWithPattern:@"\\d\\d\\d\\d\\d" options:0 error:nil]],
                                   @"friends" : [RPValidatorPredicate.isArray valuesWithRequirements:
                                                 @{@"name" : RPValidatorPredicate.isString,
                                                   @"age"  : RPValidatorPredicate.isNumber}]
                                              }
                                      error:&error]) {
        if(error) {
            NSLog(@"\n%@", [RPJSONValidator prettyStringGivenRPJSONValidatorError:error]);
        } else {
            NSLog(@"Failed to validate, but didn't pass an NSError object");
        }
    } else {
        NSLog(@"Woohoo, no errors!");
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
