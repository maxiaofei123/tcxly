//
//  v_qna.m
//  tcxly
//
//  Created by Terry on 13-5-5.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_qna.h"
#import "v_unit.h"
#import "v_score.h"
#import "v_shop.h"
#import "v_level.h"
#import "UIView+iTextManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"
#import "MainViewController.h"
#import "v_qna_caogao.h"

@implementation v_qna

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        timenum = 3;
        
        postAnswerArr = [NSMutableArray array];
        postIDArr = [NSMutableArray array];
        
        [self addBackground:@"bg.png"];
        
        qnav = [[UIView alloc]initWithFrame:self.frame];
        [self addSubview:qnav];
        
        qupv = [[UIView alloc]initWithFrame:CGRectMake(0, 96, 1024, 668)];
        [self addSubview:qupv];
        qupv.alpha = 0;
        
        backbtn = [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:8888
                 target:self
                 action:@selector(backClick:)
         ];
        qua = [self addImageView:qnav image:@"qua_bg.png" position:CGPointMake(175, 0)];
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
        
      
        //时间
       
        [self addImageView:qnav
                     image:@"qua_time.png"
                  position:CGPointMake(540, 25)];
        timetxt = [self addLabel:qnav
                           frame:CGRectMake(620, 43, 100, 32)
                            font:[UIFont systemFontOfSize:25]
                            text:@"00:00"
                           color:[UIColor colorWithRed:81.f/255.f green:244.f/255.f blue:233.f/255.f alpha:1]
                             tag:5670
                   ];
        
        [self addTapEvent:timetxt target:self action:@selector(pauseClick:)];
        
        [self addButton:qnav
                  image:@"qq_submit.png"
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
      
            [self addButton:qnav
                      image:@"qua_pan.png"
                   position:CGPointMake(916, 257 )
                        tag:4000
                     target:self
                     action:@selector(panClick:)
             ];
        [self addButton:qnav image:@"qua_Eraser.png" position:CGPointMake(916, 357) tag:4001 target:self action:@selector(panClick:)];

        
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
        
        [self addQupAnyThing];

        
        
         cg=[[v_qna_caogao alloc] initWithFrame:CGRectMake(452, 90, 463, 680)];
         [self addSubview:cg];
        
         cg.hidden=YES;
         cg.userInteractionEnabled=NO;
        
    }
    return self;
}


//pause
-(void)pauseClick:(UIGestureRecognizer*)e {
   // NSLog(@"pause timer");
    
    if(timenum <= 0) {
        return;
    }
    
    if(timer) {
        timenum --;
        [timer invalidate];
        timer = nil;
        UIView *mskmc = [[UIView alloc] initWithFrame:self.frame];
        mskmc.tag = 909090;
        mskmc.alpha = .5;
        [self addSubview:mskmc];
        mskmc.backgroundColor = [UIColor blackColor];
        [self addTapEvent:mskmc target:self action:@selector(startClick:)];
        timetxt.text = @"暂停";
    }
}

-(void)startClick:(UIGestureRecognizer*)e {
    [[self viewWithTag:909090] removeFromSuperview];
    timer=[NSTimer scheduledTimerWithTimeInterval:1
                                           target:self
                                         selector:@selector(update)
                                         userInfo:nil
                                          repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)update
{
    timeall = timeall - 1 > 0 ? timeall - 1 : 0;
    timetxt.text = [self getTime];
}

-(NSString*)getTime {
    
    int imin = (int)(timeall / 60);
    int isec = (int)(timeall % 60);
    
    NSString *min = [NSString stringWithFormat:@"%@%d", imin < 10 ? @"0" : @"", imin];
    NSString *sec = [NSString stringWithFormat:@"%@%d", isec < 10 ? @"0" : @"", isec];
    
    NSString *addTime = [NSString stringWithFormat:@"%@:%@", min, sec];
    
    return addTime;
}

-(void)ansClick:(UIGestureRecognizer*)e {
    
//    UILabel *lb = (UILabel*)[self viewWithTag:e.tag + 500];
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:7000 + i];
        if(btn.tag == e.view.tag + 2000) {
            btn.alpha = 1;
            [postAnswerArr replaceObjectAtIndex:questionID withObject:[NSString stringWithFormat:@"%d", i]];
            [postIDArr replaceObjectAtIndex:questionID withObject:[NSNumber numberWithInt:i]];
        }else {
            btn.alpha = .3;
        }
    }
    
    [self updateQuestionState];
}

-(void)loadCurrentPage:(int)cmd {
    NSString *str = [NSString stringWithFormat:@"http://gifted-center.com/api/units/%d.json", cmd];
    NSURL *url = [NSURL URLWithString:str];
    request = [ASIHTTPRequest requestWithURL:url];
    request.tag = 60005;
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    
    UIActivityIndicatorView *loginLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [loginLoading setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height/2)];
    loginLoading.tag = 9991;
    [self addSubview:loginLoading];
    [loginLoading startAnimating];
}

