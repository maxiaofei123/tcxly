//
//  v_level.h
//  tcxly
//
//  Created by Terry on 13-5-4.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
#import "iCarousel.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "v_unit.h"
@interface v_level : iPageView<iCarouselDelegate,iCarouselDataSource, UIAlertViewDelegate,loadMapDelegate>

{
    
    iCarousel *carousel;
    NSMutableArray *items;
    
    int num;
    
    ASIHTTPRequest *request;
    
    NSArray *allArray;
}

-(void)clearSelf;

@end
