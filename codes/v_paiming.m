//
//  v_paiming.m
//  tcxly
//
//  Created by Li yi on 13-9-11.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_paiming.h"
#import "UIView+iTextManager.h"
#import "UIView+iAnimationManager.h"
#import "reg_0.h"
#import "MainViewController.h"

@implementation v_paiming

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
     
        
        p0=  [self addImageView:self
                          image:@"pm_ui.png"
                       position:CGPointMake(65, 80)];//73
        
        
        
        p1= [self addImageView:p0
                         image:@"pm_di.png"
                      position:CGPointMake(50, 145)];
        
     
         p1.frame = CGRectMake(50, 145, 745, 510);
        
        [self addButton:self
                  image:@"back.png"
               position:CGPointMake(30, 30)
                    tag:1003
                 target:self
                 action:@selector(backClick:)];
        
        UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(115, 225, 745, 510)];
        [self addSubview:sv];
        [sv setContentSize:CGSizeMake(745, 130*10)];

        NSArray * namr = @[@"王梅",@"蒋琴",@"董晓霜",@"王天丽",@"李明宇",@"张兰",@"乐乐",@"小明",@"艾希",@"马东",@"郭敬明"];
        
        NSArray * core = @[@"100",@"99.8",@"97.6",@"95",@"93",@"92.5",@"92",@"92",@"90",@"86",@"80"];
        
        for (int i=1; i<10; i++) {
            
//            id aid=[[rank objectAtIndex:i] objectForKey:@"avatar_id"];
            
            
            UIView *txt = [[UIView alloc]initWithFrame:CGRectMake(0,  i *130, 745, 130)];
            txt.tag = 2000 + i;
            [sv addSubview:txt];
            
            [self addImageView:txt
                         image:@"qp_line.png"
                      position:CGPointMake(0, 130)
             ];
            
            
            
            
//            if(aid && ![aid isKindOfClass:[NSNull class]])
//            {
//                im=[self addImageView:txt
//                                image:[NSString stringWithFormat:@"avatar_%@.jpg",aid]
//                             position:CGPointMake(20, 10)];
//            }
//            else
//            {
                im=[self addImageView:txt
                                image:[NSString stringWithFormat:@"avatar_%d.jpg",i]
                             position:CGPointMake(20, 10)];
//            }
            
            
            CGRect f=im.frame;
            f.size.width=f.size.height=110;
            im.frame=f;
            
            
            //名字
            UILabel *un=[self addLabel:txt
                                 frame:CGRectMake(161, 40, 180, 50)
                                  font:[UIFont boldSystemFontOfSize:20]
                                  text:[namr objectAtIndex:i]
                                 color:[UIColor blackColor]
                                   tag:0];
            
            un.textAlignment=UITextAlignmentCenter;
            
            
            
            //成绩
            un=[self addLabel:txt
                        frame:CGRectMake(317,  40, 100, 50)
                         font:[UIFont fontWithName:@"Gretoon" size:24]
                         text:[core objectAtIndex:i]
                        color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                          tag:0];
            
            un.textAlignment=UITextAlignmentCenter;
            
            
            
            
            //排名
            
            un = [self addLabel:txt
                          frame:CGRectMake(465, 40, 100, 50)
                           font:[UIFont fontWithName:@"Gretoon" size:24]
                           text:[NSString stringWithFormat:@"第%d名", i + 1]
                          color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                            tag:0];
            un.shadowOffset=CGSizeMake(0, 1);
            
            un.shadowColor=[UIColor whiteColor];
            
            un.textAlignment=UITextAlignmentCenter;
            
            
    
        }

        
    }
    return self;
}



