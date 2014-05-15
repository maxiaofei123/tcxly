//
//  v_switch.h
//  tcxly
//
//  Created by Li yi on 13-9-22.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "iCarousel.h"
@interface v_switch : iPageView<iCarouselDataSource,iCarouselDelegate,UIAlertViewDelegate>
{
    UIScrollView *sv;
    iCarousel *carousel;
    NSMutableArray *items;
}
@end
