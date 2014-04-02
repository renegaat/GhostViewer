//
//  LocationAnnotationView.h
//  GhostViewer
//
//  Created by Joern Ross on 02.04.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"


@interface LocationAnnotationView : MKAnnotationView{
    int size;
    LocationAnnotation *anno;
}

@end
