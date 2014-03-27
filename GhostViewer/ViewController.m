//
//  ViewController.m
//  GhostViewer
//
//  Created by Joern Ross on 21.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "ViewController.h"
#import "SimpleGhost.h"
#import "GhostAnnotation.h"



// private
@interface ViewController ()
-(void)updateAnnotations;
@end


bool running = false;

NSString * const GHOSTLISTRESTCALL = @"/DDR_GhostHive/admin/getAllSimpleGhosts/";
NSString * const GHOSTRESTCALL = @"/DDR_GhostHive/admin/getSimpleGhostById/";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    if(_ghostStack==nil){
        _ghostStack = [[NSMutableArray alloc]init];
    }
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

- (void)callGhostService{
    NSLog(@"callGhostService : %@",_pollURL);
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:_pollURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    if (connection) {
        //connection ok
         self.ipField.backgroundColor = [UIColor greenColor];
       }else{
        //connection fail
        self.ipField.backgroundColor = [UIColor redColor];
    }
}

- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    // desirialize data and update ghost stack
    NSError *jsonParsingError = nil;
    NSArray *resultStack = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    //clear the stack
    [_ghostStack removeAllObjects];
    
    for(int i=0; i<[resultStack count];i++)
    {
        _dataObject= [resultStack objectAtIndex:i];
        NSLog(@"ID: %@", [_dataObject objectForKey:@"id"]);
        NSLog(@"NAME: %@", [_dataObject objectForKey:@"name"]);
        
        SimpleGhost *tmpGhost = [[SimpleGhost alloc] init:[[_dataObject objectForKey:@"id"]integerValue]
        name:[_dataObject objectForKey:@"name"]
        longitude:[[_dataObject objectForKey:@"longitude"]floatValue]
        latitude:[[_dataObject objectForKey:@"latitude"]floatValue]];
        
        [_ghostStack addObject:tmpGhost];
    }
    if([_ghostStack count] > 0){
        [self updateAnnotations];
    }
}

-(void) updateAnnotations {
    [_mapView removeAnnotations:_mapView.annotations];
    // iterate and draw annotations
    for(SimpleGhost *simpleGhost in _ghostStack){
        GhostAnnotation *temp = [[GhostAnnotation alloc]init];
        [temp setTitle:simpleGhost.name];
        [temp setSubtitle: @""];
        [temp setCoordinate:CLLocationCoordinate2DMake([simpleGhost latitude],[simpleGhost longitude])];
        [_mapView addAnnotation:temp];
    }
}


-(void)connectionDidFinishLoading: (NSURLConnection *)connection {
    connection = nil;
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    NSLog(@"Connection to ghost service failed");
    self.ipField.backgroundColor = [UIColor redColor];
}

@end