#pragma mark –
#pragma mark 请求完成 requestFinished

- (void)requestFailed:(ASIHTTPRequest *)req
{
    NSError *error = [req error];
    NSLog(@"login:%@",error);
    
    [self clearUnuseful];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络无法连接, 请检查网络并重试."
                                                       delegate:self
                                              cancelButtonTitle:@"重试"
                                              otherButtonTitles:@"好", nil];
    [alertView show];
    
}

-(void)clearUnuseful {
    UIActivityIndicatorView *loginLoading = (UIActivityIndicatorView*)[self viewWithTag:9991];
    [loginLoading stopAnimating];
    [loginLoading removeFromSuperview];
    [[self viewWithTag:9992] removeFromSuperview];
}

-(void)readInfo:(NSDictionary*)qlist {
    
    questionList = [[qlist objectForKey:@"question_groups"][0] objectForKey:@"question_line_items"];
   // NSLog(@"--> %@", questionList);
 
    questionID = 0;
    
    unitid = [[qlist objectForKey:@"id"] integerValue];
    
    timeall = [[qlist objectForKey:@"exam_minutes"] integerValue] * 60;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"开始做题目了, 准备好了么?"
                                                       delegate:self
                                              cancelButtonTitle:@"开始"
                                              otherButtonTitles:nil];
    alertView.tag = 9609;
    [alertView show];
    
    NSDictionary *questions = [[NSDictionary alloc]init];
    questions = [questionList[questionID] objectForKey:@"question"];
    NSArray *oparr = [NSArray array];
    oparr = [questions objectForKey:@"single_choice_options"];
    
    opnum = [oparr count];
    // a b c d
    for (int i = 0; i < opnum; i++) {
    
        NSLog(@"%d",i%2);
        if(i%2 ==1){
            ansview= [[UIView alloc]initWithFrame:CGRectMake(630, 320 + (i/2)*130, 150, 90)];
            [qnav addSubview:ansview];
            ansview.tag = 5000 + i;
        }else{
            
            ansview = [[UIView alloc]initWithFrame:CGRectMake(325, 320 + (i/2)* 130, 150, 90)];
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
        
        UILabel *alb = [self addLabel:btn
                 frame:CGRectMake(125, 45, 100, 32)
                  font:[UIFont systemFontOfSize:32]
                  text:[oparr[i] objectForKey:@"content"]
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
    /*
  qnumtxt = [self addLabel:qua
                            frame:CGRectMake(215, 183, 80, 60)
                             font:[UIFont fontWithName:@"Gretoon" size:40]
                             text:@""
                            color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                              tag:12001
                    ];
    qnumtxt.shadowOffset=CGSizeMake(0, 1);
    qnumtxt.shadowColor=[UIColor whiteColor];
    qnumtxt.textAlignment = NSTextAlignmentCenter;
    
    */
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
    NSDictionary *questions = [[NSDictionary alloc]init];
    questions = [questionList[questionID] objectForKey:@"question"];
    qnumtxt.text = [NSString stringWithFormat:@"%d :", questionID + 1];
    quetxt.text = [NSString stringWithFormat:@"%@", [questions objectForKey:@"subject"]];
    
    for (int i = 0; i < opnum; i++) {
        UIButton *btn = (UIButton*)[self viewWithTag:7000 + i];
        UILabel *ub = (UILabel*)[self viewWithTag:7500 + i];
        ub.text = [NSString stringWithFormat:@"%@", [[questions objectForKey:@"single_choice_options"][i] objectForKey:@"content"]];
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
    
    NSString *imgurl = [questions objectForKey:@"thumb_image_url"];
    if(imgurl) {
        
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgurl]];
        UIImage *image=[[UIImage alloc] initWithData:imageData];
        UIImageView *imgview = [[UIImageView alloc]initWithImage:image];
        [imgv addSubview:imgview];
    }
}

-(void)backClick:(UIButton*)e {//此处应返回到试卷界面
    
      [self fadeOutView: self duration:.5];
    
}


-(void)zongtimu:(UIButton*)e {
    
    backbtn.alpha = 0;
    [UIView animateWithDuration:.5
                     animations:^{
                         qupv.alpha = 1;
                     }
     ];
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

-(void)panClick:(UIButton*)e {
    
    NSLog(@"草稿来了, 修改下");
    
    
    [cg loadCurrentPage:e.tag - 4000+1];
    cg.hidden=NO;
    cg.userInteractionEnabled=YES;
    
//
//    if(!cg) {
//        //cg=[[v_qna_caogao alloc] initWithFrame:CGRectMake(452, 90, 463, 680)];
//        
//        
//    }else {
//        [cg loadCurrentPage:e.tag - 4000];
//    }
}

-(void)clearcaogao {
    cg = nil;
}

//------qup anything

-(void)addQupAnyThing {
    
    UIImageView *bgd = [self addImageView:qupv
                 image:@"qp_wh.png"
              position:CGPointMake(0, 0)];
    bgd.frame = CGRectMake(0, 0, 1024, 672);
    
    sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 672)];
    [qupv addSubview:sv];
}

