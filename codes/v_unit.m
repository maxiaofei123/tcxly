//
//  v_unit.m
//  tcxly
//
//  Created by Terry on 13-5-5.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_unit.h"
#import "v_qna.h"
#import "v_shop.h"
#import "UIView+iTextManager.h"
#import "UIImageView+WebCache.h"
#import "v_enter.h"
#import "profile.h"
#import "personal.h"

@implementation v_unit

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor blackColor];
        
        pointnum = 8;
        //
        mapv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2048, 1536)];
        mapv.center = CGPointMake(512, 384);
        mapv.transform = CGAffineTransformMakeScale(.5, .5);
        [self addSubview:mapv];
        
        
        svv = [[UIView alloc]initWithFrame:CGRectMake(0, -130, 1024, 134)];
        [self addSubview:svv];
        
        [self addImageView:svv
                     image:@"ut_black.png"
                  position:CGPointMake(0, 0)];
        
        uv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 134)];
        [uv setBounces:YES];
        [svv addSubview:uv];
        
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(pinchPiece:)];
        [self addGestureRecognizer:pinchGesture];
        
        
        userBtn = [self addButton:self
                            image:@"userSenterMenu.png"
                         position:CGPointMake(906, 30)
                              tag:1006
                           target:self
                           action:@selector(centerClick:)
                   ];
        
        backButton= [self addButton:self
                              image:@"back.png"
                           position:CGPointMake(30, 30)
                                tag:1004
                             target:self
                             action:@selector(backClick:)
                     ];
        
        
        vhand = [self addImageView:self image:@"ut_hand.png" position:CGPointMake(900, 660)];
        vhand.alpha = 0;
        
    }
    
    return self;
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            UITextField *textfield =  [alertView textFieldAtIndex: 0];
            
            int aa=[textfield.text intValue];
            
            
            if (value2==aa)
            {
                /*personal *p=[[personal alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
                 [p loadCurrentPage:0];
                 [self fadeInView:p duration:.5];*/
                
                
            }
            else
            {
                [alert show];
            }
            
        }
            break;
    }
    
    
    
}



