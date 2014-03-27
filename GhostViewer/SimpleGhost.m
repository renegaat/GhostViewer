//
//  SimpleGhost.m
//  GhostViewer
//
//  Created by Joern Ross on 25.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import "SimpleGhost.h"
#import "AbstractGhost.h"

@implementation SimpleGhost

- (id)init:(int)id name:(NSString*)name longitude:(double)longitude latitude:(double)latitude{
	if ( self = [super init] ) {
        self.id = id;
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

@end



