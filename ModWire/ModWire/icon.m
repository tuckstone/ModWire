//
//  icon.m
//  ModWire
//
//  Created by Jessica Noble on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "icon.h"

@implementation icon

@synthesize title, imageName;

-(id) initWithTitle:(NSString *)thisTitle andImage:(NSString *)thisImageName
{
    self = [super init];
    self.title = thisTitle;
    self.imageName = thisImageName;
    return self;
}


@end
