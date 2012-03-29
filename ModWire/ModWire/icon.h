//
//  icon.h
//  ModWire
//
//  Created by Jessica Noble on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface icon : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imageName;

-(id) initWithTitle:(NSString *)thisTitle andImage:(NSString *)thisImageName;

@end