-(void)setcurunit:(int)i {
    
    UIImageView *ut = (UIImageView*)[self viewWithTag:1000 + i];
    UIImageView *board = (UIImageView*)[self viewWithTag:8787];
    board.center = ut.center;
    board.alpha = 1;
}

-(void)utClick:(UIGestureRecognizer*)e {
    [self setcurunit:e.view.tag - 1000];
}

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

//设置是否已经答题

-(void)updateQuestionState {
    UIView *hasAnswerTxt = [self viewWithTag:2000 + questionID];
    UILabel *curlabel = (UILabel*)[hasAnswerTxt viewWithTag:2999];
    curlabel.textColor = [UIColor blackColor];
    curlabel.alpha = 1;
}

-(void)txtClick:(UIGestureRecognizer*)e {
    [UIView animateWithDuration:.5
                     animations:^{
                         qupv.alpha = 0;
                         backbtn.alpha = 1;
                     }
     ];
    questionID = e.view.tag - 2000;
    [self setQuestion];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
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
}

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
    }else if(doneQue < [postAnswerArr count] - 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"题目还没有全部做完, 是否提交答卷?"
                                                           delegate:self
                                                  cancelButtonTitle:@"提交"
                                                  otherButtonTitles:@"继续做题", nil];
        alertView.tag = 9502;
        [alertView show];
    }else {
        [self uploadAnswer];
    }
}

-(void)setLoading {
    UIView *ldv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    ldv.tag = 9997;
    ldv.backgroundColor = [UIColor blackColor];
    [self addSubview:ldv];
    ldv.alpha = .5;
    
    UIActivityIndicatorView *loginLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [loginLoading setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height/2)];
    loginLoading.tag = 9991;
    [self addSubview:loginLoading];
    [loginLoading startAnimating];
    
    UILabel *txt = [self addLabel:self
                            frame:CGRectMake(0, 0, 200, 100)
                             font:[UIFont systemFontOfSize:18]
                             text:@"正在提交..."
                            color:[UIColor whiteColor]
                              tag:9992
                    ];
    txt.shadowColor = [UIColor blackColor];
    txt.textAlignment = UITextAlignmentCenter;
    txt.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 + 50);
}

//
// 提交数据
//

-(void)uploadAnswer {
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [self setLoading];
    
    NSMutableArray *postDic = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [postAnswerArr count]; i++) {
        
        int queid = [postIDArr[i] integerValue];
        NSLog(@"queid = %d", queid);
        
        NSArray *opdic = [[questionList[i] objectForKey:@"question"] objectForKey:@"single_choice_options"];
        if(queid != -1) {
            [postDic addObject:[NSDictionary dictionaryWithObjectsAndKeys:[questionList[i] objectForKey:@"id"], @"question_line_item_id", [opdic[queid] objectForKey:@"id"], @"option_id", nil]];
        }
    }
    NSMutableDictionary *exams = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:unitid], @"unit_id", @"2013-07-13T00:12:30+08:00", @"started_at", @"2013-07-13T00:12:40+08:00", @"stopped_at", postDic, @"answers_attributes", nil];
    
    NSMutableDictionary *finalDic = [NSMutableDictionary dictionaryWithObject:exams forKey:@"exam"];
    
    NSString *newjson = [finalDic JSONRepresentation];
    

    NSString *token=[[NSUserDefaults standardUserDefaults]  objectForKey:@"token"];
    
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/exams.json?auth_token=%@",token]];
    
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url2];
   
    req.tag = 60002;
    
    [req addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [req addRequestHeader:@"Content-Type" value:@"application/json"];
    [req appendPostData:[newjson dataUsingEncoding:NSUTF8StringEncoding]];
    [req setRequestMethod:@"POST"];
    [req setDelegate:self];
    [req startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)req
{
    [self clearUnuseful];
    
    NSData *jsonData = [req responseData];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
    
    if(req.tag == 60005) {
        [self readInfo:deserializedDictionary];
        [self loadInfo:deserializedDictionary];
        return;
    }
    v_score *vs = [[v_score alloc]initWithFrame:self.frame];
    [self.superview fadeInView:self withNewView:vs duration:.5];
    [vs loadCurrentPage:[[deserializedDictionary objectForKey:@"id"] integerValue]];
    [vs sendAnswer:postIDArr];
}

@end
