//
//  UIView+iButtonManager.m
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+iButtonManager.h"

@implementation UIView (iButtonManager)

//----------------------------------------------------------------------------------------------------
#pragma mark- 添加组按钮
-(void)addGroupButton:(UIView*)_u 
                image:(NSString*)_n
                 type:(NSString*)_e
             position:(NSMutableArray*)_ma
             startTag:(int)_t 
               action:(SEL)_a
               target:(id)_d
                alpha:(float)_al
{
    NSValue *_p;
    for(int i=0;i<[_ma count];i++)
    {
        _p=[_ma objectAtIndex:i];
        
        UIButton *bt= [self addButton:_u
                                image:[NSString stringWithFormat:@"%@%d.%@",_n,i,_e] 
                             position:[_p CGPointValue]
                                  tag:_t+i
                               target:_d 
                               action:_a];
        bt.alpha=_al;
    }
}

//----------------------------------------------------------------------------------------------------
#pragma mark- 添加按钮
-(UIButton*) addButton:(UIView*)_u 
                 url:(NSString*)_n 
              position:(CGPoint)_p 
                   tag:(int)_t  
                target:(id)_d
                action:(SEL)_a
{
    
    UIImage *btBg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_n]]];
    
    UIButton *bt=[UIButton buttonWithType: UIButtonTypeCustom];
    if(_t!=0)
    {
        bt.tag=_t;
    }
    
    
    bt.frame=CGRectMake(_p.x,_p.y,btBg.size.width,btBg.size.height); 
    
    [bt setBackgroundImage:btBg forState:UIControlStateNormal];
    

    //添加事件
    [bt addTarget:_d action:_a forControlEvents:UIControlEventTouchUpInside];
    if(_u!=nil)
        [_u addSubview:bt];
    
    return bt;
}


-(UIButton*) addButton:(UIView*)_u 
                 image:(NSString*)_n 
              position:(CGPoint)_p 
                   tag:(int)_t  
                target:(id)_d
                action:(SEL)_a
{
    
    UIImage *btBg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_n 
                                                                                   ofType:nil]];
    UIButton *bt=[UIButton buttonWithType: UIButtonTypeCustom];
    if(_t!=0)
    {
        bt.tag=_t;
    }
    
    bt.frame=CGRectMake(_p.x,_p.y,btBg.size.width,btBg.size.height); 
    
    [bt setBackgroundImage:btBg forState:UIControlStateNormal];
    
    
    //添加事件
    [bt addTarget:_d action:_a forControlEvents:UIControlEventTouchUpInside];
    if(_u!=nil)
        [_u addSubview:bt];
    
    return bt;
}


-(UIButton*) addButtonWithCenter:(UIView*)_u 
                           image:(NSString*)_n 
                        position:(CGPoint) _p 
                             tag:(int)_t 
                          target:(id)_d
                          action:(SEL) _a
{
    UIButton *i=[self addButton:_u
                          image:_n
                       position:CGPointMake(0, 0)
                            tag:_t
                         target:_d
                         action:_a];
    i.center=_p;
    
    return i;
}

//----------------------------------------------------------------------------------------------------
#pragma mark- 添加ImageView按钮
- (UIImageView*) addButtonWithImageView:(UIView*)_u
                                  image:(NSString*)_n 
                              highlight:(NSString*)_hn 
                               position:(CGPoint)_p 
                                      t:(int)_t 
                                 action:(SEL)_a
{
    
    UIImage *btBg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                    pathForResource:_n ofType:nil]];
    
    UIImageView *bt=[[UIImageView alloc] initWithFrame:CGRectMake(_p.x,
                                                                  _p.y, 
                                                                  btBg.size.width, 
                                                                  btBg.size.height)]; 
    bt.userInteractionEnabled=YES;
    bt.tag=_t;
    bt.image=btBg;
    
    if(_hn!=nil)
    {
        bt.highlightedImage=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                              pathForResource:_hn ofType:nil]];
        
    }
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] 
                                               initWithTarget:self 
                                               action:_a];
    [bt addGestureRecognizer:singleFingerTap];
    
    [_u addSubview:bt];
    
    return bt;
}



- (UIImageView*) addButtonWithImageViewWithCenter:(UIView*)_u
                                            image:(NSString*)_n 
                                        highlight:(NSString*)_hn 
                                         position:(CGPoint)_p 
                                                t:(int)_t 
                                           action:(SEL)_a
{
    
    
    UIImageView *bt=[self addButtonWithImageView:_u
                                           image:_n
                                       highlight:_hn
                                        position:_p
                                               t:_t
                                          action:_a];
    
    bt.center=_p;
    
    return bt;
}


-(void) addTapEvent:(UIView*)_u
             target:(id)_d
             action:(SEL) _a
{
    
    _u.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] 
                                               initWithTarget:_d 
                                               action:_a];
    [_u addGestureRecognizer:singleFingerTap];
}

-(void) addDoubleTapEvent:(UIView*)_u
                   target:(id)_d
                   action:(SEL) _a
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                   initWithTarget:_d 
                                   action:_a];
    tap.numberOfTapsRequired=2;
    
    [_u addGestureRecognizer:tap];
}





@end
