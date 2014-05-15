//
//  registChooseSex.m
//  tcxly
//
//  Created by Terry on 13-7-20.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "registChooseSex.h"
#import "uploadPhoto.h"
#import "userLogin.h"
#import "v_enter.h"
#import "reg_0.h"

@implementation registChooseSex

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
    
        UIImageView *im = [self addImageView:self
                          image:@"reg_sbg.png"
                       position:CGPointMake(185, 116)];
        
        im.userInteractionEnabled=YES;

        UIImageView *man = [self addButtonWithImageView:im
                                                  image:@"reg_man.png"
                                              highlight:@"reg_man1.png"
                                               position:CGPointMake(100, 160)
                                                      t:1001
                                                 action:@selector(menuClick:)
                            ];
        
        UIImageView *woman=  [self addButtonWithImageView:im
                                                    image:@"reg_girl.png"
                                                highlight:@"reg_girl1.png"
                                                 position:CGPointMake(350, 160)
                                                        t:1002
                                                   action:@selector(menuClick:)
                              ];
        man.highlighted = YES;
        
        lg = [self addImageView:im
                          image:@"regboard.png"
                       position:CGPointMake(-500, -500)
              ];
        lg.center = man.center;
        
        
        
        
        
        CALayer *l2 = [[CALayer alloc] init];
        [l2 setBounds:CGRectMake(0, 0, 262, 525)];
        [l2 setAnchorPoint:CGPointMake(0.7, 0.7)];
        [l2 setPosition:CGPointMake(lg.frame.origin.x - 50, lg.frame.origin.y)];
        [l2 setContents:(UIImage*)[UIImage imageNamed:@"reg_light.png"].CGImage];
        [[lg layer] setMask:l2];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        anim.cumulative = YES;
        anim.toValue = [NSNumber numberWithFloat:-.1*M_PI];
        anim.repeatCount = HUGE_VALF;
        
        [l2 addAnimation:anim forKey:@"animateLayer"];
        

        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:1003
                 target:self
                 action:@selector(backClick:)
         ];
        
                
        
        [self addButton:im
                  image:@"reg_next.png"
               position:CGPointMake(227, 473)
                    tag:1004
                 target:self
                 action:@selector(nextClick:)
         ];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"m"
                                                 forKey:@"sex"];
        
        NSString *sex= [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
        
        
        if ([sex isEqualToString:@"f"])
        {
            lg.center = woman.center;
        }
        else
        {
            lg.center = man.center;
        }
        
    }
    return self;
}

-(void)menuClick:(UIGestureRecognizer*)e {
    lg.center = e.view.center;
    for (int i = 1001; i <= 1002; i++) {
        UIImageView *img = (UIImageView*)[self viewWithTag:i];
        
        [UIView animateWithDuration:.5
                         animations:^{
                             img.highlighted = e.view.tag == i ? YES : NO;
                         }
         ];
    }
    
    
    
    //记录性别
    switch (e.view.tag) {
        case 1001:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"m"
                                                      forKey:@"sex"];
        }
            break;
            
        case 1002:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"f"
                                                      forKey:@"sex"];
        }
            break;
    }
}





-(void)backClick:(UIButton*)e {
    
    
     //回登入
     userLogin *up = [[userLogin alloc]initWithFrame:self.frame];
     [self.superview fadeInView:self withNewView:up duration:.5];
     [up loadCurrentPage:0];

    //返回的话清空
    [[NSUserDefaults standardUserDefaults] setObject:nil
                                              forKey:@"sex"];
}



-(void)nextClick:(UIButton*)e {

    
    reg_0 *q = [[reg_0 alloc]initWithFrame:self.frame];
    [self.superview fadeInView:self withNewView:q duration:1];
    [q loadCurrentPage:0];
}

@end
