//
//  AbstractAnnotation.m
//  GhostViewer
//
//  Created by Joern Ross on 31.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "AbstractAnnotation.h"

@implementation AbstractAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize size;

- (id)init{
	if ( self = [super init] ) {
    }
    return self;
}
@end
