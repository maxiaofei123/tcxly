//
//  wrongQuestion.m
//  tcxly
//
//  Created by user on 14-5-19.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "wrongQuestion.h"
#import "UIView+iTextManager.h"
#import "UIView+iAnimationManager.h"
#import "v_unit.h"
#import "MainViewController.h"

@implementation wrongQuestion

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        postAnswerArr = [NSMutableArray array];
        postIDArr = [NSMutableArray array];
        
        [self addBackground:@"bg.png"];
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:8888
                 target:self
                 action:@selector(backClick:)
         ];
        
        qnav = [[UIView alloc]initWithFrame:self.frame];
        [self addSubview:qnav];
        
        qupv = [[UIView alloc]initWithFrame:CGRectMake(0, 96, 1024, 668)];
        [self addSubview:qupv];
        qupv.alpha = 0;
        
        qua = [self addImageView:qnav image:@"qna_ui.png" position:CGPointMake(175, 0)];
        lrtxt = [self addLabel:qnav
                         frame:CGRectMake(275, 40, 50, 32)
                          font:[UIFont systemFontOfSize:32]
                          text:@"1"
                         color:[UIColor colorWithRed:81.f/255.f green:244.f/255.f blue:233.f/255.f alpha:1]
                           tag:8001];
        
        [self addImageView:qnav image:@"qua_l.png" position:CGPointMake(310, 33)];
        
        centertxt = [self addLabel:qnav
                             frame:CGRectMake(350, 40, 50, 32)
                              font:[UIFont systemFontOfSize:32]
                              text:@""
                             color:[UIColor colorWithRed:81.f/255.f green:244.f/255.f blue:233.f/255.f alpha:1]
                               tag:8002];
        
               
        [self addButton:qnav
                  image:@"qna_submit.png"
               position:CGPointMake(895, 27)
                    tag:5000
                 target:self
                 action:@selector(tjClick:)
         ];
        
        //图片加载区域
        imgv = [[UIView alloc] initWithFrame:CGRectMake(500, 250, 500, 500)];
        [qnav addSubview:imgv];
        //问题 回答
        ansv = [[UIView alloc]initWithFrame:CGRectMake(19, 132, 850, 500)];
        [qnav addSubview:ansv];
        
        //pan
        
        [self addButton:qnav image:@"qua_pan.png" position:CGPointMake(906, 200 ) tag:4000 target:self action:@selector(panClick:)
         ];
        [self addButton:qnav image:@"qua_Eraser.png" position:CGPointMake(906, 300) tag:4001 target:self action:@selector(panClick:)];
        
        [self addButton:qnav image:@"qua_cagaoLgo.png" position:CGPointMake(896, 400) tag:4002 target:self action:@selector(panClick:)];
        
        
        //上一题 下一题
        [self addButton:qnav
                  image:@"qua_up.png"
               position:CGPointMake(280, 648)
                    tag:3001
                 target:self
                 action:@selector(queClick:)
         ];
        [self addButton:qnav
                  image:@"qua_next.png"
               position:CGPointMake(675, 648)
                    tag:3002
                 target:self
                 action:@selector(queClick:)
         ];
        
        
        cg=[[v_qna_caogao alloc] initWithFrame:CGRectMake(452, 90, 463, 680)];
        [self addSubview:cg];
        
        cg.hidden=YES;
        cg.userInteractionEnabled=NO;

        
    }
    
     return self;
}

-(void)wrong_answers{

   NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
  NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/exams/wrong_answers.json?auth_token=%@&grade_id=%d",token,2]];
    
    NSLog(@"url = %@",url);
    
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    request.tag=4001;

}


- (void)requestFailed:(ASIHTTPRequest *)r
{
    
    NSError *error = [r error];
    NSLog(@":%@",error);
 
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络不给力，稍后在试用"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{

    NSError *error = nil;
    NSData *jsonData = [request responseData];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSDictionary * dic = (NSDictionary * )jsonObject;
    [self readInfo:dic];

}

