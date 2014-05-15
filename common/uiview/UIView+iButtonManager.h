//
//  UIView+iButtonManager.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (iButtonManager)



-(UIButton*) addButton:(UIView*)_u 
                 image:(NSString*)_n 
              position:(CGPoint)_p 
                   tag:(int)_t  
                target:(id)_d
                action:(SEL)_a; 

-(UIButton*) addButtonWithCenter:(UIView*)_u 
                           image:(NSString*)_n 
                        position:(CGPoint) _p 
                             tag:(int)_t 
                          target:(id)_d
                          action:(SEL) _a;

- (UIImageView*) addButtonWithImageView:(UIView*)_u 
                                  image:(NSString*)_n 
                              highlight:(NSString*)_hn 
                               position:(CGPoint) _p 
                                      t:(int)_t 
                                 action:(SEL)_a;

-(void)addGroupButton:(UIView*)_u 
                image:(NSString*)_n
                 type:(NSString*)_e
             position:(NSMutableArray*)_ma
             startTag:(int)_t 
               action:(SEL)_a
               target:(id)_d
                alpha:(float)_al;



-(UIButton*) addButton:(UIView*)_u 
                   url:(NSString*)_n 
              position:(CGPoint)_p 
                   tag:(int)_t  
                target:(id)_d
                action:(SEL)_a;


-(void) addTapEvent:(UIView*)_u
             target:(id)_d
             action:(SEL) _a;

-(void) addDoubleTapEvent:(UIView*)_u
                   target:(id)_d
                   action:(SEL) _a;

- (UIImageView*) addButtonWithImageViewWithCenter:(UIView*)_u
                                            image:(NSString*)_n 
                                        highlight:(NSString*)_hn 
                                         position:(CGPoint)_p 
                                                t:(int)_t 
                                           action:(SEL)_a;
@end
