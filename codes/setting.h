//
//  profile.h
//  tcxly
//
//  Created by Li yi on 13-9-12.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "ASIFormDataRequest.h"

@interface setting : iPageView<UIAlertViewDelegate>
{
    ASIFormDataRequest *request;
}
@end