-(void)readInfo:(NSDictionary*)qlist {

    NSArray *op = [NSArray array];
    op = [qlist objectForKey:@"wrong_answers"];
    NSLog(@"op=%@",op);
    if([op count]==0){return;}
    questionList =[[NSMutableArray alloc]init ];
    questions = [[NSMutableArray alloc]init ];

    for (int i =0; i<[op count]; i++) {
         NSLog(@"i=%d,count=%d",i ,[op count]);
        
        NSDictionary  * dic = [[NSDictionary alloc]init] ;
        dic = [[op objectAtIndex:i] valueForKey:@"wrong_answer"];

        NSDictionary * question_line_item =[[NSDictionary alloc]init];
        question_line_item = [dic valueForKey:@"question_line_item"];
        [questionList addObject:question_line_item];

       /* NSDictionary * ques =[[NSDictionary alloc]init];
        ques = [question_line_item valueForKey:@"question"];
 
        
        NSDictionary * oparr =[[NSDictionary alloc]init];
        oparr = [ques valueForKey:@"single_choice_options"];

        */
    }

    NSLog(@"wrong_answer=%@",questionList);
    
    questionID = 0;
 //   unitid = [[[op objectAtIndex:0] objectForKey:@"id"] integerValue];
   // NSLog(@"unitId =%d",unitid);
    
    questions = [[NSDictionary alloc]init];
    questions = [[questionList objectAtIndex:0] objectForKey:@"question"];
    NSLog(@"questions =%@",questions);
    
    NSArray *oparr = [[NSArray alloc] init];
    oparr = [questions objectForKey:@"single_choice_options"];

    opnum = [oparr count];
    NSLog(@"opum =%d",opnum);
    // a b c d
    for (int i = 0; i < opnum; i++) {
        
        NSLog(@"%d",i%2);
        if(i%2 ==1){
            ansview= [[UIView alloc]initWithFrame:CGRectMake(552, 350 + (i/2)*96, 150, 90)];
            [qnav addSubview:ansview];
            ansview.tag = 5000 + i;
        }else{
            
            ansview = [[UIView alloc]initWithFrame:CGRectMake(323, 351 + (i/2)* 96, 150, 90)];
            [qnav addSubview:ansview];
            ansview.tag = 5000 + i;
            
        }
        
        
        [self addTapEvent:ansview target:self action:@selector(ansClick:)];
        UIImageView *btn =[self addImageView:ansview
                                       image:[NSString stringWithFormat:@"qna_%d.png", i+1]
                                    position:CGPointMake(0,0)
                                         tag:7000 + i
                           ];
        // ansview.userInteractionEnabled=YES;
        btn.transform = CGAffineTransformMakeScale(1, 1);
        btn.center = CGPointMake(25, 25);
        btn.alpha = 0.8;
        
        UILabel *alb = [self addLabel:ansview
                                frame:CGRectMake(80, 10, 500, 32)
                                 font:[UIFont systemFontOfSize:32]
                                 text:[oparr[0] objectForKey:@"content"]
                                color:[UIColor blackColor]
                                  tag:7500 + i
                        ];
        alb.alpha = .7;
    }
    
    for (int i = 0; i < [questionList count]; i++) {
        [postAnswerArr addObject:[NSString stringWithFormat:@""]];
        [postIDArr addObject:[NSNumber numberWithInt:-1]];
    }
    //当前题目编号

    quetxt = [self addLabel:qua
                      frame:CGRectMake(255, 185, 300, 50)
                       font: [UIFont boldSystemFontOfSize:50]
                       text:@""
                      color:[UIColor blackColor]
                        tag:12002
              ];
    //    quetxt.numberOfLines = 3;
    quetxt.shadowOffset=CGSizeMake(0, 1);
    quetxt.shadowColor=[UIColor whiteColor];
    
    anstxt = [[UITextView alloc]initWithFrame:CGRectMake(83, -282, 782, 132)];
    anstxt.backgroundColor=[UIColor clearColor];
    anstxt.returnKeyType = UIReturnKeyDone;
    anstxt.font = [UIFont systemFontOfSize:20];
    anstxt.textColor = [UIColor blackColor];
    anstxt.tag=80000;
    anstxt.delegate = self;
    [anstxt setKeyboardType:UIKeyboardTypeNumberPad];
    [qnav addSubview:anstxt];
    
    [self setQuestion];
}

-(void)textViewDidChange:(UITextView *)textView {
    //    [postAnswerArr replaceObjectAtIndex:questionID withObject:textView.text];
}

-(void)setQuestion {
    
    
    anstxt.text = [postAnswerArr objectAtIndex:questionID];

    qnumtxt.text = [NSString stringWithFormat:@"%d :", questionID + 1];
    quetxt.text = [NSString stringWithFormat:@"%@", [questions objectForKey:@"subject"]];
    
    for (int i = 0; i < opnum; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:7000 + i];
        UILabel *ub = (UILabel*)[self viewWithTag:7500 + i];
        ub.text = [NSString stringWithFormat:@"%@", [questionList[i] objectForKey:@"content"]];
        if(i == [postIDArr[questionID] integerValue]) {
            btn.alpha = 1;
        }else {
            
            btn.alpha = .7;
            
            
        }
    }
    
    for (int i = 0; i < 90; i ++) {
        UIImageView *bar = (UIImageView*)[self viewWithTag:9000 + i];
        if((int)(questionID * 90 / [questionList count]) + 1 >= i) {
            bar.alpha = 1;
        }else {
            bar.alpha = 0;
        }
    }
    arrow.frame = CGRectMake((int)(questionID * 622 / [questionList count]) + 5, arrow.frame.origin.y, arrow.frame.size.width, arrow.frame.size.height);
    
    for(UIView *sview in imgv.subviews) {
        [sview removeFromSuperview];
        
    }
    
    /*NSString *imgurl = [questions objectForKey:@"thumb_image_url"];
    if(imgurl) {
        
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgurl]];
        UIImage *image=[[UIImage alloc] initWithData:imageData];
        UIImageView *imgview = [[UIImageView alloc]initWithImage:image];
        [imgv addSubview:imgview];
    }*/
}




