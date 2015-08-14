//
//  ViewController.m
//  WhereIsTheISS
//
//  Created by Guilherme Mogames on 8/1/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "ViewController.h"
#import "ISSAnnotation.h"
#import <KissXML/DDXML.h>

@interface ViewController ()
@property (nonatomic, strong) ISSAnnotation *annotation;

// More Info
@property (strong, nonatomic) IBOutlet UIView *moreInfo;
@property (strong, nonatomic) IBOutlet UILabel *nearLocation;

// Icon view
- (IBAction)openIconView:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add Icon on MAP
    self.annotation = [[ISSAnnotation alloc] initWithCoordinate:self.ISSLocation];
    [self.ISSMapView addAnnotation:self.annotation];
    self.ISSMapView.centerCoordinate = self.ISSLocation;
    
    // Start fetching the ISS Location with the default refresh time
    [self startPooling];
    
    // Configure the More Info view
    self.moreInfo.layer.cornerRadius = 5.0f;
    self.moreInfo.layer.borderWidth = 1.0f;
    self.moreInfo.layer.borderColor = [UIColor colorWithRed:84.0f/255.0f green:173.0f/255.0f blue:212.0f/255.0f alpha:1.0f].CGColor;
    
    // Configure Icon View
    self.iconView.layer.cornerRadius = 5.0f;
    
    // Configure Time View
    self.timeView.layer.cornerRadius = 5.0f;
    
}

#pragma mark - ISS Location

- (void)dataReceived:(NSData *)theData {
    
    [super dataReceived:theData];
    
    [self.annotation setCoordinate:self.ISSLocation];
    self.ISSMapView.centerCoordinate = self.ISSLocation;
    
}

#pragma mark - Annotation

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.iss.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = NO;
        pinView.image = self.mapIcon;
    }
    else {
        [mapView.userLocation setTitle:@"ISS Is Here"];
    }
    return pinView;
}

#pragma mark - Nearest Location

-(void)locationReceived:(NSData *)theData{
    
    [super locationReceived:theData];
    self.nearLocation.text = self.nearLocationString;

}

#pragma mark - Icon SET and GET

- (IBAction)iconSelected:(id)sender {
    
    // Set the annotation icon and the selected state for the visible icon
    switch ([sender tag]) {
        case MapIconsRocket:
            self.mapIcon = [UIImage imageNamed:@"ic_rocket"];
            [self.iconRocket setImage:[UIImage imageNamed:@"bg_check"] forState:UIControlStateNormal];
            break;
            
        case MapIconsSaucer:
            self.mapIcon = [UIImage imageNamed:@"ic_saucer"];
            [self.iconSaucer setImage:[UIImage imageNamed:@"bg_check"] forState:UIControlStateNormal];
            break;
            
        case MapIconsAstronaut:
            self.mapIcon = [UIImage imageNamed:@"ic_astronaut"];
            [self.iconAstronaut setImage:[UIImage imageNamed:@"bg_check"] forState:UIControlStateNormal];
            break;
            
        case MapIconsSatellite:
            self.mapIcon = [UIImage imageNamed:@"ic_satellite"];
            [self.iconSatellite setImage:[UIImage imageNamed:@"bg_check"] forState:UIControlStateNormal];
            break;
            
        default:
            self.mapIcon = [UIImage imageNamed:@"ic_rocket"];
            [self.iconRocket setImage:[UIImage imageNamed:@"bg_check"] forState:UIControlStateNormal];
            break;
    }
    
    // Save selected icon for next time app opens
    [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:@"defaultIcon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Update Map with the selected icon
    [self.ISSMapView removeAnnotation:self.annotation];
    [self.ISSMapView addAnnotation:self.annotation];
    
    // Close popup
    [self closeIconView:sender];
}

- (IBAction)closeIconView:(id)sender {
    self.iconView.hidden = YES;
}

- (IBAction)openIconView:(id)sender {
    
    // Find the selected icon
    NSInteger selectedIcon = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultIcon"];
    
    // Remove the selected state icon for all icons
    NSArray *icons = @[self.iconRocket,self.iconSaucer,self.iconAstronaut,self.iconSatellite];
    
    for (UIButton *icon in icons){
        
        if([icon tag] == selectedIcon){
            [icon setImage:[UIImage imageNamed:@"bg_check"] forState:UIControlStateNormal];
        } else{
            [icon setImage:nil forState:UIControlStateNormal];
        }
    }
    
    self.iconView.hidden = !self.iconView.hidden;
}

#pragma mark - Refresh Time Selection

- (IBAction)closeTimeView:(id)sender {
    self.timeView.hidden = YES;
}

- (IBAction)timeSelected:(id)sender {
    
    // Set selected time
    [self updateRefreshTime:[sender tag]];
    [self closeTimeView:sender];
    
}

- (IBAction)openTimeView:(id)sender {
    
    // Find the selected time
    NSInteger selectedTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultTime"];
    
    // Remove the selected state icon for all buttons
    NSArray *times = @[self.timeFive,self.timeFifteen,self.timeThirty,self.timeSixty];
    
    for (UIButton *time in times){
        
        if([time tag] == selectedTime){
            [time setTitleColor:[UIColor colorWithRed:74.0f/255.0f green:176.0f/255.0f blue:69.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        } else{
            [time setTitleColor:[UIColor colorWithRed:39.0f/255.0f green:93.0f/255.0f blue:176.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
    }
    UIColor *color = [UIColor blackColor].CGColor
    self.timeView.hidden = !self.timeView.hidden;
}


@end
