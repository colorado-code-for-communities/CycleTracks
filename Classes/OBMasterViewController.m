//
//  OBMasterViewController.m
//  OpenBike
//
//  Created by Brian Buck on 7/2/13.
//
//

#import "OBMasterViewController.h"
#import "PersonalInfoViewController.h"
#import "RecordTripViewController.h"
#import "SavedTripsViewController.h"

@interface OBMasterViewController ()

@property (nonatomic, weak, readwrite) id<OBMasterViewControllerDelegate> delegate;

@end

@implementation OBMasterViewController

@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;

- (id) initWithDelegate:(id<OBMasterViewControllerDelegate>)delegate;
{
    self = [super init];
    if (self)
    {
        _delegate = delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OpenBike" bundle:nil];
        NSArray *viewControllers =
        @[
          [storyboard instantiateViewControllerWithIdentifier:@"TripRecordNav"], // 0
          [storyboard instantiateViewControllerWithIdentifier:@"SavedTripsNav"], // 1
          [storyboard instantiateViewControllerWithIdentifier:@"AboutInfo"], // 2
          [storyboard instantiateViewControllerWithIdentifier:@"PersonalInfoNav"] // 3
          // add others
          ];
        
        _viewControllers = [viewControllers mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
