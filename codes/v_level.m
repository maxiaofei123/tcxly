//
//  v_level.m
//  tcxly
//
//  Created by Terry on 13-5-4.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_level.h"
#import "v_score.h"
#import "MainViewController.h"
#import "v_enter.h"
#import "UIView+iTextManager.h"

#define NUMBER_OF_ITEMS 19
#define NUMBER_OF_VISIBLE_ITEMS 19
#define INCLUDE_PLACEHOLDERS YES
#define ITEM_SPACING 220

@implementation v_level

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"lv_black.png"];
        
//        [self readInfo];

        [self showInfo];
        
//        for(int i =2;i<6;i++){
//                UIButton *bt ;
//                UIImage *btBg=[UIImage imageNamed:[NSString stringWithFormat:@"lv-000%d.png",i-1]];
//                NSLog(@"i=%d",i);
//                bt=[UIButton buttonWithType: UIButtonTypeCustom];
//                bt.frame=CGRectMake(0,0,btBg.size.width,btBg.size.height);
//                [bt setBackgroundImage:btBg forState:UIControlStateNormal];
//                bt.tag = 8000 + index;
//                
//                //添加事件
//                [bt addTarget:self action:@selector(onMenuDown:)
//             forControlEvents:UIControlEventTouchUpInside];
//            
//            [self addButton:self
//                      image:[NSString stringWithFormat:@"lv-000%d.png",i-1]
//                   position:CGPointMake(0,0)
//                        tag:1000
//                     target:self
//                     action:@selector(onDown:)];
//            }
//        
    }
    return self;
}

-(void)clearSelf {
    [request clearDelegatesAndCancel];
    [self removeFromSuperview];
}

-(void)readInfo {
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/grades.json?auth_token=%@",token]];

    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
    UIActivityIndicatorView *loginLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [loginLoading setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height/2)];
    loginLoading.tag = 9991;
    [self addSubview:loginLoading];
    [loginLoading startAnimating];
    
    UILabel *txt = [self addLabel:self
                            frame:CGRectMake(0, 0, 200, 100)
                             font:[UIFont systemFontOfSize:18]
                             text:@"加载中..."
                            color:[UIColor whiteColor]
                              tag:9992
                    ];
    txt.shadowColor = [UIColor blackColor];
    txt.textAlignment = UITextAlignmentCenter;
    txt.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2 + 50);
}

-(void)showInfo {
    
    items = [NSMutableArray array];

    for (int i = 0; i < 5; i++)
    {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    
    carousel = [[iCarousel alloc] initWithFrame:self.frame];
    
    carousel.center=CGPointMake(512, 164);
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeRotary;
    carousel.delegate = self;
    carousel.dataSource = self;
    
    [self addSubview:carousel];
    
    [self startAnimation:carousel
                    sPos:carousel.center
                    ePos:carousel.center
                  sAlpha:0
                  eAlpha:1
                  sScale:CGPointMake(.8,.8)
                  eScale:CGPointMake(1, 1)
                duration:.5
                   delay:0
                  option:UIViewAnimationOptionAllowAnimatedContent
     ];
    
    UIButton *m1 = [self addButton:self
                             image:@"lv_m1.png"
                          position:CGPointMake(7, 89)
                               tag:4001
                            target:self
                            action:@selector(leftRightClick:)
                    ];
    UIButton *m2 = [self addButton:self
                             image:@"lv_m2.png"
                          position:CGPointMake(955, 89)
                               tag:4001
                            target:self
                            action:@selector(leftRightClick:)
                    ];
    
    m1.alpha = m2.alpha = 0;
    
//    [carousel addSubview:m1];
//    [carousel addSubview:m2];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [request clearDelegatesAndCancel];
        request = nil;
        [self fadeOutView:self duration:0];
        v_enter *ve = (v_enter*)(self.superview);
        [ve showMenu];
    }else {
        [self readInfo];
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)r
{
    
    [self clearUnuseful];
    
    NSData *jsonData = [r responseData];
    
    //解析JSon
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"Successfully deserialized  request =%@",[r responseString]);
    
    
    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
    
    if(![deserializedDictionary isKindOfClass:[NSNull class]] )
    {
        
        allArray = (NSArray*)deserializedDictionary;
        MainViewController *mvc = (MainViewController*)[self getManager];
        mvc.unitArr = allArray;
        
        num = [allArray count];
        
        [self showInfo];
    }
}

-(void)leftRightClick:(UIButton*)e {
    
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UIButton *bt = (UIButton *)view;
	//create new view if no view is available for recycling
    //显示幼儿园小班大班
    for(int i =2;i<6;i++){
        if (view == nil)
        {
            UIImage *btBg=[UIImage imageNamed:[NSString stringWithFormat:@"lv-000%d.png",i-1]];
           
            bt=[UIButton buttonWithType: UIButtonTypeCustom];
            bt.frame=CGRectMake(0,0,btBg.size.width,btBg.size.height);
            [bt setImage:btBg forState:UIControlStateNormal];
            bt.tag = 8000 + index;
        
            UILabel *ub = [self addLabel:bt
                                frame:CGRectMake(0, 47, 438, 27)
                                font:[UIFont systemFontOfSize:30]
                                text:@"kkkkkk"
                               color:[UIColor blackColor]
                                 tag:7878
                       ];
            
             ub.textAlignment = UITextAlignmentCenter;
       
            //添加事件
            [bt addTarget:self action:@selector(onMenuDown:)
            forControlEvents:UIControlEventTouchUpInside];
        }
	}
	return bt;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
   
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionArc:
        {
            return M_PI * num * .2;
        }
        case iCarouselOptionRadius:
        {
            return value * 1.8;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.0f;
        }
        default:
        {
            return value;
        }
    }
    
}


-(void)onMenuDown:(UIButton*)sender
{
    NSInteger index = [carousel indexOfItemView:sender];
   // NSLog(@"grade_id = %d",sender.tag - 8000);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)index]
                                              forKey:@"menuid"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", sender.tag - 8000]
                                              forKey:@"grade_id"];
    
    v_unit *vs = [[v_unit alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    vs.delegate=self;
    
    [vs loadInfo:allArray idx:index];
    
    
    [self.superview.superview fadeInView:vs
                                duration:.5
     ];
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
	return 0;
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return YES;
}


@end
