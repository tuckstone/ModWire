//
//  Control.m
//  ModWire
//
//  Created by Jessica Noble on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Control.h"

@implementation Control
@synthesize title, type, controlValue;

-(id)initWithName:(NSString*)name withType:(NSString*)thisType
{
    Control *newControl = [super init];
    newControl.title = name;
    newControl.type = thisType;
    newControl.controlValue = [[NSNumber alloc]init];
    
    return newControl;
}

@end
