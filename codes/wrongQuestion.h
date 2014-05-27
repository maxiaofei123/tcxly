//
//  wrongQuestion.h
//  tcxly
//
//  Created by user on 14-5-19.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "v_qna_caogao.h"
#import "ASIFormDataRequest.h"

@interface wrongQuestion : iPageView
{

    ASIFormDataRequest *request;
    
   
    UILabel *qnumtxt;
    UILabel *quetxt;
    UILabel *timetxt;
    UILabel *title;
    UILabel *lrtxt;
    UILabel *centertxt;
    
    UIView * ansview;
    UIView *qupv;
    UIView *qnav;
    UIView *qua;
    UIView *imgv;
    UIView *ansv;
    
    UITextView *anstxt;
    UIAlertView *alert;
    UIImageView *arrow;
    
    int questionID;
    int opnum;
    int unitid;
    
    
    NSMutableArray *postAnswerArr;
    NSMutableArray *postIDArr;
    NSArray *allArray;
    NSMutableArray *questionList;
    NSDictionary * questions;

    
    
    v_qna_caogao *cg;
   
}

-(void)wrong_answers;
@end
