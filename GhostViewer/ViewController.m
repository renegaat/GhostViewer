//
//  ViewController.m
//  GhostViewer
//
//  Created by Joern Ross on 21.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

bool running = false;

NSString * const GHOSTLISTRESTCALL = @"admin/getAllSimpleGhosts/";
NSString * const GHOSTRESTCALL = @"admin/getSimpleGhostById/";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = _locationManager.location.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    [_mapView setRegion:mapRegion animated: YES];
    NSLog(@"Location manager finished location update");
    //location zoom complete, stop the update, we just need a rough guestimate here
    [_locationManager stopUpdatingLocation];
}

- (IBAction)ipRefreshClick:(UIButton *)sender {
    //cancel the main timer
    [_mainTimer invalidate];
    // build the url
    if ([_ipField.text isEqualToString:@""]) {
        NSLog(@"ipField is empty!");
        return;
    }
    NSString *URL = [NSString stringWithFormat:@"http://%@/%@", _ipField.text, GHOSTLISTRESTCALL];
    // start background NSUrlConnection poll via timer invocation
    NSLog(@"URl Construct : %@",URL);
    _pollURL = URL;
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(10.0) target:self selector:@selector(callGhostService) userInfo:nil repeats:TRUE];
}

- (void)callGhostService
{
    NSLog(@"callGhostService : %@",_pollURL);

    /*
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_pollURL]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         NSLog(@"Received data : %@", data);
        
        //desirialize requedst
     
    }];*/
}

@end
