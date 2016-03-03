//
//  AppDelegate.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/14/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RestLayer.h"
#import "Driver.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // configure the FB SDK for FB Login
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [MagicalRecord setupCoreDataStack];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    return YES;
}

- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        if(self.locationManager.locationServicesEnabled == NO){
            NSLog(@"ERROR ERROR ERROR");
        }
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    
    // Movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *newLocation in locations) {
        if (newLocation.horizontalAccuracy < 20) {
            // send the new location to the server
            AFHTTPSessionManager* signalManager = [RestLayer postSignal];
            NSArray* d_list = [Driver MR_findAll];
            Driver* d = [d_list objectAtIndex:0];
            NSDictionary* parameters = @{@"driver": d.id, @"lat": [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude], @"lon": [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude]};
            [signalManager POST:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                // do something if its a success and do something else if its a failure
                NSLog(@"%@", responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Sending Signal Data"
                                                                        message:[error localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                    [alertView show];
            }];
        }
    }
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation] ||
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    NSURL *imageURL = NULL;
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        NSUInteger dimension = 140;
        imageURL = [user.profile imageURLWithDimension:dimension];
    }
    
    // Store the response from the server in the core data box;
    AFHTTPSessionManager* driverManager = [RestLayer postDriver];
    NSDictionary* parameters = @{@"name": name, @"email": email, @"google_userid": userId, @"google_idtoken": idToken, @"miles_driven_in_current_campaign": @"0"};
    [driverManager POST:@"" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // store the returning data in core data as the full driver information
        NSLog(@"Reached here!!!!!!!!!!!#$)@#*$)(#@*$)(@*#$()@*#)$(*@#)($*@)(*$)@*$");
        [Driver MR_truncateAll];
        NSDictionary* responseDict = responseObject;
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSArray *drivers = [Driver MR_findAll];
            if ([drivers count] == 0) {
                Driver *d = [Driver MR_createEntityInContext:localContext];
                d.name = name;
                d.email = email;
                d.google_idtoken = idToken;
                d.google_userid = userId;
                if (![responseDict[@"campaign"] isEqual:[NSNull null]]) {
                    d.campaign = [NSNumber numberWithInt:[responseDict[@"campaign"] intValue]];
                } else {
                    d.campaign = [NSNumber numberWithInt:-1];
                }
                d.id = [NSNumber numberWithInt:[responseDict[@"id"] intValue]];
                
                // add the image
                if ([imageURL absoluteString] != NULL) {
                    d.image = [imageURL absoluteString];
                } else {
                    d.image = @"";
                }
                
                // set the date
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [dateFormat dateFromString:responseDict[@"trial_end_date"]];
                d.trial_end_date = date;
            }
            
            // now transfer to next view
            [self.window.rootViewController presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainRootController"] animated:YES completion:nil];
            [self startLocationUpdates];
            
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse* r = (NSHTTPURLResponse*)task.response;
        NSInteger statusCode = r.statusCode;
        if(statusCode == 400) {
            // this is the duplicate POST request step.
            // in this step we have to make the extra get request to get the driver information.
            AFHTTPSessionManager* driverManager = [RestLayer getDriver:userId];
            [driverManager GET:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                // store the returning data in core data as the full driver information
                NSLog(@"Reached here!!!!!!!!!!!#$)@#*$)(#@*$)(@*#$()@*#)$(*@#)($*@)(*$)@*$");
                [Driver MR_truncateAll];
                NSDictionary* responseDict = responseObject;
                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                    NSArray *drivers = [Driver MR_findAll];
                    if ([drivers count] == 0) {
                        Driver *d = [Driver MR_createEntityInContext:localContext];
                        d.name = name;
                        d.email = email;
                        d.google_idtoken = idToken;
                        d.google_userid = userId;
                        if (![responseDict[@"campaign"] isEqual:[NSNull null]]) {
                            d.campaign = [NSNumber numberWithInt:[responseDict[@"campaign"] intValue]];
                        } else {
                            d.campaign = [NSNumber numberWithInt:-1];
                        }
                        d.id = [NSNumber numberWithInt:[responseDict[@"id"] intValue]];
                        // add the image
                        if ([imageURL absoluteString] != NULL) {
                            d.image = [imageURL absoluteString];
                        } else {
                            d.image = @"";
                        }
                        
                        // set the date
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd"];
                        NSDate *date = [dateFormat dateFromString:responseDict[@"trial_end_date"]];
                        d.trial_end_date = date;
                    }
                    
                    // now transfer to next view
                    [self.window.rootViewController presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainRootController"] animated:YES completion:nil];
                    [self startLocationUpdates];

                }];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Driver Data"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
            }];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Driver Data"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [MagicalRecord cleanUp];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "TrustNetwork.AdsOnTopiOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AdsOnTopiOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AdsOnTopiOS.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];
    [localContext MR_saveToPersistentStoreAndWait];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
