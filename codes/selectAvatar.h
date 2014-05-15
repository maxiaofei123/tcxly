//
//  selectAvatar.h
//  tcxly
//
//  Created by Li yi on 13-8-31.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "iPageView.h"
UIImage *scaleImage;
@interface selectAvatar : iPageView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{

    
    NSString *fullPath;
    NSString *filePath;
    

    NSData *scaleData;
    NSData *data;
    UIImageView * av;
    int imageFlag;
    
    UIPopoverController *popover;
    
    
}
@property (nonatomic, strong) UIPopoverController *popover;


@property (retain, nonatomic) IBOutlet UIImageView *imageView;


@end
