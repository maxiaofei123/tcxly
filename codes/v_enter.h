//
//  v_enter.h
//  tcxly
//
//  Created by Terry on 13-5-4.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "iSequenceFrameView.h"
#import "v_level.h"

@interface v_enter : iPageView<iSequenceFrameViewDelegate,UIAlertViewDelegate>

{
    iSequenceFrameView *sf;
    int vid;
    v_level *vl;
    UIView *btnv;
    
    int value2;
    
    UIAlertView* alert;
    NSTimer * timer;
}

-(void)showMenu;
-(void)showList;
-(void)user_Login;

@end
