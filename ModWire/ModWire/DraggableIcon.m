//
//  DraggableIcon.m
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DraggableIcon.h"

@implementation DraggableIcon
@synthesize startPoint, x, y, ismovable, background;

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
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.y >= 429 || self.x >= 862) {
        [self removeFromSuperview];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
