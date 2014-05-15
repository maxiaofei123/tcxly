//
//  personal.m
//  tcxly
//
//  Created by Li yi on 13-9-25.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "personal.h"
#import "UIView+iTextManager.h"
#import "profile.h"
#import "v_paiming.h"
#import "profile.h"

@implementation personal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"et_bg.png"];
        

        [self addButton:self
                  image:@"qq_back.png"
               position:CGPointMake(30, 30)
                    tag:1003
                 target:self
                 action:@selector(backClick:)];

        id av= [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
     
            avatar= [self addImageView:self
                             image:[NSString stringWithFormat:@"avatar_%@.jpg",av]
                          position:CGPointMake(200, 110)];
        
        UIImageView *p0=  [self addImageView:self
                                       image:@"profile_0.jpg"
                                    position:CGPointMake(200, 320)];
        
        [self addButton:self
                  image:@"profile_bt0.png"
               position:CGPointMake(510, 106)
                    tag:1000
                 target:self
                 action:@selector(onDown:)];
        
        
        [self addButton:self
                  image:@"profile_bt1.png"
               position:CGPointMake(510, 293)
                    tag:1001
                 target:self
                 action:@selector(onDown:)];
        
        
        un= [self addLabel:p0
                     frame:CGRectMake(0, 0, 187, 60)
                      font:[UIFont boldSystemFontOfSize:18]
                      text:@"akldsjflsldfj"
                     color:[UIColor blackColor]
                       tag:0];
        
        un.textAlignment=UITextAlignmentCenter;
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(pinchPiece:)];
        [self addGestureRecognizer:pinchGesture];

    }
    return self;
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
            
            [self fadeOutView:self duration:.5];
            
        }
	}
}


-(void)onDown:(UIButton*)sender
{
    switch (sender.tag) {
        case 1000:
        {
            profile *p=[[profile alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [p loadP:items];
            [self fadeInView:p duration:.5];
        }
            break;
            
        case 1001:
        {
            v_paiming *p=[[v_paiming alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            [p loadCurrentPage:0];
            [self fadeInView:p duration:.5];
        }
            break;
    }
}


-(void)backClick:(UIButton*)sender
{
    [self fadeOutView:self duration:.5];
}


-(void)updateInfo
{
    [self loadCurrentPage:0];
}


-(void)updateAvatar
{
    id av= [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    avatar.image=[UIImage imageNamed:[NSString stringWithFormat:@"avatar_%@.jpg",av]];
}

-(void)loadCurrentPage:(int)cmd
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gifted-center.com/api/profiles.json?auth_token=%@",token]];
    
    NSLog(@"%@",url);
    
    request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    request.timeOutSeconds=60;
    [request startAsynchronous];
    
}


- (void)requestFinished:(ASIHTTPRequest *)r
{
    NSLog(@"%@",[r responseString]);
    
    NSData *jsonData = [r responseData];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    items=(NSDictionary*)jsonObject;
    
    NSLog(@"items=%@",items);
    
    
    un.text=[items objectForKey:@"username"];

    
}

@end
