//
//  AbstractGhost.h
//  GhostViewer
//
//  Created by Joern Ross on 27.03.14.
//  Copyright (c) 2014 LBI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractGhost : NSObject

@property (weak, nonatomic)  NSString *name;
@property int id;
@property float longitude;
@property float latitude;

@end
