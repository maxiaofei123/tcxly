//
//  v_qup.m
//  tcxly
//
//  Created by Terry on 13-5-6.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_qup.h"
#import "v_qna.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIView+iTextManager.h"

@implementation v_qup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addImageView:self
                     image:@"qp_upbg2.png"
                  position:CGPointMake(0, 0)];
        
        [self addImageView:self
                     image:@"qp_wh.png"
                  position:CGPointMake(0, 153)];
        
        uv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 9, 1024, 134)];
        [self addSubview:uv];
        
        
        sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 153, 1024, 615)];
        [self addSubview:sv];
    }
    return self;
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

-(void)loadInfo:(NSArray *)arr menuIndex:(int)mid {
    
    int allnum = [arr count];
    uv.contentSize = CGSizeMake(allnum * 170, 134);
    
    for (int i = 0; i < allnum; i++) {
        UIImageView *unitbtn = [self addButtonWithImageView:uv
                               image:@"ut_cls1.png"
                           highlight:nil
                            position:CGPointMake(7 + i * 170, 13)
                                   t:1000 + i
                              action:@selector(utClick:)
         ];
        
        UILabel *utname = [self addLabel:unitbtn
                                   frame:CGRectMake(0, 15, 158, 20)
                                    font:[UIFont systemFontOfSize:14]
                                    text:[NSString stringWithFormat:@"%@", [arr[i] objectForKey:@"name"]]
                                   color:[UIColor blackColor]
                                     tag:878722
                           ];
        
        utname.textAlignment = UITextAlignmentCenter;
    }
    UIImageView *board = [self addImageView:uv image:@"ut_board.png" position:CGPointMake(0, 0) tag:8787];
    board.alpha = 0;
    
    [self setcurunit:mid];
    
    NSArray *question_groups = [[NSArray alloc]init];
    question_groups = [arr[mid] objectForKey:@"question_groups"];
    
    NSLog(@"%@", question_groups);
    
    question_line_items = [[NSArray alloc]init];
    question_line_items = [question_groups[0] objectForKey:@"question_line_items"];
    
    NSLog(@"question number = %d", [question_line_items count]);
    
    NSLog(@"%@", question_groups);
    
    //        return;
    
    for (int i = 0; i < [question_line_items count]; i ++) {
        
        UIView *txt = [[UIView alloc]initWithFrame:CGRectMake(0, 16 + i * 62, 1042, 42)];
        txt.tag = 2000 + i;
        [sv addSubview:txt];
        [self addTapEvent:txt target:self action:@selector(txtClick:)];
        
        [self addImageView:txt
                     image:@"qp_line.png"
                  position:CGPointMake(0, 40)
         ];
        
        UILabel *tum = [self addLabel:txt
                                frame:CGRectMake(15, 0, 40, 24)
                                 font:[UIFont fontWithName:@"Arial" size:22]
                                 text:[NSString stringWithFormat:@"%d :", i + 1]
                                color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                                  tag:12001
                        ];
        tum.shadowOffset=CGSizeMake(0, 1);
        tum.shadowColor=[UIColor whiteColor];
        tum.textAlignment = NSTextAlignmentCenter;
        
        NSDictionary *questions = [[NSDictionary alloc]init];
        questions = [question_line_items[i] objectForKey:@"question"];
        
        UILabel *ques = [self addLabel:txt
                                 frame:CGRectMake(70, 5, 500, 16)
                                  font:[UIFont fontWithName:@"Calibri" size:10]
                                  text:[questions objectForKey:@"subject"]
                                 color:[UIColor blackColor]
                                   tag:12002
                         ];
        ques.shadowOffset=CGSizeMake(0, 1);
        ques.shadowColor=[UIColor whiteColor];
        
        [sv setContentSize:CGSizeMake(1024, (i + 1) * 62)];
    }
}

-(void)txtClick:(UIGestureRecognizer*)e {
    v_qna *vq = [[v_qna alloc]initWithFrame:self.frame];
    [self fadeInView:vq duration:.5];
    [vq readInfo:question_line_items questionID:e.view.tag - 2000];
}

@end
