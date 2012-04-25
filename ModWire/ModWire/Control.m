//
//  Control.m
//  ModWire
//
//  Created by Jessica Noble on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Control.h"

@implementation Control
@synthesize title, type, upperBounds, lowerBounds;

-(id)initWithName:(NSString*)name withType:(NSString*)thisType
{
    self = [super init];
    self.title = name;
    self.type = thisType;
    
    return self;
}

@end