-(void)queClick:(UIButton*)e {
    if(e.tag == 3001) {
        questionID = questionID - 1 < 0 ? 0 : questionID - 1;
    }else {
        questionID = questionID + 1 >= [questionList count] - 1 ? [questionList count] - 1 : questionID + 1;
    }
    lrtxt.text = [NSString stringWithFormat:@"%d",questionID+1];
    
    [self setQuestion];
}

/*
-(void)loadInfo:(NSMutableDictionary *)arr {
    
    NSArray *question_groups = [[NSArray alloc]init];
    question_groups = [arr objectForKey:@"question_groups"];
    
    // NSLog(@"%@", question_groups);
    question_line_items = [[NSArray alloc]init];
    question_line_items = [question_groups[0] objectForKey:@"question_line_items"];
    
    MainViewController *mvc = (MainViewController*)[self getManager];
    mvc.allArr = question_line_items;
    
    centertxt.text = [NSString stringWithFormat:@"%d",[question_line_items count]];
    
    allAnser = [question_line_items count];
    
    for (int i = 0; i < [question_line_items count]; i ++) {
        
        
        UIView *txt = [[UIView alloc]initWithFrame:CGRectMake(0, 24 + i * 80, 1042, 42)];
        txt.tag = 2000 + i;
        [sv addSubview:txt];
        [self addTapEvent:txt target:self action:@selector(txtClick:)];
        
        [self addImageView:txt
                     image:@"qp_line.png"
                  position:CGPointMake(0, 50)
         ];
        
        UILabel *tum = [self addLabel:txt
                                frame:CGRectMake(30, 0, 100, 24)
                                 font:[UIFont fontWithName:@"Gretoon" size:24]
                                 text:[NSString stringWithFormat:@"%d :", i + 1]
                                color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                                  tag:2998
                        ];
        tum.shadowOffset=CGSizeMake(0, 1);
        tum.shadowColor=[UIColor whiteColor];
        //        tum.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *questions = [[NSDictionary alloc]init];
        questions = [question_line_items[i] objectForKey:@"question"];
        
        UILabel *ques = [self addLabel:txt
                                 frame:CGRectMake(120, 0, 500, 24)
                                  font:[UIFont fontWithName:@"Arial" size:24]
                                  text:[questions objectForKey:@"subject"]
                                 color:[UIColor redColor]
                                   tag:2999
                         ];
        ques.alpha = .5;
        ques.shadowOffset=CGSizeMake(0, 1);
        ques.shadowColor=[UIColor whiteColor];
        
        [sv setContentSize:CGSizeMake(1024, (i + 1) * 80)];
    }
}
*/

-(void)updateQuestionState {
    UIView *hasAnswerTxt = [self viewWithTag:2000 + questionID];
    UILabel *curlabel = (UILabel*)[hasAnswerTxt viewWithTag:2999];
    curlabel.textColor = [UIColor blackColor];
    curlabel.alpha = 1;
}

/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(alertView.tag == 9502) {
        if(buttonIndex == 0) [self uploadAnswer];
    }else if(alertView.tag == 9609) {
        timer=[NSTimer scheduledTimerWithTimeInterval:1
                                               target:self
                                             selector:@selector(update)
                                             userInfo:nil
                                              repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }else if(alertView.tag == 9501) {
        if(buttonIndex == 0) [self uploadAnswer];
    };


}*/

/*
-(void)tjClick:(UIButton*)e {
    
    
    int doneQue = 0;
    for (int i = 0; i < [postAnswerArr count]; i++) {
        if(![postAnswerArr[i] isEqualToString:@""]) {
            doneQue ++;
        }
    }
    
    if(doneQue == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"你还没有做题目哦~"
                                                           delegate:self
                                                  cancelButtonTitle:@"提交"
                                                  otherButtonTitles:@"继续做题",nil];
        alertView.tag = 9501;
        [alertView show];
    }
    else if(doneQue < [postAnswerArr count] - 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"题目还没有全部做完, 是否提交答卷?"
                                                           delegate:self
                                                  cancelButtonTitle:@"提交"
                                                  otherButtonTitles:@"继续做题", nil];
        alertView.tag = 9502;
        [alertView show];
    }else
    {
        [self uploadAnswer];
    }
}

-(void)queClick:(UIButton*)e {
    if(e.tag == 3001) {
        questionID = questionID - 1 < 0 ? 0 : questionID - 1;
    }else {
        questionID = questionID + 1 >= [questionList count] - 1 ? [questionList count] - 1 : questionID + 1;
    }
    lrtxt.text = [NSString stringWithFormat:@"%d",questionID+1];
    
   // [self setQuestion];
}

*/
-(void)backClick:(UIButton*)sender
{
    
    [self.superview fadeOutView:self duration:.5];
    
}


-(void)panClick:(UIButton*)e {
    
    NSLog(@"草稿来了, 修改下");
    
    
    [cg loadCurrentPage:e.tag - 4000+1];
    cg.hidden=NO;
    cg.userInteractionEnabled=YES;

}


-(void)clearcaogao {
    cg = nil;
}


@end
