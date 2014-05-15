//
//  userLogin.h
//  sq
//
//  Created by Li yi on 13-7-20.
//
//

#import "iPageView.h"
#import "UIView+iTextManager.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "v_level.h"
#import "ASIHTTPRequest.h"

@interface userLogin : iPageView<UIAlertViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITextField *Password;
    UITextField *UserName;
    v_level *vl;
    
    NSString *avatarId;

    MBProgressHUD *HUD;
}

@end
