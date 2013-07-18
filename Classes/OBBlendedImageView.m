//
//  OBBlendedImageView.m
//  OpenBike
//
//  Created by Brian Buck on 7/17/13.
//
//

#import "OBBlendedImageView.h"

#import <QuartzCore/QuartzCore.h>

static const CGFloat kOBBlendedImageDefaultOpacity = .02;

@interface OBBlendedImageView ()

@property CALayer *blendedLayer;

@end

@implementation OBBlendedImageView

- (void) willMoveToSuperview:(UIView *)newSuperview;
{
    NSAssert(self.image != nil, @"No Pattern Image set for background!");
    
    [self.blendedLayer removeFromSuperlayer];
    
    self.blendedLayer = [CALayer layer];
    self.blendedLayer.backgroundColor = [UIColor colorWithPatternImage:self.image].CGColor;
    self.blendedLayer.opacity = self.imageOpacity ?: kOBBlendedImageDefaultOpacity;
    
    [self.layer addSublayer:self.blendedLayer];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer;
{
    if (layer == self.layer)
    {
        self.blendedLayer.frame = self.bounds;
    }
}

@end