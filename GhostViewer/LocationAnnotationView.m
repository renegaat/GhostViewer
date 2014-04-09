//
//  LocationAnnotationView.m
//  GhostViewer
//
//  Created by Joern Ross on 02.04.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "LocationAnnotationView.h"
#import "LocationAnnotation.h"






@implementation LocationAnnotationView


- (id)initWithAnnotation:(id <MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithAnnotation:annotation
                        reuseIdentifier:reuseIdentifier]) {
        anno = (LocationAnnotation *)annotation;
        self.size = anno.size;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation {
    super.annotation = annotation;
    if([annotation isMemberOfClass:[LocationAnnotation class]]) {
        float magSquared = self.size ;
        self.frame = CGRectMake(0, 0, magSquared * .75,  magSquared * .75);
    } else {
        self.frame = CGRectMake(0,0,0,0);
    }
}

- (void)drawRect:(CGRect)rect {
    //float magSquared = self.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    // CGContextSetRGBFillColor(context, 1.0, 1.0 - magSquared * 0.015, 0.211, .6);
    switch (anno.hiveColor) {
        case BLACK:
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            break;
            
        case BLUE:
            CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
            break;
            
        case WHITE:
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            break;
            
        case GREEN:
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            break;
            
        case RED:
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            break;
            
        default:
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            break;
    }
    CGContextFillEllipseInRect(context, rect);
}

@end
