//
//  CycleTracksAppDelegate.m
//  CycleTracks
//

/*   CycleTracks, Copyright 2009-2013 San Francisco County Transportation Authority
 *                                    San Francisco, CA, USA
 *
 *   @author Matt Paul <mattpaul@mopimp.com>
 *
 *   This file is part of CycleTracks.
 *
 *   CycleTracks is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   CycleTracks is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with CycleTracks.  If not, see <http://www.gnu.org/licenses/>.
 */

//
//  Copyright 2009-2013 SFCTA. All rights reserved.
//  Written by Matt Paul <mattpaul@mopimp.com> on 9/21/09.
//	 For more information on the project,
//	 e-mail Elizabeth Sall at the SFCTA <elizabeth.sall@sfcta.org>
//

//
// Adapted to Open Bike by Gregory Kip (gkip@permusoft.com) and others.
//


#import <CommonCrypto/CommonDigest.h>


#import "CycleTracksAppDelegate.h"
#import "OBMasterViewController.h"
#import "SideNavigationTableViewController.h"
#import "PersonalInfoViewController.h"
#import "RecordTripViewController.h"
#import "SavedTripsViewController.h"
#import "TripManager.h"

#import "UIDevice+UDID.h"
#import "NSBundle+PSExtensions.h"

@interface CycleTracksAppDelegate()<OBMasterViewControllerDelegate>

@property (strong, nonatomic) OBMasterViewController *frontVC;
@property (strong, nonatomic) SideNavigationTableViewController *backVC;

@end

@implementation UINavigationBar (NavBarShadow)

@end


@implementation CycleTracksAppDelegate

@synthesize window = _window;
@synthesize uniqueIDHash;
@synthesize viewController = _viewController;
@synthesize frontVC, backVC;

#pragma mark - JSSlidingViewControllerDelegate

- (BOOL)slidingViewController:(JSSlidingViewController *)viewController shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientationsForSlidingViewController:(JSSlidingViewController *)viewController {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Convenience

- (void)menuButtonPressed:(id)sender {
    if (self.viewController.isOpen == NO) {
        [self.viewController openSlider:YES completion:nil];
    } else {
        [self.viewController closeSlider:YES completion:nil];
    }
}

- (void)lockSlider {
    self.viewController.locked = YES;
}

- (void)unlockSlider {
    self.viewController.locked = NO;
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Permusoft's %@ v%@ (%@)", [NSBundle displayName], [NSBundle version], [NSBundle bundleIdentifier]);
    NSLog(@"Copyright %@", [NSBundle copyright]);
    
	// disable screen lock
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	//[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
	
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
    }
	
	// init our unique ID hash
	[self initUniqueIDHash];
	
    
    self.frontVC = [[OBMasterViewController alloc] initWithDelegate:self];
	// initialize trip manager with the managed object context
	TripManager *manager = [[TripManager alloc] initWithManagedObjectContext:context];
    RecordTripViewController *recordVC = [self.frontVC.viewControllers objectAtIndex:0];
    [recordVC initTripManager:manager];
    self.frontVC.selectedViewController = recordVC;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OpenBike" bundle:nil];
    self.backVC = [storyboard instantiateViewControllerWithIdentifier:@"SideNavigation"];
    
    SavedTripsViewController *tripsVC = [self.frontVC.viewControllers objectAtIndex:1];
	tripsVC.delegate = recordVC;
	[tripsVC initTripManager:manager];
    
    PersonalInfoViewController *personalVC = [self.frontVC.viewControllers objectAtIndex:3];
    personalVC.managedObjectContext = context;
    
    self.viewController = [[JSSlidingViewController alloc] initWithFrontViewController:[self.frontVC.viewControllers objectAtIndex:0] backViewController:self.backVC];
    self.viewController.delegate = self;
    
//    if (isLoggedIn) {
//        [self.window setRootViewController:initViewController];
//    } else {
//        [(UINavigationController *)self.window.rootViewController pushViewController:initViewController animated:NO];
//    }
//    self.recordVC = [[RecordTripViewController alloc] initWithNibName:@"RecordMap" bundle:nil];
//    [recordVC initTripManager:manager];
//    
//
//    self.backVC = [[SideNavigationTableViewController alloc] initWithNibName:@"SideNavigationTableViewController" bundle:nil];
//    
//    self.viewController = [[JSSlidingViewController alloc] initWithFrontViewController:self.recordVC backViewController:self.backVC];
//    self.viewController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[_window setFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = self.viewController;
	[_window makeKeyAndVisible];
    
    return YES;
}


-(void)initUniqueIDHash {
	self.uniqueIDHash = [[UIDevice currentDevice] uniqueDeviceIdentifier];
}

/**
 * Nofity the OS we're going to be doing stuff in the background -- recording, updating the timer, etc.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
   
   if ([self.frontVC.viewControllers objectAtIndex:0]) {
      // Let the RecordTripViewController take care of its business
      [[self.frontVC.viewControllers objectAtIndex:0] handleBackgrounding];
   }
   
   // If we're not recording -- don't bother with the background task
   if ([self.frontVC.viewControllers objectAtIndex:0] && ![[self.frontVC.viewControllers objectAtIndex:0] recording]) {
      NSLog(@"applicationDidEnterBackground - bgTask=%d (should be zero)", bgTask);
      return;
   }
   
   bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
      dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"Background Handler: End background because time ran out, cleaning up task.");
         
         // time's up - end the background task
         [application endBackgroundTask:bgTask];
         
      });
   }];
   
   NSLog(@"applicationDidEnterBackground - bgTask=%d", bgTask);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   NSLog(@"applicationWillEnterForeground - bgTask=%d", bgTask);
   if (bgTask) {
      [application endBackgroundTask:bgTask];
   }
   bgTask = 0;
   
   if ([self.frontVC.viewControllers objectAtIndex:0]) {
      [[self.frontVC.viewControllers objectAtIndex:0] handleForegrounding];
      if ([[self.frontVC.viewControllers objectAtIndex:0] recording]) {
         //tabBarController.selectedIndex = 1;
      }
   }
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
   if ([self.frontVC.viewControllers objectAtIndex:0]) {
      [[self.frontVC.viewControllers objectAtIndex:0] handleTermination];
   }
   
   NSError *error = nil;
   if (managedObjectContext != nil) {
      if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"applicationWillTerminate: Unresolved error %@, %@", error, [error userInfo]);
			abort();
      }
   }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
   if (managedObjectContext != nil) {
      return managedObjectContext;
   }
	
   NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
   if (coordinator != nil) {
      managedObjectContext = [[NSManagedObjectContext alloc] init];
      [managedObjectContext setPersistentStoreCoordinator: coordinator];
   }
   return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
   if (managedObjectModel != nil) {
      return managedObjectModel;
   }
   managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
   return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
   if (persistentStoreCoordinator != nil) {
      return persistentStoreCoordinator;
   }
	
   NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"OpenBike.sqlite"]];
	
	NSError *error = nil;
   persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
   if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
   }
	
   return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}




@end
