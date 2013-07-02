//
//  OpenBikeSegue.m
//  OpenBike
//
//  Created by Brian Buck on 7/1/13.
//
//

#import "OpenBikeSegue.h"
#import "CycleTracksAppDelegate.h"
#import "RecordTripViewController.h"
#import "PersonalInfoViewController.h"

@implementation OpenBikeSegue

- (void)perform
{
    NSLog(@"Segue from %@ to %@", self.sourceViewController, self.destinationViewController);

    CycleTracksAppDelegate *appDelegate = (CycleTracksAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.viewController setFrontViewController:self.destinationViewController animated:YES completion:^{
        NSLog(@"done transitioning");
    }];
}

@end
