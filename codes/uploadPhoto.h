//
//  uploadPhoto.h
//  sq
//
//  Created by Li yi on 13-7-20.
//
//

#import "iPageView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface uploadPhoto : iPageView<MBProgressHUDDelegate,UITextFieldDelegate>
{
    
    UIImageView *av;
    
    UITextField *UserName;
    UITextField *Password;
    ASIFormDataRequest *regRequest;
    
    MBProgressHUD *HUD;
    id an;
    UIImageView *avatar;
}

-(void)updateAvatar;

@end
