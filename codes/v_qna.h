//
//  v_qna.h
//  tcxly
//
//  Created by Terry on 13-5-5.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "v_qna_caogao.h"
#import "ASIHTTPRequest.h"
int allAnser;
@interface v_qna : iPageView<UITextViewDelegate, UIAlertViewDelegate>

{
    UIView *vbar;
    UIImageView *arrow;
    UIImageView *qua;
    
    UILabel *lrtxt;
    UILabel *centertxt;
    
    UIView *ansv;
    
    UILabel *qnumtxt;
    UILabel *quetxt;
    UILabel *timetxt;
    UILabel *title;

    
    ASIHTTPRequest *request;
    
    NSTimer *timer;
    
    int timeall;
    
    UITextView *anstxt;
    UIView * ansview;
    
    int questionID;
    NSArray *questionList;
    
    NSMutableArray *postAnswerArr;
    NSMutableArray *postIDArr;
    
    UIView *qupv;
    UIView *qnav;
    
    UIScrollView *uv;
    UIScrollView *sv;
    
    NSArray *question_line_items;
    
    UIView *imgv;
    
    int opnum;
    
    int timenum;
    
    int unitid;
    
    int  j;
    
    UIButton *backbtn;
    
    v_qna_caogao *cg;
}

-(void)readInfo:(NSDictionary*)qlist;
-(void)loadInfo:(NSDictionary*)arr;
-(void)clearcaogao;
@end
