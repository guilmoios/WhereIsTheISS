//
//  ViewController.h
//  WhereIsTheISS
//
//  Created by Guilherme Mogames on 8/1/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"


@interface ViewController : MainViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *ISSMapView;

// Icon Choose View
@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (strong, nonatomic) IBOutlet UIButton *iconRocket;
@property (strong, nonatomic) IBOutlet UIButton *iconSaucer;
@property (strong, nonatomic) IBOutlet UIButton *iconAstronaut;
@property (strong, nonatomic) IBOutlet UIButton *iconSatellite;
- (IBAction)iconSelected:(id)sender;
- (IBAction)closeIconView:(id)sender;

// Refresh Time View
@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIButton *timeFive;
@property (strong, nonatomic) IBOutlet UIButton *timeFifteen;
@property (strong, nonatomic) IBOutlet UIButton *timeThirty;
@property (strong, nonatomic) IBOutlet UIButton *timeSixty;
- (IBAction)closeTimeView:(id)sender;
- (IBAction)timeSelected:(id)sender;
- (IBAction)openTimeView:(id)sender;

@end

