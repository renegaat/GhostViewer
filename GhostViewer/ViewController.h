//
//  ViewController.h
//  GhostViewer
//
//  Created by Joern Ross on 21.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,NSURLConnectionDelegate>

@property (strong, nonatomic) IBOutlet MKMapView    *mapView;
@property (strong, nonatomic) IBOutlet UITextField  *ipField;
@property (strong, nonatomic) IBOutlet UITextView   *messageView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSTimer *mainTimer;
@property (strong, nonatomic) NSString *pollURL;
@property (strong, nonatomic) NSDictionary *dataObject;
@property (strong, nonatomic) NSMutableArray *ghostStack;
@property (strong, nonatomic) NSMutableArray *locationStack;


//constants
extern NSString * const GHOSTLISTRESTCALL;
extern NSString * const GHOSTRESTCALL;
extern NSString * const LOCATIONRESTCALL;

- (IBAction)ipRefreshClick:(UIButton *)sender;
- (IBAction)showLocations:(id)sender;
- (IBAction)removeLocations:(id)sender;


@end
