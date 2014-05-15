//
//  reg_0.h
//  tcxly
//
//  Created by Li yi on 14-2-18.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "UIView+iTextManager.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"


@interface reg_0 : iPageView<MBProgressHUDDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    UIImageView *im,*avatar;
    int aid;
    NSString *avatarId;
    id an;
   
    UITextField *Password;
    UITextField *ConfirmPassword;
    UITextField *UserName;
           
    ASIFormDataRequest *regRequest;
    ASIFormDataRequest *request;
    
    MBProgressHUD *HUD;
   
}

-(void)updateAvatar:(UIImage * )image;
-(void)updateAvatar;

@property(nonatomic,strong) UIImage *image;


@end
