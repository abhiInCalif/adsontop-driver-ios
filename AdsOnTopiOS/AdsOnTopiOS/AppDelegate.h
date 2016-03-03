//
//  AppDelegate.h
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/14/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Google/SignIn.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