-(void)centerClick:(UIButton*)e {
    
    NSLog(@"用户中心");
    
    /*
     int value0 = (arc4random() % 10) + 1;
     int value1 = (arc4random() % 10) + 1;
     value2 = value0*value1;
     
     
     
     alert = [[UIAlertView alloc] initWithTitle:@"家长确认！为避免孩子误操作，先回答下面的问题："
     message:[NSString stringWithFormat:@"%d X %d = ?",value0,value1]
     delegate:self
     cancelButtonTitle:@"cancel"
     otherButtonTitles:@"OK", nil];
     
     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
     UITextField *textField = [alert textFieldAtIndex:0];
     textField.keyboardType = UIKeyboardTypeNumberPad;
     [alert show];*/
    
    profile *p=[[profile alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [p loadCurrentPage:0];
    [self fadeInView:p duration:.5];
    
    
    
    
}

-(void)backClick:(UIButton*)e {
    
    //[self.superview fadeOutView:self duration:.5];
    v_enter *ve = [[v_enter alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
                   withNewView:ve
                      duration:.5
     ];
    
}


-(void)gyClick:(UIButton*)e {
    
    
    v_shop *vp = [[v_shop alloc] initWithFrame:self.frame];
    [self fadeInView:vp duration:.5];
    NSString *state = [stages[curcir.tag - 2000] objectForKey:@"purchase_state"];
    [vp loadInfo:stages vid:cirID];
    [vp loadCurrentPage:[state isEqualToString:@"paid"] ? 0 : 1];
}

//放大缩小
- (void)pinchPiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ) {
		scalePos=gestureRecognizer.scale;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
	{
		//NSLog(@"%f,%f",scalePos,gestureRecognizer.scale);
		
		if(scalePos>gestureRecognizer.scale)
        {
            
            if (mapv.frame.size.width>1024) {
                [self clearPoint:-1];
                [UIView animateWithDuration:.5
                                 animations:^{
                                     mapv.transform = CGAffineTransformMakeScale(.5, .5);
                                     mapv.center = CGPointMake(512, 384);
                                 }];
                [UIView animateWithDuration:.5 animations:^{
                    svv.frame = CGRectMake(0, -130, 1024, 134);
                    svv.alpha = 0;
                    backButton.alpha = 1;
                    userBtn.alpha = 1;
                    gy.alpha = 0;
                    vhand.alpha = 0;
                    
                }];
                
                
            }
            
            else
            {
                [self.superview fadeOutView:self duration:.5];
            }
            
            
            curcir = nil;
            
        }
	}
}

-(void)setcurunit:(int)i {//找到图片以后就把一个固定的图片移过去
    curvtag = i;
    UIImageView *ut = (UIImageView*)[self viewWithTag:1000 + i];
    UIImageView *board = (UIImageView*)[self viewWithTag:8787];
    board.center = ut.center;
    board.alpha = 1;
}
//选择试卷
-(void)utClick:(UIGestureRecognizer*)e {
    
    [self setcurunit:e.view.tag - 1000];
}

-(void)lrClick:(UIButton*)e {
    
}

-(void)boardClick:(UIGestureRecognizer*)e {
    NSString *unlock = [units[curvtag] objectForKey:@"lock_state"];
    //NSLog(@"unlock .... =%@",unlock);
    
    // if(![unlock isEqualToString:@"lock"]){
    v_qna *vq = [[v_qna alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    
    NSArray *unArr = [stages[cirID] objectForKey:@"units"];
    
    int unitid = [[unArr[curvtag] objectForKey:@"id"] integerValue];
    
    [vq loadCurrentPage:unitid];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", unitid] forKey:@"unitid"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", curvtag] forKey:@"menutag"];
    /* [self.superview fadeInView:self
     withNewView:vq
     duration:.5];*/
    
    [self fadeInView:vq duration:.5];
    
    
    /*  }
     else{
     
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
     message:@"此试题还未解锁！"
     delegate:self
     cancelButtonTitle:@"确定"
     otherButtonTitles:nil];
     [alertView show];
     
     }*/
    
}

-(void)loadInfo:(NSArray*)arr idx:(int)cmd {
    
    
    stages = [arr[cmd] objectForKey:@"stages"];
    
    
    int mapcount = [[arr[cmd] objectForKey:@"pictures"] count];
    
    NSString *imgurl = @"";
    if(mapcount > 0) {
        imgurl = [[arr[cmd] objectForKey:@"pictures"][mapcount - 1] objectForKey:@"image_url"];
    }
    if(imgurl) {
        
        //NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgurl]];
        //UIImage *image=[[UIImage alloc] initWithData:imageData];
        
        UIImageView *imgview = [self addImageView:mapv
                                            image:@"ut_wait.png"
                                         position:CGPointMake(0, 0)];
        
        
        imgview.alpha=0;
        
        
        [imgview setImageWithURL:[NSURL URLWithString:imgurl]
                placeholderImage:nil
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           
                           [UIView animateWithDuration:.5
                                            animations:^{
                                                imgview.alpha=1;
                                                
                                                //[delegate onLoadMapFinish];
                                                
                                                
                                            }];
                       }];
    }
    //地图
    for (int i = 0; i < [stages count]; i++) {
        NSArray *pos=[stages[i] objectForKey:@"map_places"];
        
        if(pos.count==0){
            
        }
        else{
            
            CGPoint p =CGPointMake([[pos[0] objectForKey:@"x"] integerValue],[[pos[0] objectForKey:@"y"] integerValue]);
            // NSLog(@"x=%f     y=%f", p.x, p.y);
            NSString *state = [stages[i] objectForKey:@"purchase_state"];
            //测试
            //        if(i > 2) state = @"unpaid";
            NSLog(@"state == > %@", state);
            
            //显示阶段
            UIButton *cir = [self addButton:mapv
                                      image:[NSString stringWithFormat:@"ut_cir%d.png", [state isEqualToString:@"paid"] ? i : 100]//条件选择100是灰色
                                   position:CGPointMake(p.x * 2, p.y * 2)
                                        tag:2000 + i
                                     target:self
                                     action:@selector(cirClick:)
                             ];
            NSString *cirname = [NSString stringWithFormat:@"%d", [[stages[i] objectForKey:@"position"] isKindOfClass:[NSNull class]] ? 0 : [[stages[i] objectForKey:@"position"] integerValue]];
            
            
            UILabel *txt = [self addLabel:cir
                                    frame:CGRectMake(0, 0, cir.frame.size.width, cir.frame.size.height)
                                     font:[UIFont fontWithName:@"Gretoon" size:32]
                                     text:cirname
                                    color:[UIColor blackColor]
                                      tag:2100 + i
                            ];
            //        txt.alpha = .5;
            
            txt.textAlignment = UITextAlignmentCenter;
            cir.alpha = 0;
            cir.transform = CGAffineTransformMakeScale(0.01, 0.01);
            /*
             //加锁
             if([state isEqualToString:@"unpaid"]) {
             
             [self addImageView:cir
             image:@"ut_rock.png"
             position:CGPointMake(0, 0)
             ];
             }
             */
            //动画效果
            [UIView animateWithDuration:.5
                                  delay:i * .2
                                options:UIViewAnimationOptionAllowAnimatedContent
                             animations:^{
                                 cir.alpha = 1;
                                 cir.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 if([state isEqualToString:@"paid"]) [self showCir:cir];
                             }];
            
            
            UIView *scir = [[UIView alloc] initWithFrame:self.frame];
            scir.userInteractionEnabled = NO;
            scir.tag = 66666;
            [mapv addSubview:scir];
        }
    }
    
    //训练概要......gyclick
    gy = [self addButton:mapv
                   image:@"ut_gaiyao.png"
                position:CGPointMake(0, 0)
                     tag:78978
                  target:self
                  action:@selector(gyClick:)
          ];
    gy.alpha = 0;
    
    mapvButoon=[self addButton:self
                         image:@"back.png"
                      position:CGPointMake(30, 30)
                           tag:1000
                        target:self
                        action:@selector(backClick:)];
    
    
    
}


-(void)cirClick:(UIButton*)e {
    
    if(curcir.tag == e.tag) return;
    curcir = e;
    
    
    qid = curcir.tag - 2000;
    
    for(UIView *sview in uv.subviews) {
        [sview removeFromSuperview];
    }
    UIView *cirv = [self viewWithTag:66666];
    for(UIView *scir in cirv.subviews) {
        [scir removeFromSuperview];
    }
    
    svv.frame = CGRectMake(0, -130, 1024, 134);
    svv.alpha = 0;
    
    backButton.alpha=0;
    userBtn.alpha = 0;
    
    CGPoint pp;
    int px = self.frame.size.width * 1.5 - e.center.x;
    int py = self.frame.size.height * 1.5 - e.center.y;
    pp.x = px > 1024 ? 1024 : px < 0 ? 0 : px;
    pp.y = py > 768 ? 768 : py < 0 ? 0 : py;
    
    //NSLog(@"%f---%f", pp.x, pp.y);
    gy.alpha = 0;
    
    //small point
    NSMutableArray *sparr = [stages[qid] objectForKey:@"units"];
    idd=[stages[qid] objectForKey:@"id"];
    NSLog(@"idd=%@",idd);
    
    for (int j = 0; j < [sparr count]; j++) {
        NSMutableArray *mplace = [sparr[j] objectForKey:@"map_places"];
        
        if([mplace count] > 0) {
            
            UIImageView *smcir = [self addImageView:cirv
                                              image:[NSString stringWithFormat:@"ut_asd%d.png", qid]
                                           position:CGPointMake([[mplace[0] objectForKey:@"x"] integerValue] * 2, [[mplace[0] objectForKey:@"y"] integerValue] * 2)
                                  ];
            //NSLog(@"******%d", [[mplace[0] objectForKey:@"x"] integerValue]);
            smcir.alpha = 0;
            smcir.transform = CGAffineTransformMakeScale(.1, .1);
            
            [UIView animateWithDuration:.5
                                  delay:j * .2 + 1
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 smcir.alpha = 1;
                                 smcir.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 
                             }];
            
        }
    }
    //动画效果
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         mapv.transform = CGAffineTransformMakeScale(1, 1);
                         mapv.center = pp;
                         vhand.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self addPointAni:e.tag - 2001];
                         gy.center = CGPointMake(e.center.x, e.center.y + 150);
                         [UIView animateWithDuration:.5
                                          animations:^{
                                              gy.center = CGPointMake(gy.center.x, gy.center.y - 20);
                                              gy.alpha = 1;
                                          }
                          ];
                     }];
    [self unitsRequest];
    
    
}

