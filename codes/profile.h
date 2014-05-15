//
//  profile.h
//  tcxly
//
//  Created by Li yi on 13-9-14.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface profile : iPageView<UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    ASIFormDataRequest *request;

    UIImageView *avatar,*pa;
    
    UITextField *year,*month,*day,*homeAddress,*homeName,*schoolAddress,*schoolName,*qq,*email,*username;
    
    id aid;

    id an;
    
    UIScrollView *sv;
    
    BOOL changed;
    
    float scalePos;
    MBProgressHUD *HUD;

    
     NSDictionary *items;
    UIImageView * ChooseSex;
    id fm;
   
}

-(void)updateAvatar:(int)a;
-(void)loadP:(NSDictionary*)p;
-(void)avtatarImage:(UIImage * )image;

@property(nonatomic,strong) UIImage *image;




@end
