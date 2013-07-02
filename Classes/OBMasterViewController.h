//
//  OBMasterViewController.h
//  OpenBike
//
//  Created by Brian Buck on 7/2/13.
//
//

#import <UIKit/UIKit.h>

@class OBMasterViewController;
@class SideNavigationTableViewController;

@protocol OBMasterViewControllerDelegate <NSObject>

- (OBMasterViewController *) frontVC;
- (SideNavigationTableViewController *) backVC;

- (void)menuButtonPressed:(id)sender;

@end

@interface OBMasterViewController : UIViewController

@property (nonatomic, strong, readwrite) id selectedViewController;
@property (nonatomic, strong, readwrite) NSArray *viewControllers;

- (id) initWithDelegate:(id<OBMasterViewControllerDelegate>)delegate;

@end
