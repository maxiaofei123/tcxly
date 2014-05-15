//
//  v_unit.h
//  tcxly
//
//  Created by Terry on 13-5-5.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "iCarousel.h"


@protocol loadMapDelegate;

@interface v_unit : iPageView<UIAlertViewDelegate>

{
    UIView *mapv;
    UIScrollView *uv;
    
    UIImageView *curu, *vhand;
    
    NSMutableArray *larr;
    
    UIView *svv;
    
    float scalePos;
    
    NSArray *allArray, *gbArr;
    
    int curvtag;
    
    int pointnum;
    int unLock;
    
    UIButton *gy;
    
    UIButton *backButton, *userBtn,*mapvButoon;
    
    NSArray *stages;
    NSArray *units;
    int cirID;
    int qid ;
    id  idd;
    
    UIButton *curcir;
    
    
    int value2;
    
    
    UIAlertView *alert;
    ASIHTTPRequest *request;

}

-(void)loadInfo:(NSArray*)arr idx:(int)cmd;
-(void)addPointAni:(int)cid;

@property (nonatomic,strong) id<loadMapDelegate> delegate;


@end


//-----
@protocol loadMapDelegate <NSObject>

@optional
    -(void)onLoadMapFinish;
@end