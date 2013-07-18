//
//  UIColor+OBThemes.m
//  OpenBike
//
//  Created by Brian Buck on 7/17/13.
//
//

#import "UIColor+OBThemes.h"

@implementation UIColor (OBThemes)

+ (UIColor *) sideMenuBackgroundColor
{
    return [UIColor colorWithWhite:.93 alpha:1];
}

+ (UIColor *) darkerGray
{
    return [UIColor colorWithRed:45./256. green:45./256. blue:45./256. alpha:1];;
}

+ (UIColor *) mapRoutePolyLineColor
{
    return [UIColor blueColor];
}

@end
