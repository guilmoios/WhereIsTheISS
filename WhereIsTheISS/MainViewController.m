//
//  MainViewController.m
//  WhereIsTheISS
//
//  Created by Guilherme Mogames on 8/1/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "MainViewController.h"
#import <KissXML/DDXML.h> // 3rd party used to help parse the location API that only sends XML as a response

static NSString * const APIUrl = @"http://api.open-notify.org/iss-now.json";
static NSString * const locationUrl = @"http://api.geonames.org/extendedFindNearby?username=gmogames";

@interface MainViewController ()
@property (nonatomic, strong) NSTimer *poolingTimer;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Define inital location for Icon placement
    CLLocationCoordinate2D initialLocation = CLLocationCoordinate2DMake(37.773972, -122.431297);
    self.ISSLocation = initialLocation;
    
    // Set default configurations
    NSInteger refreshTime = 5; // Default Time
    NSInteger savedTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultTime"];
    
    if(savedTime > 0){
        
        refreshTime = savedTime;
        
    } else{
        
        [[NSUserDefaults standardUserDefaults] setInteger:refreshTime forKey:@"defaultTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.timeInterval = refreshTime;
    self.centerMap = YES;
    
    // Set icon
    UIImage *icon = [UIImage imageNamed:@"ic_rocket"]; // Default icon
    NSInteger savedIcon = [[NSUserDefaults standardUserDefaults] integerForKey:@"defaultIcon"];
    
    if(savedIcon>0){
        switch (savedIcon) {
            case MapIconsRocket:
                icon = [UIImage imageNamed:@"ic_rocket"];
                break;
                
            case MapIconsSaucer:
                icon = [UIImage imageNamed:@"ic_saucer"];
                break;
                
            case MapIconsAstronaut:
                icon = [UIImage imageNamed:@"ic_astronaut"];
                break;
                
            case MapIconsSatellite:
                icon = [UIImage imageNamed:@"ic_satellite"];
                break;
                
            default:
                break;
        }
    } else{
        
        [[NSUserDefaults standardUserDefaults] setInteger:MapIconsRocket forKey:@"defaultIcon"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    self.mapIcon = icon;
    
    // GET and SET initial ISS location
    [self apiPooling];
    [self getNearestLocation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ISS API Pooling

- (void)apiPooling {
    
    @autoreleasepool {
        
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSURL *requestUrl = [NSURL URLWithString:APIUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response error:&error];
        [self performSelectorOnMainThread:@selector(dataReceived:) withObject:responseData waitUntilDone:YES];
    }
    
}

- (void)startPooling {
    self.poolingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(apiPooling) userInfo:nil repeats:YES];
}

- (void)restartPooling{
    
    [self.poolingTimer invalidate];
    [self startPooling];
    
}

- (void)dataReceived:(NSData *)theData{
    
    if(theData){
        NSError *errorJson=nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:theData options:kNilOptions error:&errorJson];
        NSDictionary *location = responseDict[@"iss_position"];
        
        self.ISSLocation = CLLocationCoordinate2DMake([location[@"latitude"] doubleValue], [location[@"longitude"] doubleValue]);
        self.timestamp = [responseDict[@"timestamp"] doubleValue];
    
    }
    
}

#pragma mark - Location API Pooling

-(void)startLocationPooling{
    
    self.locationPoolingTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval<10?self.timeInterval*2:self.timeInterval target:self selector:@selector(getNearestLocation) userInfo:nil repeats:YES];
}

- (void)restartLocationPooling{
    
    [self.locationPoolingTimer invalidate];
    [self startLocationPooling];
    
}

- (void)getNearestLocation{
    
    @autoreleasepool {
        
        NSError *error = nil;
        NSURLResponse *response = nil;
        NSURL *requestUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@&lat=%f&lng=%f",locationUrl,self.ISSLocation.latitude,self.ISSLocation.longitude]];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0f];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response error:&error];
        
        [self performSelectorOnMainThread:@selector(locationReceived:) withObject:responseData waitUntilDone:YES];
    }
    
}

- (void)locationReceived:(NSData *)theData{
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithData:theData options:0 error:nil];
    
    // Get root element
    DDXMLElement *root = [xml rootElement];
    
    // Go through all elements in root element
    for (DDXMLElement *geoNamesElement in [root children]) {
        
        // if in the Ocean
        if ([[geoNamesElement name] isEqualToString:@"ocean"]) {
            
            DDXMLElement *oceanElement = [[geoNamesElement elementsForName:@"name"] objectAtIndex:0];
            NSString *location = [oceanElement stringValue];
            
            self.nearLocationString = location;
            
        }
        // If in the US
        else if ([[geoNamesElement name] isEqualToString:@"address"]){
            
            DDXMLElement *placeNameElement = [[geoNamesElement elementsForName:@"placename"] objectAtIndex:0];
            DDXMLElement *cityElement = [[geoNamesElement elementsForName:@"adminName2"] objectAtIndex:0];
            DDXMLElement *stateElement = [[geoNamesElement elementsForName:@"adminCode1"] objectAtIndex:0];
            DDXMLElement *countryElement = [[geoNamesElement elementsForName:@"countryCode"] objectAtIndex:0];
            
            NSString *location = [NSString stringWithFormat:@"%@, %@, %@, %@",[placeNameElement stringValue],
                                  [cityElement stringValue],
                                  [stateElement stringValue],
                                  [countryElement stringValue]];
            
            self.nearLocationString = location;
            
        }
        // If around the world
        else if ([[geoNamesElement name] isEqualToString:@"geoname"]){
            
            DDXMLElement *placeNameElement = [[geoNamesElement elementsForName:@"name"] objectAtIndex:0];
            DDXMLElement *countryElement = [[geoNamesElement elementsForName:@"countryName"] objectAtIndex:0];
            
            NSString *location = [NSString stringWithFormat:@"%@, %@",[placeNameElement stringValue],
                                  [countryElement stringValue]];
            
            self.nearLocationString = location;
            
        }
        // If only Country Name is available
        else if ([[geoNamesElement name] isEqualToString:@"countryName"]){
            
            DDXMLElement *countryElement = geoNamesElement;
            
            NSString *location = [NSString stringWithFormat:@"%@",[countryElement stringValue]];
            
            self.nearLocationString = location;
            
        }
        // If nothing else, then change label to searching...
        else{
            
            self.nearLocationString = @"Searching...";
            
        }
    }
    
}

#pragma mark - Refresh Time
- (void)updateRefreshTime:(NSInteger)time{
    
    // Set selected time
    self.timeInterval = time;
    
    // Save selected icon for next time app opens
    [[NSUserDefaults standardUserDefaults] setInteger:time forKey:@"defaultTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Restart pooling to get new time
    [self restartLocationPooling];
    [self restartPooling];    
    
}

@end
