//
//  GhostAnnotation.h
//  GhostViewer
//
//  Created by Joern Ross on 27.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GhostAnnotation : NSObject <MKAnnotation>{
    
    NSString *title;
    NSString *subtitle;
    NSString *note;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