- (void)requestFinished:(ASIHTTPRequest *)r
{
    
    NSLog(@"paiming requst%@",[r responseString]);
    
    NSData *jsonData = [r responseData];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *items=(NSDictionary*)jsonObject;
    
    NSArray *rank=(NSArray*)[items objectForKey:@"user_rankings"];
    NSLog(@"rank count%d",[rank count]);
   
    
    MainViewController *mvc = (MainViewController*)[self getManager];
    rank = mvc.allArr;
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(115, 225, 745, 510)];
    [self addSubview:sv];
    [sv setContentSize:CGSizeMake(745, 130*10)];
   // sv.showsHorizontalScrllIndicator = false;
    //sv.showsVerticalScrollIndicator = false;
    for (int i=0; i<10; i++) {
        
        id aid=[[rank objectAtIndex:i] objectForKey:@"avatar_id"];

       
        UIView *txt = [[UIView alloc]initWithFrame:CGRectMake(0,  i *130, 745, 130)];
        txt.tag = 2000 + i;
        [sv addSubview:txt];
        
        [self addImageView:txt
                     image:@"qp_line.png"
                  position:CGPointMake(0, 130)
         ];
        
        
        
        
        if(aid && ![aid isKindOfClass:[NSNull class]])
        {
            im=[self addImageView:txt
                            image:[NSString stringWithFormat:@"avatar_%@.jpg",aid]
                         position:CGPointMake(20, 10)];
        }
        else
        {
            im=[self addImageView:txt
                            image:@"avatar_1.jpg"
                         position:CGPointMake(20, 10)];
        }

        
        CGRect f=im.frame;
        f.size.width=f.size.height=110;
        im.frame=f;
        
        
        //名字
        UILabel *un=[self addLabel:txt
                             frame:CGRectMake(161, 115+i*130, 180, 50)
                              font:[UIFont boldSystemFontOfSize:20]
                              text:[[[rank objectAtIndex:i] objectForKey:@"user"] objectForKey:@"username"]
                             color:[UIColor blackColor]
                               tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        
        
        //成绩
        un=[self addLabel:txt
                    frame:CGRectMake(317,  40, 100, 50)
                     font:[UIFont fontWithName:@"Gretoon" size:24]
                     text:[NSString stringWithFormat:@"%d",[[[rank objectAtIndex:i] objectForKey:@"total_point"] integerValue]]
                    color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                      tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        
        
        
        //排名
        
        un = [self addLabel:txt
                       frame:CGRectMake(465, 40, 100, 50)
                        font:[UIFont fontWithName:@"Gretoon" size:24]
                        text:[NSString stringWithFormat:@"第%d名", i + 1]
                        color:[UIColor colorWithRed:85.f/255.f green:107.f/255.f blue:131.f/255.f alpha:1]
                        tag:0];
        un.shadowOffset=CGSizeMake(0, 1);
        
        un.shadowColor=[UIColor whiteColor];
  
        un.textAlignment=UITextAlignmentCenter;

        
    }
    
    
    
    NSDictionary *myself=[items objectForKey:@"current_user_ranking"];

    NSLog(@"myselfCount=%d",[myself count]);
    
    
    
    //第四名/
    /*
    if([myself count]>0)
    {
        
        id aid=[[myself objectForKey:@"user"] objectForKey:@"avatar_id"];
        
        UIImageView *im;
        
        
        if(aid && ![aid isKindOfClass:[NSNull class]])
        {
            im=[self addImageView:p1
                            image:[NSString stringWithFormat:@"avatar_%@.jpg",aid]
                         position:CGPointMake(40, 83)];
        }
        else
        {
            im=[self addImageView:p1
                            image:@"avatar_1.jpg"
                         position:CGPointMake(40, 83)];
        }
        
        CGRect f=im.frame;
        f.size.width=f.size.height=110;
        im.frame=f;
        
        
        //名字
        UILabel *un=[self addLabel:p1
                             frame:CGRectMake(161, 115, 180, 50)
                              font:[UIFont boldSystemFontOfSize:20]
                              text:[[myself objectForKey:@"user"] objectForKey:@"username"]
                             color:[UIColor blackColor]
                               tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        

        //成绩
        un=[self addLabel:p1
                    frame:CGRectMake(368, 115, 180, 50)
                     font:[UIFont boldSystemFontOfSize:20]
                     text:[NSString stringWithFormat:@"%d",[[myself objectForKey:@"total_point"] integerValue]]
                    color:[UIColor blackColor]
                      tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        

        //排名
        un=[self addLabel:p1
                    frame:CGRectMake(572, 115, 121, 50)
                     font:[UIFont boldSystemFontOfSize:20]
                     text: [NSString stringWithFormat:@"第%d名",[[myself objectForKey:@"ranking_no"] integerValue]]
                    color:[UIColor blackColor]
                      tag:0];
        
        
        un.textAlignment=UITextAlignmentCenter;
        
        [self addLabel:p1
                 frame:CGRectMake(582, 20, 260, 50)
                  font:[UIFont boldSystemFontOfSize:20]
                  text:[NSString stringWithFormat:@"在线学员：%d",[[myself objectForKey:@"users_count"] integerValue]]
                 color:[UIColor whiteColor]
                   tag:0];


        [UIView animateWithDuration:1
                         animations:^{
                            p1.center=[self LeftPointToCenter:CGPointMake(70, 550) view:p1];
                         }];
    }
    */
    
    
}



//请求回调 ---------------------------------------------------------------------------------------------------
- (void)requestFailed:(ASIHTTPRequest *)r
{
    NSError *error = [r error];
    NSLog(@"paiming:%@",error);
}


-(void)loadCurrentPage:(int)cmd
{

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *gid = [[NSUserDefaults standardUserDefaults] objectForKey:@"grade_id"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/ranks/ranking.json?auth_token=%@&grade_id=%@",token,gid]];
    
    NSLog(@"%@",url);
    
    
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
}

-(void)backClick:(UIButton*)sender
{
    [self fadeOutView:self
             duration:.5];
}


@end
