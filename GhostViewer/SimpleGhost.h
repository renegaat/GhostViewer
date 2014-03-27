//
//  SimpleGhost.h
//  GhostViewer
//
//  Created by Joern Ross on 25.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractGhost.h"


@interface SimpleGhost : AbstractGhost



- (id)init:(int)id name:(NSString*)name longitude:(double)longitude latitude:(double)latitude;

@end


