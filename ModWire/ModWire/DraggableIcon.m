//
//  DraggableIcon.m
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DraggableIcon.h"

@implementation DraggableIcon
@synthesize startPoint, x, y, ismovable, background, connectedTo, connectedFrom;

-(void)setImage:(NSString *)imagename{
    UIColor *image = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:imagename]];
    self.background = image;
    self.backgroundColor = image;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!ismovable) {
        //If view is immovable, don't move it
    }else {
    startPoint = [[touches anyObject] locationInView:self];
        self.alpha = 0.5;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!ismovable) {
        //If view is immovable, don't move it
    }else {
        CGPoint movePoint = [[touches anyObject] locationInView:self.superview];
        movePoint.x -= startPoint.x;
        movePoint.y -= startPoint.y;
        CGRect movFrame = [self frame];
        movFrame.origin = movePoint;
        self.x = movePoint.x;
        self.y = movePoint.y;
        [self setFrame:movFrame];  
    }  
    /*
     The following is code to add "Highlight" shadows.  Not sure where to implement.
     [[self layer] setShadowColor:[UIColor greenColor].CGColor];
     [[self layer] setShadowOpacity:1.0f];
     [[self layer] setShadowRadius:6.0f];
     [[self layer] setShadowOffset:CGSizeMake(0, 3)];
     */
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.y >= 429 || self.x >= 862) {
        [self removeFromSuperview];
    }
    self.alpha = 1.0;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
