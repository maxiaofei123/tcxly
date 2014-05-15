//
//  selectAvatar.h
//  tcxly
//
//  Created by Li yi on 13-8-31.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"

 UIImage *scaleImage;
@interface selectAvatar1 : iPageView<UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{

    
    
    NSData *scaleData;
    NSData *data;
    
    NSString *fullPath;
    NSString *filePath;
    UIImageView * av;
    int imageFlag;
    selectAvatar1 * select;
    
    UIPopoverController *popover;
    

}
@property (nonatomic, strong) UIPopoverController *popover;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;


@end
