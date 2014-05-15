//
//  selectAvatar.m
//  tcxly
//
//  Created by Li yi on 13-8-31.
//  Copyright (c) 2013年 Terry. All rights reserved.
//

#import "selectAvatar1.h"
#import "profile.h"

@implementation selectAvatar1

@synthesize popover;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
          [self addBackground:@"bg.png"];
           av = [self addImageView:self
                             image:@"avatar_ui.png"
                          position:CGPointMake(100, 32)];
        
        
    }
    return self;
}

-(void)loadCurrentPage:(int)cmd
{

    
    NSMutableArray *pos=[NSMutableArray array];
    
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(123, 129)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(319, 129)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(516, 129)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(712, 129)]];
    
    
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(123, 323)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(319, 323)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(516, 323)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(712, 323)]];
    
    
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(123, 518)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(319, 518)]];
    [pos addObject:[NSValue valueWithCGPoint:CGPointMake(516, 518)]];
    //[pos addObject:[NSValue valueWithCGPoint:CGPointMake(712, 518)]];
  
    
    for (int i=0; i<[pos count]; i++) {
        CGPoint p=[[pos objectAtIndex:i] CGPointValue];
        
      UIButton *bt=  [self addButtonWithImageView:self
                               image:[NSString stringWithFormat:@"avatar_%d.jpg",i+1]
                           highlight:nil
                            position:p
                                   t:1000+i
                              action:@selector(onTap:)];
    }


    [self addButton:self
              image:@"back.png"
           position:CGPointMake(30, 30)
                tag:8888
             target:self
             action:@selector(backClick:)
     
     ];
    
    [self addButton:self
              image:@"avatar_up.png"
           position:CGPointMake(726,588)
                tag:8889
             target:self
             action:@selector(chooseImage:)];
   
 
}

-(void)backClick:(UIButton*)sender
{
    [self fadeOutView:self duration:.5];
}


-(void)onTap:(UIGestureRecognizer*)sender
{
    
    for (int i=0; i<12; i++) {
        [self viewWithTag:1000+i].transform=CGAffineTransformMakeScale(1, 1);
    }
    
    
    [UIView animateWithDuration:.5
                     animations:^{
                         UIView *bt=[self viewWithTag:sender.view.tag];
                         
                         [self bringSubviewToFront:bt];
                         bt.transform=CGAffineTransformMakeScale(1.2, 1.2);
                         
                         
                     } completion:^(BOOL finished) {
                         profile  *p=(profile*)self.superview;
                         [p updateAvatar:sender.view.tag-1000+1];
                         
                         [self fadeOutView:self duration:.5];
                         
                     }];
    
}


- (IBAction)chooseImage:(id)sender {
    
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"从相册中选择",@"摄像头拍摄", nil];
      
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"butunIndex=%d",buttonIndex);
    UIViewController * viewController = [self getManager];

         switch (buttonIndex) {
             case 2:
                 
                 break;
             case 1:{
                     NSLog(@"shexiang tou paishe");
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
          
                     UIImagePickerController *imgPicker = [UIImagePickerController new];
                     imgPicker.delegate = self;
                     imgPicker.allowsEditing= YES;
                     imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                     [viewController presentViewController:imgPicker animated:YES completion:nil];
                      return;
                 }
                 else {
                     
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                         message:@"该设备没有摄像头"
                                                                        delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:@"好", nil];
                     [alertView show];

            
                 }
             }
             break;
  
             case 0:{
        
                 UIViewController * viewController = [self getManager];
                 
                 UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                 imagePicker.delegate = self;
                 imagePicker.allowsEditing = YES;
                 imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                 
                 // es iPad
                 if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                     
                     //Averiguar si está en portrait o landscape
                     UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
                     
                     //PORTRAIT
                     if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
                     {
                         
                        // [self cerrarTeclado];
                         
                         self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                         self.popover.delegate = self;
                         
                         [self.popover presentPopoverFromRect:CGRectMake(600, 0, 0, 0) inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
                         [self.popover setPopoverContentSize:CGSizeMake(1024, 768)];
                         
                     }
                     //LANDSCAPE
                     if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)
                     {
                         
                         self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                         self.popover.delegate = self;
                         
                         [self.popover presentPopoverFromRect:CGRectMake(600, 0, 0, 0) inView:viewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
                         [self.popover setPopoverContentSize:CGSizeMake(1024, 768)];
                         
                     }
                     
                 } else {
                     // no es iPad 
                     [viewController presentViewController:imagePicker animated:YES completion:nil];
                 }                     
             }
            break;
        
            default:
                 
            break;
        }
    
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIViewController * viewController = [self getManager];
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        //获取编辑后的图片
        UIImage * originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        //UIImage  * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.imageView setImage:originImage];
        NSLog(@"originImage =%@",originImage);
        scaleImage = [self scaleImage:originImage toScale:0.3];
        
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            
            data = UIImageJPEGRepresentation(scaleImage,1);
            
        } else {
            
            data = UIImagePNGRepresentation(scaleImage);
        }
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
   
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"flag"];
        profile  *p=(profile*)self.superview;
        [p avtatarImage:image];
        [self fadeOutView:self duration:.5];
        
        picker.navigationBar.hidden = YES;
        [picker dismissModalViewControllerAnimated:YES];
        [popover dismissPopoverAnimated:YES];
        
    }
    
}


-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self dataCreatToCache:@".jpg" fileName:@"image"];
    return scaledImage;
}


#pragma mark 保存图片到document
-(void)dataCreatToCache:(NSData*)data fileName:(NSString*)name
{
    //或者本地路径，这边是library下
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    NSString *path=[paths objectAtIndex:0];
    //获取文件夹路径
    path=[path stringByAppendingPathComponent :@"image" ];
    //打开这个test文件夹，如果不存在就新建，存在就打开
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    //将data存在image文件夹下，命名为xxx.jpg
    filePath = [NSString stringWithFormat:@"%@/%@.jpg", path ,name];
    
    [data writeToFile:filePath atomically:YES];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	UIViewController * viewController = [self getManager];
    [viewController dismissViewControllerAnimated:YES completion:^{}];
}



#pragma mark 从文档目录下获取Documents路径

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
}

@end
