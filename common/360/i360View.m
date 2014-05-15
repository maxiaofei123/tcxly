//
//  page_ani.m
//  david
//
//  Created by liyi on 11-5-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "i360View.h"

@implementation i360View

@synthesize dragLoop;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization code
        
        //序列帧动画view
        animationView = [[UIImageView alloc] init];
        animationView.userInteractionEnabled=YES;
        [self addSubview:animationView];
        
        //scrollview拖动
        v=[self addScrollView:self
                     delegate:self
                        frame:frame
                      bounces:NO
                         page:NO
                        showH:NO
                        showV:NO];
        
        
        v.decelerationRate=0.8;
        v.contentSize=CGSizeMake(40960, v.frame.size.height);
        
        [self addSubview:v];
        
        curFrame=0;
        rNum=curFrame;
        
        postionArray=[NSMutableArray array];
        
        sx=40960/2;
        
        dragLoop=YES;

    }
    return self;
}

-(void)setScrollEnable:(BOOL)e
{
    v.scrollEnabled=e;
}

-(int)getCurrentFrame
{
    return rNum;
}

-(void)setLastFrame
{
    [self setCurrentFrame:[img_array count]-1];   
}

-(void)setCurrentFrame:(int)cf
{
    curFrame=cf;
    rNum=curFrame;
    
    
    for (int i=0; i<[postionArray count]; i++) {
        NSArray *a=[postionArray objectAtIndex:i];
        NSValue *value=[a objectAtIndex:curFrame];
        [self viewWithTag:8000+i].center=[value CGPointValue];
    }
    
    [animationView setImage:[img_array objectAtIndex:curFrame]];
}

//加点
-(UIButton*)addPoint:(UIView*)_u Image:(NSString*)fn Postion:(NSMutableArray*)ma
{
    [postionArray addObject:ma];
    
    UIButton *bt= [self addButton:self
                            image:fn
                         position:CGPointMake(0, 0)
                              tag:8000+[postionArray count]-1
                           target:_u
                           action:@selector(onKeyPointDown:)];
    
    
    for (int i=0; i<[postionArray count]; i++) {
        NSArray *a=[postionArray objectAtIndex:i];
        NSValue *value=[a objectAtIndex:0];
        [self viewWithTag:8000+i].center=[value CGPointValue];
    }
    
    return bt;
}

//-----------------------------------------------------------------------------
-(void)playAnimation:(BOOL)loop Inverted:(BOOL)inverted
{    
    playLoop=loop;
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                           target:self 
                                         selector:@selector(update) 
                                         userInfo:nil
                                          repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    if(inverted)
    {
        
        curFrame=count-1;
        [self setCurrentFrame:curFrame];
        dir=-1;
    }
    else {
        dir=1;
    }
    
}

-(void)update
{
    curFrame=curFrame+dir;
    
      
    if((curFrame>=count||curFrame<0)&&playLoop==NO)
    {
        
        curFrame=curFrame<0?0:count-1;
        
        [timer invalidate];
        timer=nil;
        v.userInteractionEnabled=YES;
        
        if([delegate conformsToProtocol:@protocol(i360ViewDelegate)])
        {
            [delegate i360DidEndAnimation:self];
        }
        return;
    }
    
    
    if(curFrame<0)
    {
        curFrame=count-1;
    }
    else if(curFrame>=count)
    {
        curFrame=0;
    }

    
    //NSLog(@"%d",curFrame);
    [self setCurrentFrame:curFrame];
}
//-----------------------------------------------------------------------------

-(void)gotoAndStop:(int)f
{
    if(timer!=nil)
    {
        return;
    }
    v.userInteractionEnabled=NO;
    targetFrame=f;
   
    
    dir=curFrame-f<count-curFrame?-1:1;

    if(curFrame==targetFrame)
    {
        dir=0;
    }
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0/60.0
                                           target:self 
                                         selector:@selector(step) 
                                         userInfo:nil
                                          repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)step
{    
    curFrame=curFrame+dir;
    
    if(curFrame<0)
    {
        curFrame=count-1;
    }
    else if(curFrame>=count)
    {
        curFrame=0;
    }
    
    if(curFrame==targetFrame)
    {
        [timer invalidate];
        timer=nil;
        v.userInteractionEnabled=YES;
        
        [delegate i360DidEndGotoAndStop:self];
    }

    //NSLog(@"%d %d",curFrame,targetFrame);
    [self setCurrentFrame:curFrame];
}
//-----------------------------------------------------------------------------

-(void)unloadCurrentPage
{
    img_array=nil;
    postionArray=nil;
    
    self.delegate=nil;
    [self stopNSTimer];
    
    NSLog(@"unload success");
}


-(void)stopNSTimer
{
    [timer invalidate];
    timer=nil;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    curFrame=rNum;
    scrollView.contentOffset=CGPointMake(v.contentSize.width/2, 0);
    sx=scrollView.contentOffset.x; 
    
    for (int i=0; i<[postionArray count]; i++) {
        [self viewWithTag:8000+i].hidden=NO;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int distance=sx-scrollView.contentOffset.x;
    int cf=curFrame-distance/20;
    
    
    //循环拖动?
    if (dragLoop==NO) {
        
        if(cf<=0||cf>=count-1)
        {
            return;
        }
    }

    rNum=cf%count;
    
    NSLog(@"distance=%d cf=%d rNum=%d count=%d",distance,cf,rNum,count);
    
    rNum=rNum<0?count+rNum:rNum;
    [animationView setImage:[img_array objectAtIndex:rNum]];
    
    
   
    
    [delegate i360DidDrag:self];
    
    //追点移动
    for (int i=0; i<[postionArray count]; i++) {
        
        NSArray *a=[postionArray objectAtIndex:i];
        NSValue *value=[a objectAtIndex:rNum];
        [self viewWithTag:8000+i].center=[value CGPointValue];
        
        //NSLog(@"x=====%f",[value CGPointValue].x);
    }
}





-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    NSLog(@"scrollViewDidEndDragging");
    
    for (int i=0; i<[postionArray count]; i++) {
        [self viewWithTag:8000+i].hidden=NO;
    }
    
    if(decelerate==NO)
    {
        curFrame=rNum;
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    curFrame=rNum;
}

//--------------------------------------------------------------------------------------------------------------------
//load图片
-(void) loadImages:(NSString*)n Type:(NSString*)t
{
    
    curFrame=0;
    rNum=curFrame;
    
    imageName=n;
    
    img_array=nil;
	img_array=[NSMutableArray array];
    
    for (int i = 0; i <1000; i++)
    {
        count=i;
        UIImage *ui=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] 
                                                      pathForResource:[NSString stringWithFormat:@"%@%d",imageName,i] 
                                                      ofType:t]];
        if(ui==nil)
        {
            break;
        }
        
        [img_array addObject:ui];
    }
    
    UIImage *im=[img_array objectAtIndex:0];
    
    animationView.frame=CGRectMake(0, 0, im.size.width, im.size.height);
    animationView.image=[img_array objectAtIndex:curFrame];
    animationView.userInteractionEnabled=YES;
    
    //NSLog(@"图片共%d帧",count);    
}


@end
