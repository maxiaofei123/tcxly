//
//  v_score.h
//  tcxly
//
//  Created by Terry on 13-5-5.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"

@interface v_score : iPageView

{
    NSArray *answerArr;
    UIImageView * ui;
}

-(void)sendAnswer:(NSArray*)arr;

@end