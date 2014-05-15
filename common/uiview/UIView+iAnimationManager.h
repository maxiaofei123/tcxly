//
//  UIView+iAnimationManager.h
//  test
//
//  Created by 毅 李 on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (iAnimationManager)


-(CGPoint)LeftPointToCenter:(CGPoint)p view:(UIView*)v;

-(void) startAnimation:(UIView*) v
                  sPos:(CGPoint) sp
                  ePos:(CGPoint) ep
                sAlpha:(float) sa 
                eAlpha:(float) ea
                sScale:(CGPoint) ss
                eScale:(CGPoint) es 
              duration:(NSTimeInterval) t 
                 delay:(NSTimeInterval) d 
                option:(UIViewAnimationOptions) o;


-(void)setRoate:(UIView*)v dir:(int)d;

-(void) fadeInView:(UIView*) v1 
       withNewView:(UIView*) v2 
          duration:(float)d;


-(void)fadeInView:(UIView *)v1 
         duration:(float)d;

-(void)fadeOutView:(UIView*)v duration:(float)d;
-(void)setMove:(UIView*)v start:(CGPoint)sp end:(CGPoint)ep time:(float)t;
-(void)setFlash:(UIView*)v time:(float)t startValue:(float)sv endValue:(float)ev;

-(UIImageView*)setShadowAnimtion:(UIView*)v Image:(NSString*)fn time:(float)t;
-(UIImageView*)setShadowAnimtion:(UIView*)v Image:(NSString*)fn time:(float)t maxScale:(float)f startAlpha:(float)sa endAlpha:(float)ea;
-(UIImageView*)setLight:(UIView*)sv View:(UIView*)v Mask:(NSString*)m Light:(NSString*)l  duration:(NSTimeInterval) t;
-(void)setZoom:(UIView*)v0 from:(UIView*)v1 duration:(NSTimeInterval)t  completion:(void (^)(void))animations;

//add in 0624
-(void)changeAnimateWithView:(UIView*)v1 withNewView:(UIView*)v2 transtion:(UIViewAnimationTransition)t duration:(float)f;
-(void)setViewGoAndBack:(UIView*)v withXorY:(NSString*)vxy gap:(int)g time:(float)t;
-(void)changeAnimateWithLayer:(UIView*)v1 withNewView:(UIView*)v2 type:(NSString*)t duration:(float)f;
-(void)showScale:(UIView*)cir duration:(float)f startValue:(float)v1 endValue:(float)v2;
-(UIImageView*)setScaleAndAlpha:(UIView*)v maskMC:(NSString*)src startScale:(float)f1 endScale:(float)f2 startAlpha:(float)a1 endAlpha:(float)a2 duration:(float)d;
@end
