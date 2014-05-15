//
//  personal.h
//  tcxly
//
//  Created by Li yi on 13-9-25.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "ASIHTTPRequest.h"

@interface personal : iPageView
{
    ASIHTTPRequest *request;
    
    UIImageView *avatar;
    
    UILabel *un;
    
    NSDictionary *items;
    
    float scalePos;
    id avt;
}

-(void)updateAvatar;
-(void)updateInfo;
@end
