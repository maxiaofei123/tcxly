//
//  iHSVImagePage.m
//  dalian
//
//  Created by 毅 李 on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iSVImagePage.h"

@implementation iSVImagePage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.backgroundColor=[UIColor blackColor];
        
        ssv= [self addScrollView:self
                       delegate:self
                          frame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                        bounces:YES
                           page:NO
                          showH:NO
                          showV:NO];
        
        ssv.contentSize=frame.size;
    }
    return self;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (ssv.bounds.size.width > ssv.contentSize.width)?
    (ssv.bounds.size.width - ssv.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (ssv.bounds.size.height > ssv.contentSize.height)?
    (ssv.bounds.size.height - ssv.contentSize.height) * 0.5 : 0.0;
    im.center = CGPointMake(ssv.contentSize.width * 0.5 + offsetX,
                                    ssv.contentSize.height * 0.5 + offsetY);
}

-(void)autoLoad:(NSString*)image
{
    NSLog(@"iHSVImagePage:%@",image);
    
    
    im=[self addImageView:ssv
                    image:image
                 position:CGPointMake(0, 0)];

    
    if(im.frame.size.width>im.frame.size.height)
    {
        minScale=(float)self.frame.size.width/im.frame.size.width;
    }
    else
    {
        minScale=(float)self.frame.size.height/im.frame.size.height;
    }
    
    
    maxScale=1;
    
    [ssv setMinimumZoomScale:minScale];
    [ssv setMaximumZoomScale:1];
    [ssv setZoomScale:minScale];

}

-(void)resetScale:(UIGestureRecognizer*)e {
    [ssv setZoomScale:minScale animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopNSTimer];
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [self stopNSTimer];
}

-(void)stopNSTimer
{
    [diveTimer invalidate];
    diveTimer=nil;
}

-(void)diveTo
{
    [ssv setContentOffset:CGPointMake(ox++, 0)];
    
    if(ox>ssv.contentSize.width-1024)
    {
        [self stopNSTimer];
    }
}

-(void)load:(NSString*)image maxScale:(float)m minScale:(float)s
{
    NSLog(@"iHSVImagePage:%@",image);
    
    im=[self addImageView:ssv
                    image:image
                 position:CGPointMake(0, 0)];

    //im.center=CGPointMake(512, 384);
    
    minScale=s;
    maxScale=m;
    
    [ssv setMinimumZoomScale:s];
    [ssv setMaximumZoomScale:m];
    [ssv setZoomScale:s];
    
    [self addDoubleTapEvent:ssv target:self action:@selector(resetScale:)];
}

-(void) loadCurrentPage:(int)cmd {
    ox = 0;
    diveTimer=[NSTimer scheduledTimerWithTimeInterval:.05
                                               target:self
                                             selector:@selector(diveTo)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:diveTimer
                              forMode:NSRunLoopCommonModes];
}

-(void)unloadCurrentPage
{
    [ssv setZoomScale:minScale];
    [ssv setContentOffset:CGPointMake(0, 0)];
    [self stopNSTimer];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return im;
}

@end