-(void)addPointAni:(int)cid {
    
    [self clearPoint:cid];
    
    int allnum = [[stages[cid + 1] objectForKey:@"units"] count];
    
    
    for(UIView *sview in uv.subviews) {
        [sview removeFromSuperview];
    }
    cirID = cid + 1;
    
    uv.contentSize = CGSizeMake(170 * allnum+100, 134);
    
    svv.alpha = 0;
    
    //显示卷子信息
    
    for (int i = 0; i < allnum; i++) {
        UIImageView *unitbtn = [self addButtonWithImageView:uv
                                                      image:@"ut_cls1.png"
                                                  highlight:nil
                                                   position:CGPointMake(140 + i * 170, 13)
                                                          t:1000 + i
                                                     action:@selector(utClick:)
                                ];
        //添加锁
        
        /*
         if(i<[units count]){
         NSString *unlock = [units[i] objectForKey:@"lock_state"];
         
         NSLog(@"unlock =%@",unlock);
         
         if([unlock isEqualToString:@"lock"]){
         [self addButtonWithImageView:unitbtn
         image:@"ut_rock.png"
         highlight:nil
         position:CGPointMake(30, 20)//CGPointMake( 7 + j * 170,35)
         t:1001
         action:@selector(rockClick:)];
         
         }
         
         }*/
        
        NSArray *unArr = [stages[cid + 1] objectForKey:@"units"];
        UILabel *utname = [self addLabel:unitbtn
                                   frame:CGRectMake(0, 15, 158, 20)
                                    font:[UIFont systemFontOfSize:14]
                                    text:[NSString stringWithFormat:@"%@", [unArr[i] objectForKey:@"name"]]
                                   color:[UIColor blackColor]
                                     tag:878722
                           ];
        
        utname.textAlignment = UITextAlignmentCenter;
        
    }
    
    UIImageView *boards = [self addButtonWithImageView:uv
                                                 image:@"ut_board.png"
                                             highlight:nil
                                              position:CGPointMake(0, 0)
                                                     t:8787
                                                action:@selector(boardClick:)
                           ];
    
    boards.alpha = 0;
    [self setcurunit:0];
    
    
    NSString *pstr = [stages[cirID] objectForKey:@"purchase_state"];
    //  NSLog(@"%d", [[stages[cirID] objectForKey:@"id"] integerValue]);
    
    if([pstr isEqualToString:@"paid"]) {
        [UIView animateWithDuration:.3 animations:^{
            svv.frame = CGRectMake(0, 9, 1024, 134);
            svv.alpha = 1;
        }];
    }
    
    
}

