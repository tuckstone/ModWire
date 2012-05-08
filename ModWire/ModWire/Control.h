//
//  Control.h
//  ModWire
//
//  Created by Jessica Noble on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Control : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *controlValue;

-(id)initWithName:(NSString*)name withType:(NSString*)type;

@end
