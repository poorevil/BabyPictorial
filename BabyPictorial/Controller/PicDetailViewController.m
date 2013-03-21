//
//  PicDetailViewController.m
//  BabyPictorial
//
//  Created by han chao on 13-3-21.
//  Copyright (c) 2013年 taoxiaoxian. All rights reserved.
//

#import "PicDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PicDetailViewController ()

@end

@implementation PicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.picContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_bg_2.png"]];
    
    //self.picContainer.superview 阴影
    self.picContainer.superview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.picContainer.superview.layer.shadowOpacity = 0.2;
    
    // shadow
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint topLeft      = CGPointMake(0.0, 6.0);
    CGPoint bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.picContainer.superview.bounds)+3);
    CGPoint bottomRight  = CGPointMake(CGRectGetWidth(self.picContainer.superview.bounds)+2, CGRectGetHeight(self.picContainer.superview.bounds)+3);
    CGPoint topRight     = CGPointMake(CGRectGetWidth(self.picContainer.superview.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.picContainer.superview.layer.shadowPath = path.CGPath;
    
    //self.detailContainer 阴影
    self.detailContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.detailContainer.layer.shadowOpacity = 0.2;
    
    // shadow
    path = [UIBezierPath bezierPath];
    
    topLeft      = CGPointMake(0.0, 6.0);
    bottomLeft   = CGPointMake(0.0, CGRectGetHeight(self.detailContainer.bounds)+3);
    bottomRight  = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2
                               , CGRectGetHeight(self.detailContainer.bounds)+3);
    topRight     = CGPointMake(CGRectGetWidth(self.detailContainer.bounds)+2, 3.0);
    
    [path moveToPoint:topLeft];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:topRight];
    [path addLineToPoint:topLeft];
    [path closePath];
    
    self.detailContainer.layer.shadowPath = path.CGPath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.detailContainer = nil;
    self.picContainer = nil;
    
    [super dealloc];
}

@end