-(void)unitsRequest{
    NSLog(@"unit request");
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/stages/%@?auth_token=%@",idd,token]];
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
}


- (void)requestFailed:(ASIHTTPRequest *)req
{
    NSError *error = [req error];
    NSLog(@"unit error:%@",error);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络无法连接, 请检查网络并重试."
                                                       delegate:self
                                              cancelButtonTitle:@"重试"
                                              otherButtonTitles:@"好", nil];
    [alertView show];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSData *jsonData = [request responseData];
    
    //解析JSon
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
     NSLog(@"Successfully deserialized  request =%@",jsonObject);
    
    
    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
    
    if(![deserializedDictionary isKindOfClass:[NSNull class]] )
    {
        
        allArray = (NSArray*)deserializedDictionary;
        
    }
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
    
    units = [Dic objectForKey:@"units"];
    
    int count = [units count];
    
    
}



-(void)rockClick:(UIButton *)number
{
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"此试题还未解锁！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
    
}

-(void)clearPoint:(int)cid {
    for (int i = 0; i < 10; i++) {
        UIImageView *cc = (UIImageView*)[self viewWithTag:80000 + i];
        [cc removeFromSuperview];
    }
    
    for (int j = 0; j < pointnum; j++) {
        UIButton *cp = (UIButton*)[self viewWithTag:2000 + j];
        UIImageView *simg = (UIImageView*)[self viewWithTag:cp.tag + 777];
        
        if(cid == -1) {
            cp.alpha = 1;
            [simg.layer setHidden:NO];
        }else {
            if(j == cid + 1) {
                cp.alpha = 1;
                [simg.layer setHidden:NO];
            }else {
                cp.alpha = 1;
                [simg.layer setHidden:YES];
            }
        }
    }
}

-(void)showCir:(UIButton*)cir {
    UIImageView *simg = [self setShadowAnimtion:cir Image:@"ut_cirw2.png" time:.5];
    simg.tag = cir.tag + 777;
}

@end
