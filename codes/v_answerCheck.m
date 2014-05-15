//
//  v_answerCheck.m
//  tcxly
//
//  Created by Terry on 13-9-8.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_answerCheck.h"
#import "UIView+iTextManager.h"
#import "MainViewController.h"

@implementation v_answerCheck

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addBackground:@"bg.jpg"];
        UIImageView *bgd = [self addImageView:self
                                        image:@"qp_wh.png"
                                     position:CGPointMake(0, 96)];
        
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:2000
                 target:self
                 action:@selector(backClick:)
         ];
        
        bgd.frame = CGRectMake(0, 96, 1024, 672);
        
        
    }
    return self;
}

-(void)sendAnswer:(NSArray *)arr {
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 96, 1024, 672)];
    [self addSubview:sv];
    
    MainViewController *mvc = (MainViewController*)[self getManager];
    
    question_line_items = [[NSArray alloc]init];
    question_line_items = mvc.allArr;
    
    for (int i = 0; i < [question_line_items count]; i ++) {
        //-----------------------------------------------------------------------------------
        UIView *txt = [[UIView alloc]initWithFrame:CGRectMake(0, 30 + i * 80 * 2, 1042, 42)];
        txt.tag = 2000 + i;
        [sv addSubview:txt];
        //[self addTapEvent:txt target:self action:@selector(txtClick:)];
        
        [self addImageView:txt
                     image:@"qp_line.png"
                  position:CGPointMake(0, 130)
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
        
        NSDictionary *questions = [[NSDictionary alloc]init];
        questions = [question_line_items[i] objectForKey:@"question"];
        
        UILabel *ques = [self addLabel:txt
                                 frame:CGRectMake(120, 0, 500, 24)
                                  font:[UIFont fontWithName:@"Arial" size:24]
                                  text:[questions objectForKey:@"subject"]
                                 color:[UIColor blackColor]
                                   tag:2999
                         ];
        [ques sizeToFit];
        ques.alpha = .5;
        ques.shadowOffset=CGSizeMake(0, 1);
        ques.shadowColor=[UIColor whiteColor];
        
        NSArray *abcd = @[@"A", @"B", @"C", @"D"];
        
        int trueid = 0;
        
        int lenv = [[questions objectForKey:@"single_choice_options"] count];
        for (int i = 0; i < lenv; i++) {
            if([[[questions objectForKey:@"single_choice_options"][i] objectForKey:@"correct"] integerValue] == 1) {
                trueid = i;
                break;
            }
        }
        int queid = [arr[i] integerValue];
     

        UILabel *qanswer;
        if(queid == trueid) {
           qanswer = [self addLabel:txt
                                        frame:CGRectMake(ques.frame.size.width + ques.frame.origin.x + 10, ques.frame.origin.y, 500, 24)
                                         font:[UIFont fontWithName:@"Arial" size:22]
                                         text:[NSString stringWithFormat:@"你的答案:  %@", abcd[queid]]
                                        color:[UIColor blackColor]
                                          tag:2999
                                ];
        }
        else if(queid == -1){
            qanswer = [self addLabel:txt
                               frame:CGRectMake(ques.frame.size.width + ques.frame.origin.x + 10, ques.frame.origin.y, 500, 24)
                                font:[UIFont fontWithName:@"Arial" size:22]
                                text:[NSString stringWithFormat:@"你的答案:  未填"]
                               color:[UIColor redColor]
                                 tag:2999
                       ];
            
            
        }
        else {
            qanswer = [self addLabel:txt
                                        frame:CGRectMake(ques.frame.size.width + ques.frame.origin.x + 10, ques.frame.origin.y, 500, 24)
                                         font:[UIFont fontWithName:@"Arial" size:22]
                                         text:[NSString stringWithFormat:@"你的答案:  %@          正确答案:  %@", queid == -1 ? @"未填" : abcd[queid], abcd[trueid]]
                                        color:[UIColor redColor]
                                          tag:2999
                                ];
        }
        qanswer.shadowOffset=CGSizeMake(0, 1);
        qanswer.shadowColor=[UIColor whiteColor];
        
        for (int j = 0; j < 4; j++) {
            [self addLabel:txt
                     frame:CGRectMake(ques.frame.origin.x + j * 120, ques.frame.origin.y + 80, 500, 24)
                      font:[UIFont fontWithName:@"Arial" size:22]
                      text:[NSString stringWithFormat:@"%@: %@", abcd[j], [[questions objectForKey:@"single_choice_options"][j] objectForKey:@"content"]]
                    color:(j == queid ? [UIColor blueColor] : [UIColor blackColor])
                       tag:2999
             ];
        }
        
        [sv setContentSize:CGSizeMake(1024, (i + 1) * 80 * 2)];
    }
}

-(void)backClick:(UIButton*)e {
    [self fadeOutView:self duration:.5];
}

-(void)loadCurrentPage:(int)cmd {
    
}

@end
