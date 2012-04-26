//
//  Control.m
//  ModWire
//
//  Created by Jessica Noble on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Control.h"

@implementation Control
@synthesize title, type;

-(id)initWithName:(NSString*)name withType:(NSString*)thisType
{
    Control *newControl = [super init];
    newControl.title = name;
    newControl.type = thisType;
    
    return newControl;
}

@end
