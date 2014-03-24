//
//  ViewController.h
//  GhostViewer
//
//  Created by Joern Ross on 21.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) IBOutlet UITextField  *ipField;
@property (strong, nonatomic) IBOutlet UITextView   *messageView;
- (IBAction)ipRefreshClick:(UIButton *)sender;

@end
