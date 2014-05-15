//
//  reg_1.m
//  tcxly
//
//  Created by Li yi on 14-2-18.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "reg_1.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
#import "reg_0.h"
#import "userLogin.h"
#import "uploadPhoto.h"
#import "v_enter.h"

extern const  NSString *classNO;
extern const NSString *avatarR;
@implementation reg_1

- (id)initWithFrame:(CGRect)frame
{
   
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
        
        
        im = [self addImageView:self
                          image:@"reg_new_1.png"
                       position:CGPointMake(182, 46)];
        
       //头像
        
        id av= [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
        id flag= [[NSUserDefaults standardUserDefaults]objectForKey:@"flag"];
        
        if([flag isEqualToString:@"1"]){
            avatar = [self addImageView:im image:@"avatar_null.jpg" position:CGPointMake(237, 75)];
            id imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"URL"];
            NSLog(@"profile url =%@",imageUrl);
            [avatar setImageWithURL:imageUrl ];
           
            
        }else{
               avatar= [self addImageView:im
                             image:[NSString stringWithFormat:@"avatar_%@.jpg",av]
                          position:CGPointMake(237, 75)];
                    
        }
    
        NSString * no= [[NSUserDefaults standardUserDefaults]objectForKey:@"class_no"];
        [self addLabel:im
                 frame:CGRectMake(278, 375, 200, 30)
                  font:[UIFont systemFontOfSize:25]
                  text:no
                color:[UIColor redColor]
                   tag:1101];
        
        
        [self addImageView:self
                     image:@"reg_new_2.png"
                  position:CGPointMake(290, 604)];
        
        [self addButton:self
                  image:@"reg_new_bt.png"
               position:CGPointMake(437, 528)
                    tag:1001
                 target:self
                 action:@selector(onDown:)];
        

        
    }
   
    return self;
}

-(void)backClick:(UIButton*)e
{
    v_enter *ve = [[v_enter alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
                   withNewView:ve
                      duration:.5
     ];
}

-(void)showList {
    v_enter *ve = [[v_enter alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.superview fadeInView:self
                   withNewView:ve
                      duration:.5
     ];
    
}

-(void)onDown:(UIButton*)sender
{
    
    NSLog(@"userlogin alertView V_enter...");
 
    [self showList];
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
    
    NSLog(@"%@",items);
    
    
    un.text=[items objectForKey:@"username"];
    
}


@end
