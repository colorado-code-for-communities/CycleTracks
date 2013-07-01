/**  CycleTracks, Copyright 2009-2013 San Francisco County Transportation Authority
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
//  CycleTracksAppDelegate.h
//  CycleTracks
//
//  Copyright 2009-2013 SFCTA. All rights reserved.
//  Written by Matt Paul <mattpaul@mopimp.com> on 9/21/09.
//	For more information on the project,
//	e-mail Elizabeth Sall at the SFCTA <elizabeth.sall@sfcta.org>
//

//
// Adapted to Open Bike by Gregory Kip (gkip@permusoft.com) and others.
//

#import "RecordTripViewController.h"
#import "SideNavigationTableViewController.h"
#import "JSSlidingViewController.h"

@interface CycleTracksAppDelegate : UIResponder <UIApplicationDelegate, JSSlidingViewControllerDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIWindow *window;
    NSString *uniqueIDHash;
    UIBackgroundTaskIdentifier bgTask;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *uniqueIDHash;

@property (strong, nonatomic) JSSlidingViewController *viewController;
@property (strong, nonatomic) RecordTripViewController *recordVC;
@property (strong, nonatomic) SideNavigationTableViewController *backVC;
@property (strong, nonatomic) UIViewController *frontVC;

- (NSString *)applicationDocumentsDirectory;
- (void)initUniqueIDHash;

@end

