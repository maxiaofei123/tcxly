//
//  v_answerCheck.h
//  tcxly
//
//  Created by Terry on 13-9-8.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"

@interface v_answerCheck : iPageView

{
    NSArray *question_line_items;
}

-(void)sendAnswer:(NSArray*)arr;

@end
