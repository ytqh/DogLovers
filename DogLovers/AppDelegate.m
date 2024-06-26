//
//  AppDelegate.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "AppDelegate.h"
#import "Dog.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // OPT: force application waiting for fetch all basic data
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);

    [[DogManager sharedManager] refreshDogCache:^(NSError *error) {
        if (error) {
            NSLog(@"Error fetching data: %@", error);
        }

        dispatch_group_leave(group);
    }];

    // wait DogManager fetch all data for 3 seconds
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)));

    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
    configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                                   options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
