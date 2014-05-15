                  //
//  v_switch.m
//  tcxly
//
//  Created by Li yi on 13-9-22.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_switch.h"
#import "UIView+iTextManager.h"
#import "iCarousel.h"
#import "registChooseSex.h"
#import "v_enter.h"

@implementation v_switch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"bg.png"];
        
        
        items = [NSMutableArray array];
        
        
        [items addObject:@"new"];
        
        
        
        id aa = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountArray"];
        
        if(aa && ![aa isKindOfClass:[NSNull class]])
        {
            [items addObjectsFromArray:aa];
        }
        
        
        NSLog(@"%@",items);
        
    }
    return self;
}




-(void)onDown:(UIButton*)sender
{

    //new user
    if(sender.tag==1000)
    {
        
        registChooseSex *p=[[registChooseSex alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
     
        
        [self.superview.superview fadeInView:self.superview
                                 withNewView:p
                                    duration:.5];
        
        return;
    }
    
    
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[NSString stringWithFormat:@"%@ 欢迎回来继续学习!",[[items objectAtIndex:sender.tag-1000] objectForKey:@"name"]]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
    NSLog(@"%@",[[items objectAtIndex:sender.tag-1000] objectForKey:@"token"]);

    [[NSUserDefaults standardUserDefaults] setObject:[[items objectAtIndex:sender.tag-1000] objectForKey:@"token"]
                                              forKey:@"token"];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [((v_enter*)self.superview.superview) showList];
    [self fadeOutView:self.superview duration:.5];
}



-(void)backClick:(UIButton*)sender
{
    [self fadeOutView:self
             duration:.5];
}



-(void)loadCurrentPage:(int)cmd
{
    
    carousel = [[iCarousel alloc] initWithFrame:self.frame];
    
    carousel.center=CGPointMake(512, 384);
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
                   delay:.5
                  option:UIViewAnimationCurveEaseInOut];
    
    
    [self addButton:self
              image:@"qq_back.png"
           position:CGPointMake(30, 30)
                tag:1003
             target:self
             action:@selector(backClick:)];
    
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
    return 19;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    view=nil;
	//create new view if no view is available for recycling

    
    NSString *avatar=[NSString stringWithFormat:@"avatar_%@.jpg",index==0?@"new":[[items objectAtIndex:index] objectForKey:@"avatar"]];
    
    NSLog(@"%@",avatar);
    
    
    view= [self addButton:nil
              image:avatar
           position:CGPointMake(0, 0)
                tag:1000+index
             target:self
             action:@selector(onDown:)];
    
    if(index!=0)
    {
        UILabel *tt= [self addLabel:view
                              frame:CGRectMake(0, 0, 187, 50)
                               font:[UIFont boldSystemFontOfSize:18]
                               text:[[items objectAtIndex:index] objectForKey:@"name"]
                              color:[UIColor blackColor]
                                tag:0];
        
        tt.textAlignment=UITextAlignmentCenter;
        tt.center=CGPointMake(view.frame.size.width/2, 200);
    }

    
	return view;
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
            return M_PI * 1 * .2;
        }
        case iCarouselOptionRadius:
        {
            return value * 1.8;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.0f;
        }
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 3;
        default:
        {
            return value;
        }
    }
    
    
}


- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
	return 0;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return 130;
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
