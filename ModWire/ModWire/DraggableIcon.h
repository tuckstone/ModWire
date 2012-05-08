//
//  DraggableIcon.h
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PathView.h"
#import "ViewController.h"


@interface DraggableIcon : UIView

@property (nonatomic) NSString *myName;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) UIColor *background;
@property NSInteger x;
@property NSInteger y;
@property NSInteger pathNum;
@property BOOL ismovable;
@property BOOL inbounds;
@property BOOL isTouched;
@property (nonatomic) BOOL ishighlighted;
@property (nonatomic) DraggableIcon *connectedFrom;
@property (nonatomic) DraggableIcon *connectedFrom2;
@property (nonatomic) DraggableIcon *connectedTo;
@property (nonatomic) NSInteger objectNumber;

@property (nonatomic) DraggableIcon *selectedIcon;

@property (nonatomic) NSMutableSet *otherIcons;

@property(nonatomic) NSMutableArray *controls;

@property (nonatomic) PathView *clearParentView;

-(void)setImage:(NSString *)imagename;

-(void)highlighter:(BOOL) state;

-(void)connectFrom:(DraggableIcon*)fromThis toThis:(DraggableIcon *)toThis;
-(void)connectFrom2:(DraggableIcon *)fromThis toThis:(DraggableIcon *)toThis;

-(void)deleteLine;

-(void)updateLine;

@end