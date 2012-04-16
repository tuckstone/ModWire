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
@property (nonatomic) UIColor *background;
@property NSInteger x;
@property NSInteger y;
@property BOOL ismovable;
@property (nonatomic) DraggableIcon *connectedFrom;
@property (nonatomic) DraggableIcon *connectedTo;

-(void)setImage:(NSString *)imagename;

@end
