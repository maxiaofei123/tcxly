//
//  mpvc.h
//  v2.0
//
//  Created by liyi on 2011-11-1.
//  Copyright 2011 iZom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface mpvc : UIViewController {
	MPMoviePlayerController	*movieManager;
}

-(void)load:(NSString*) _fn Ex:(NSString*) _ex;

@end
