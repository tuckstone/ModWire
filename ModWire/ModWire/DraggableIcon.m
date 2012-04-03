//
//  DraggableIcon.m
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DraggableIcon.h"

@implementation DraggableIcon
@synthesize startPoint;

-(void)setImage:(NSString *)imagename{
    UIColor *image = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:imagename]];
    self.backgroundColor = image;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    startPoint = [[touches anyObject] locationInView:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint movePoint = [[touches anyObject] locationInView:self.superview];
    movePoint.x -= startPoint.x;
    movePoint.y -= startPoint.y;
    CGRect movFrame = [self frame];
    movFrame.origin = movePoint;
    [self setFrame:movFrame];
    
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
