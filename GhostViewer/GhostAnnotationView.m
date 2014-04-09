//
//  GhostAnnotationView.m
//  GhostViewer
//
//  Created by Joern Ross on 02.04.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "GhostAnnotationView.h"
#import "GhostAnnotation.h"


@implementation GhostAnnotationView


- (id)initWithAnnotation:(id <MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithAnnotation:annotation
                        reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor greenColor];
    }
 
        return self;
}


- (void)setAnnotation:(id <MKAnnotation>)annotation {
    super.annotation = annotation;
    if([annotation isMemberOfClass:[GhostAnnotation class]]) {
        anno = (GhostAnnotation *)annotation;
        float magSquared = anno.size ;
        self.frame = CGRectMake(0, 0, magSquared ,magSquared);
    } else {
        self.frame = CGRectMake(0,0,0,0);
    }
}


- (void)drawRect:(CGRect)rect {
    float magSquared = anno.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0 - magSquared * 0.015, 0.211, .6);
    CGContextFillEllipseInRect(context, rect);
}

@end
