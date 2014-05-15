//
//  mpvc.m
//  v2.0
//
//  Created by liyi on 11-3-1.
//  Copyright 2011 iZom. All rights reserved.
//

#import "mpvc.h"
#import "iBackgroundMusicPlayer.h"


@implementation mpvc

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	//片头
	UIView *movieView=[[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)];
	movieView.backgroundColor=[UIColor blackColor];
	self.view=movieView;
    
	// Register to receive a notification when the movie has finished playing. 
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(moviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
}
//---------------------------------------------------------------------------------------------------------
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
    
     [iBackgroundMusicPlayer fadeIn];
    
	// 删除通知
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:nil];
	
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self dismissModalViewControllerAnimated:YES];	
}

//---------------------------------------------------------------------------------------------------------
-(void)load:(NSString*) _fn Ex:(NSString*) _ex
{
    [iBackgroundMusicPlayer fadeOut];
    
	//路径	
     NSURL *url = [NSURL URLWithString:_fn];

    //视频
    movieManager = [[MPMoviePlayerController alloc] initWithContentURL: url];
    movieManager.controlStyle=MPMovieControlStyleFullscreen;
    [movieManager.view setFrame:CGRectMake(0, 0, 1024,768)];
    [movieManager play];
    [self.view addSubview:movieManager.view];
    
    //通知
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(onMoviePlayBackDidFinish:) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:movieManager];
    
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
