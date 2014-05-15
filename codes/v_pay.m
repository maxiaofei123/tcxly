//
//  v_pay.m
//  tcxly
//
//  Created by Terry on 13-8-17.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "v_pay.h"
#import "v_shop.h"

@implementation v_pay

#define NUMBER_OF_ITEMS 19
#define NUMBER_OF_VISIBLE_ITEMS 19
#define INCLUDE_PLACEHOLDERS YES
#define ITEM_SPACING 220

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addBackground:@"pay_bg.jpg"];
        
    }
    return self;
}

-(void)backClick:(UIButton*)e {
    v_shop *vs = [[v_shop alloc] initWithFrame:self.frame];
    [self.superview fadeInView:self withNewView:vs duration:0];
    [vs loadCurrentPage:0];
    [vs loadInfo:varr vid:_vid];
}

-(void)loadCurrentPage:(int)cmd {
    [self showInfo];
}

-(void)showInfo {
    
    items = [NSMutableArray array];
    num = 6;
    for (int i = 0; i < num; i++)
    {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    
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
                   delay:0
                  option:UIViewAnimationOptionAllowAnimatedContent
     ];
    
    [self addButton:self
              image:@"qq_back.png"
           position:CGPointMake(30, 30)
                tag:8888
             target:self
             action:@selector(backClick:)
     ];
}

-(void)saveInfo:(NSArray *)arr vid:(int)v{
    varr = arr;
    _vid = v;
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
	if (view == nil)
	{
        UIImage *btBg=[UIImage imageNamed:[NSString stringWithFormat:@"pay_btn%d.png",1]];
        
        bt=[UIButton buttonWithType: UIButtonTypeCustom];
        bt.frame=CGRectMake(0,0,btBg.size.width,btBg.size.height);
        [bt setBackgroundImage:btBg forState:UIControlStateNormal];
        
//        UILabel *ub = [self addLabel:bt
//                               frame:CGRectMake(0, 47, 438, 27)
//                                font:[UIFont systemFontOfSize:30]
//                                text:[NSString stringWithFormat:@"%@", [allArray[index] objectForKey:@"name"]]
//                               color:[UIColor blackColor]
//                                 tag:999888
//                       ];
//        
//        ub.textAlignment = UITextAlignmentCenter;
        
        //添加事件
        [bt addTarget:self action:@selector(onMenuDown:)
     forControlEvents:UIControlEventTouchUpInside];
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
            return value * 1.2;
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
    NSLog(@"%d",index);
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
