//
//  v_intive.m
//  tcxly
//
//  Created by Terry on 13-5-4.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_intive.h"
#import "v_enter.h"

@implementation v_intive

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"ie_bg.jpg"];
        
        [self addButton:self
                  image:@"ie_back.png"
               position:CGPointMake(20, 40)
                    tag:3000
                 target:self
                 action:@selector(backClick:)
         ];
    }
    return self;
}

-(void)backClick:(UIButton*)e {
    v_enter *ve = [[v_enter alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
         withNewView:ve
            duration:.5
     ];
}

-(void)loadCurrentPage:(int)cmd {
    
    for (int i = 1; i < 4; i++) {
        UIButton *btn = [self addButton:self
                                  image:[NSString stringWithFormat:@"ie_b%d.png", i]
                               position:CGPointMake(218, 292 + (i - 1) * 100)
                                    tag:000 + i
                                 target:self
                                 action:@selector(menuClick:)
                         ];
        
        
        btn.center = CGPointMake(btn.center.x + 50, btn.center.y);
        btn.alpha = 0;
        
        
        [UIView animateWithDuration:.5
                              delay:i * .2
                            options:UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             btn.alpha = 1;
                             btn.center = CGPointMake(btn.center.x - 70, btn.center.y);
                         } completion:^(BOOL finished) {
                             [self btnBack:btn];
                         }];
    }
}

-(void)btnBack:(UIButton*)btn {
    [UIView animateWithDuration:.5
                     animations:^{
                         btn.center = CGPointMake(btn.center.x + 20, btn.center.y);
                     }];
}

-(void)menuClick:(UIButton*)e {
    
}

@end
