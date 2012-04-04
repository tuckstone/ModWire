//
//  DraggableIcon.h
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableIcon : UIView

@property (nonatomic) CGPoint startPoint;

-(void)setImage:(NSString *)imagename;

@end
