//
//  v_pay.h
//  tcxly
//
//  Created by Terry on 13-8-17.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "iCarousel.h"

@interface v_pay : iPageView<iCarouselDelegate,iCarouselDataSource>

{
    iCarousel *carousel;
    NSMutableArray *items;
    int num, _vid;
    NSArray *varr;
}

-(void)saveInfo:(NSArray*)arr vid:(int)v;

@end
