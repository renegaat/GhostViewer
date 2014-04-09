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
#import "GhostAnnotationView.h"
#import "LocationAnnotation.h"
#import "LocationAnnotationView.h"


// private
@interface ViewController ()
-(void)updateInfoField:(NSString *)text;
@end


bool running = false;
NSMutableData *receivedData;



NSString * const GHOSTLISTRESTCALL = @"/DDR_GhostHive/admin/getAllSimpleGhosts/";
NSString * const GHOSTRESTCALL = @"/DDR_GhostHive/admin/getSimpleGhostById/";
NSString * const LOCATIONRESTCALL = @"/DDR_GhostHive/admin/getLocations/";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    _mapView.delegate = self;
    
    if(_ghostStack==nil){
        _ghostStack = [[NSMutableArray alloc]init];
    }
    
    if(_locationStack==nil){
        _locationStack = [[NSMutableArray alloc]init];
    }
    
    if(receivedData == nil){
        receivedData = [[NSMutableData alloc]init];
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
    [receivedData appendData:data];
}

 - (void) connectionDidFinishLoading:(NSURLConnection *)connection {

     // desirialize data and update ghost stack
     NSError *jsonParsingError = nil;
     NSArray *resultStack = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];
     
     NSArray *colors = [NSArray arrayWithObjects:@"BLACK", @"WHITE", @"GREEN", @"BLUE",@"RED",nil];
     
     //set ghost simple annotations
     
     _dataObject= [resultStack objectAtIndex:0];
     
     if([_dataObject objectForKey:@"name"] != nil){
         
         NSLog(@"return from get simple ghost call");
         
         [_mapView removeAnnotations:_ghostStack];
         [_ghostStack removeAllObjects];
         
         
         for(int i=0; i<[resultStack count];i++)
         {
             GhostAnnotation *temp = [[GhostAnnotation alloc]init];
             
             _dataObject= [resultStack objectAtIndex:i];
             NSLog(@"ID: %@", [_dataObject objectForKey:@"id"]);
             NSLog(@"NAME: %@", [_dataObject objectForKey:@"name"]);
             
             NSString *tmpString = [NSString stringWithFormat:@"Name : %@, Destination: %@",[_dataObject objectForKey:@"name"],[[_dataObject objectForKey:@"destinationId"]stringValue]];
             [temp setSize:15];
             [temp setTitle: tmpString];
             [temp setCoordinate:CLLocationCoordinate2DMake([[_dataObject objectForKey:@"latitude"]doubleValue],[[_dataObject objectForKey:@"longitude"]doubleValue])];
             [_ghostStack addObject:temp];
         }
         [_mapView addAnnotations:_ghostStack];
     }
     
     // decode ghost rich data
     
    
     // set location anotations
     
     if([_dataObject objectForKey:@"locationName"] != nil){
         NSLog(@"return from get locations call");
         
         [_mapView removeAnnotations:_locationStack];
         [_locationStack removeAllObjects];

         for(int i=0; i<[resultStack count];i++)
         {
             
             LocationAnnotation *temp = [[LocationAnnotation alloc]init];
             
             _dataObject= [resultStack objectAtIndex:i];
             NSLog(@"ID: %@", [_dataObject objectForKey:@"id"]);
             NSLog(@"NAME: %@", [_dataObject objectForKey:@"locationName"]);
          
             // display the names of the locations
             NSArray *locationNames= [_dataObject valueForKeyPath:@"locationInfo.infoName"];
             NSString *names = [locationNames componentsJoinedByString:@"\n"];
    
             HiveColor color = [colors indexOfObject: [_dataObject objectForKey:@"hiveColor"]];
    
             NSString *tmpString = [NSString stringWithFormat:@"Name : %@, id: %@ , Location Names : %@",[_dataObject objectForKey:@"locationName"],[[_dataObject objectForKey:@"id"]stringValue],names];
             [temp setTitle: tmpString];
             [temp setHiveColor:color];
             
             // set the size property for the annotation, more info is bigger annotation
             [temp setSize:[locationNames count]];
             
             [temp setCoordinate:CLLocationCoordinate2DMake([[_dataObject objectForKey:@"latitude"]doubleValue],[[_dataObject objectForKey:@"longitude"]doubleValue])];
             [_locationStack addObject:temp];
         }
         [_mapView addAnnotations:_locationStack];
     }
     [receivedData  setLength:0];
 }


- (void)updateInfoField:(NSString *)text{
    NSLog(@"updateInfoField");
    [_messageView setText:text];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView {
    NSLog(@"didSelectAnnotationView");
    [self updateInfoField: aView.annotation.title];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = nil ;
    
    if ([annotation isKindOfClass:[GhostAnnotation class]]){
         static NSString *ghostIdentifier = @"GhostAnnotation";
            annotationView = [[GhostAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ghostIdentifier];
    }
    
    if ([annotation isKindOfClass:[LocationAnnotation class]]){
            static NSString *locationIdentifier = @"LocationAnnotation";
        annotationView = [[LocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationIdentifier];
    }
    
    [annotationView setAnnotation:annotation];

    return annotationView;
}


- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    NSLog(@"Connection to ghost service failed");
    self.ipField.backgroundColor = [UIColor redColor];
}


- (IBAction)showLocations:(id)sender {

    NSLog(@"Show Loccations");
    NSString *URL = [NSString stringWithFormat:@"http://%@/%@", _ipField.text,LOCATIONRESTCALL];
    NSLog(@"URl Construct : %@",URL);

    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (connection) {
        //connection ok
        self.ipField.backgroundColor = [UIColor greenColor];
    }else{
        //connection fail
        self.ipField.backgroundColor = [UIColor redColor];
    }
}

- (IBAction)removeLocations:(id)sender {
    [_mapView removeAnnotations:_locationStack];
    [_messageView setText:@""];
}
@end
