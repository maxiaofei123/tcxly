//
//  v_qup.h
//  tcxly
//
//  Created by Terry on 13-5-6.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"

@interface v_qup : iPageView
{
    UIScrollView *uv;
    
    UIScrollView *sv;
    
    NSArray *question_line_items;
}

-(void)loadInfo:(NSArray*)arr menuIndex:(int)mid;

@end
