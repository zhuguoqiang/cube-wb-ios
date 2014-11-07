//
//  TouchVGViewController.m
//  VideoChat
//
//  Created by DuanWeiwei on 14-7-17.
//  Copyright (c) 2014年 DuanWeiwei. All rights reserved.
//

#import "TouchVGViewController.h"
#import "TouchVGView.h"
#import "ImageMeta.h"
#import "ImagePickerController.h"
#include "global_config.h"
#import "SettingsViewController.h"

@interface TouchVGViewController ()
{
    NSTimer *_timer;
    
    ImageMeta *_imageMeta;
    
    ImageMeta *_peerImageMeta;
}

@property (nonatomic, strong) TouchVGView *tvgView;

@end

@implementation TouchVGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Nothing
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:
//                                 [UIImage imageNamed:@"TouchVG.bundle/translucent.png"]];

    // 启动定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    _imageMeta = nil;
    _peerImageMeta = nil;

    [CCTalkService sharedSingleton].listener = self;

    // 连接服务器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       // 连接 Cellet 服务
                       CCInetAddress *address = [[CCInetAddress alloc] initWithAddress:WHITEBOARD_SERVER_HOST port:WHITEBOARD_SERVER_PORT];
                       [[CCTalkService sharedSingleton] call:@"Whiteboard" hostAddress:address];
                   });
//    CGRect frame = self.contentView.bounds;
//    self.tvgView = [[TouchVGView alloc] initWithFrame:frame];
//    [self.contentView addSubview:self.tvgView];
    CGRect frame = self.view.bounds;
    self.tvgView = [[TouchVGView alloc] initWithFrame:frame];
    [self.view addSubview:self.tvgView];
    
    [self.view sendSubviewToBack:self.tvgView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)dealloc
{
    [[CCTalkService sharedSingleton] hangUp:@"Whiteboard"];

    [_timer invalidate];
    _timer = nil;

    _imageMeta = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)setContent:(UIViewController *)c
{
    if (_content) {
        [_content.view removeFromSuperview];
        _content.view = nil;
    }
    _content = c ;
    if (_content) {
        UIView *view = _content.view;
        CGRect barframe = self.navigationController.navigationBar.frame;
        CGFloat y = barframe.origin.y + barframe.size.height;
        view.frame = CGRectMake(0, y, self.view.bounds.size.width,
                                self.view.bounds.size.height - y);
        [self.view addSubview:view];
        view.autoresizingMask = 0xFF;
        [view setNeedsDisplay];
    }
    
}

#pragma mark - IBACTION
//设置
- (IBAction)btnSettingAction:(id)sender {
    SettingsViewController *settingsVC = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
    [self presentViewController:settingsVC animated:YES completion:^{
          
      }];
}

- (IBAction)btnRedPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor redColor];    
}

- (IBAction)btnBlackPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor blackColor];
}

- (IBAction)btnBluePencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor blueColor];
}

- (IBAction)btnBrownPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor brownColor];
}

- (IBAction)btnDarkOrangePencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor colorWithRed:1.0 green:122/255.0 blue:43/255.0 alpha:1];
}

- (IBAction)btnDarkGreenPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor colorWithRed:86/255.0 green:128/255.0 blue:44/255.0 alpha:1];
}

- (IBAction)btnGreyPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor grayColor];
}

- (IBAction)btnLightBluePencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor colorWithRed:86/255.0 green:212/255.0 blue:255.0/255.0 alpha:1];
}

- (IBAction)btnLightGreenPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor colorWithRed:128/255.0 green:255.0/255.0 blue:44/255.0 alpha:1];
}

- (IBAction)btnYellowPencilAction:(id)sender {
    self.tvgView.lineColor = [UIColor yellowColor];
}

//返回
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//清除
- (IBAction)clear:(id)sender
{
    CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"clearMeta"];
    NSString *data = [NSString stringWithFormat:@"{\"peerName\":\"%@\"}", self.peerCallId];
    [dialect appendParam:@"data" stringValue:data];
    [[CCTalkService sharedSingleton] talk:@"Whiteboard" dialect:dialect];
    
    [self.tvgView clear];
}

- (IBAction)pickImage:(id)sender
{
    ImagePickerController *pickerCtrl = [[ImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        pickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerCtrl.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerCtrl.sourceType];
    }
    pickerCtrl.delegate = self;
    pickerCtrl.allowsEditing = NO;
    [self presentViewController:pickerCtrl animated:YES completion:^{
        
    }];
}

- (void)changeImage:(UIImage *)image
{
    if (nil != _imageMeta)
    {
        _imageMeta = nil;
    }

    //self.bgView.image = nil;
    //self.bgView.image = image;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       // 发送图片数据
                       NSData *imgData = UIImageJPEGRepresentation(image, 0.6);
                       _imageMeta = [[ImageMeta alloc] initWithData:imgData peer:self.peerCallId];
                });
}

- (void)showImageMeta:(ImageMeta *)meta
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [meta outputImage];
        if (nil != image)
        {
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:image]];
         
        }

        _peerImageMeta = nil;
    });
}

#pragma mark Timer

- (void)timerFired:(NSTimer *)timer
{
    NSMutableArray *metaQueue = [self.tvgView getMetaQueue];
    if (nil == metaQueue)
    {
        return;
    }

    @synchronized(metaQueue) {
        if (metaQueue.count > 0)
        {
            // 获取 Meta 数据
            GraphMeta *meta = [metaQueue objectAtIndex:0];
            
            NSString *metaJSONString = [meta toJSONString];
            
            int lineARGB = self.tvgView.lineARGB;

            NSString *sharedJSON = [NSString stringWithFormat:@"{\"myName\":\"%@\", \"peerName\":\"%@\", \"meta\":%@, \"lineARGB\":%d}"
                                    , self.myCallId, self.peerCallId, metaJSONString,lineARGB];

            CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"shareMeta"];
            [dialect appendParam:@"data" stringValue:sharedJSON];
            [[CCTalkService sharedSingleton] talk:@"Whiteboard" dialect:dialect];

            // 删除 Meta 数据
            [metaQueue removeObjectAtIndex:0];
        }
    }

    if (nil != _imageMeta)
    {
        int numSegments = _imageMeta.dataSegments.count;
        for (int i = 0; i < numSegments; ++i)
        {
            ImageMetaTracker *tracker = [_imageMeta.transferTrackers objectAtIndex:i];
            if (tracker.state == 0 && i == 0)
            {
                NSString *data = [NSString stringWithFormat:@"{\"peerName\":\"%@\", \"fileSize\":%d, \"segmentNum\":%d, \"segmentIndex\":%d, \"segmentData\":\"%@\"}"
                                  , self.peerCallId
                                  , _imageMeta.fileSize
                                  , numSegments
                                  , i
                                  , [_imageMeta.dataSegments objectAtIndex:i]];
                // 更新状态
                tracker.state = 1;
                CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"imageData"];
                [dialect appendParam:@"data" stringValue:data];
                [[CCTalkService sharedSingleton] talk:@"Whiteboard" dialect:dialect];
                break;
            }
            else if (tracker.state == 2)
            {
                // 找到已经发送成功的位置，发送下一个数据
                NSUInteger nextIndex = i + 1;
                if (nextIndex < numSegments)
                {
                    ImageMetaTracker *nextTracker = [_imageMeta.transferTrackers objectAtIndex:nextIndex];
                    if (nextTracker.state == 1)
                    {
                        // 下一个数据段状态为 1，表示已经发送过数据，则此次忽略
                        break;
                    }
                    else if (nextTracker.state == 2)
                    {
                        // 下一个数据段状态为 2，表示已经被成功接收，继续下一个数据
                        continue;
                    }
                    else if (nextTracker.state == 0)
                    {
                        // 下一个数据段状态为 0，表示可以发送
                        NSString *data = [NSString stringWithFormat:@"{\"peerName\":\"%@\", \"fileSize\":%d, \"segmentNum\":%d, \"segmentIndex\":%d, \"segmentData\":\"%@\"}"
                                          , self.peerCallId
                                          , _imageMeta.fileSize
                                          , numSegments
                                          , nextIndex
                                          , [_imageMeta.dataSegments objectAtIndex:nextIndex]];
                        // 更新状态
                        nextTracker.state = 1;
                        CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"imageData"];
                        [dialect appendParam:@"data" stringValue:data];
                        [[CCTalkService sharedSingleton] talk:@"Whiteboard" dialect:dialect];
                    }
                    break;
                }
                else if (nextIndex >= numSegments)
                {
                    // 下一个数据索引越界，说明已经传输完毕
                    _imageMeta = nil;
                    break;
                }
            }
        }
    }
}

#pragma mark Talk Listener

- (void)dialogue:(NSString *)identifier primitive:(CCPrimitive *)primitive
{
    @synchronized(self) {
        if ([primitive isDialectal])
        {
            CCActionDialect *dialect = (CCActionDialect *) primitive.dialect;
            NSString *action = dialect.action;
            NSString *strJSON = [dialect getParamAsString:@"data"];
            NSData *data = [strJSON dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            if ([action isEqualToString:@"shareMeta"])
            {
                // 绘制 Meta
                NSDictionary *metaJson = [json objectForKey:@"meta"];
                NSNumber *num = [json objectForKey:@"lineARGB"];
                int lineARGB = num.intValue;
                
                GraphMeta *meta = [[GraphMeta alloc] initWithJSON:metaJson];
                [self.tvgView drawMeta:meta withLineARGB:lineARGB];
            }
            else if ([action isEqualToString:@"clearMeta"])
            {
                [self.tvgView clear];
            }
            else if ([action isEqualToString:@"imageTrack"])
            {
                NSNumber *num = [json objectForKey:@"segmentIndex"];
                NSUInteger segmentIndex = num.unsignedIntegerValue;
                if (nil != _imageMeta)
                {
                    // 确认数据已接收
                    ImageMetaTracker *tracker = [_imageMeta.transferTrackers objectAtIndex:segmentIndex];
                    tracker.state = 2;
                }
            }
            else if ([action isEqualToString:@"imageData"])
            {
                NSInteger segmentNum = ((NSNumber *)[json objectForKey:@"segmentNum"]).unsignedIntegerValue;
                NSUInteger segmentIndex = ((NSNumber *)[json objectForKey:@"segmentIndex"]).unsignedIntegerValue;
                if (nil == _peerImageMeta)
                {
                    NSUInteger fileSize = ((NSNumber *)[json objectForKey:@"fileSize"]).unsignedIntegerValue;
                    _peerImageMeta = [[ImageMeta alloc] initWithSegment:fileSize segmentNum:segmentNum];
                }

                NSString *segmentData = [json objectForKey:@"segmentData"];
                [_peerImageMeta.dataSegments addObject:[NSString stringWithString:segmentData]];
                ImageMetaTracker *tracker = [_peerImageMeta.transferTrackers objectAtIndex:segmentIndex];
                tracker.state = 1;

                if (segmentIndex + 1 == segmentNum)
                {
                    [self showImageMeta:_peerImageMeta];
                }
            }
        }
    }
}

- (void)contacted:(NSString *)identifier tag:(NSString *)tag
{
    // 进行注册
    CCActionDialect *dialect = [[CCActionDialect alloc] initWithAction:@"register"];
    NSString *value = [NSString stringWithFormat:@"{\"name\":\"%@\"}", self.myCallId];
    [dialect appendParam:@"data" stringValue:value];
    [[CCTalkService sharedSingleton] talk:@"Whiteboard" dialect:dialect];
}

- (void)quitted:(NSString *)identifier tag:(NSString *)tag
{
}

- (void)failed:(CCTalkServiceFailure *)failure
{
    NSLog(@"CC Failed: %@", failure.description);

    // 连接服务器
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       // 连接 Cellet 服务
                       CCInetAddress *address = [[CCInetAddress alloc] initWithAddress:WHITEBOARD_SERVER_HOST port:WHITEBOARD_SERVER_PORT];
                       [[CCTalkService sharedSingleton] call:@"Whiteboard" hostAddress:address];
                   });

}


#pragma mark Action Delegate

- (void)doAction:(CCActionDialect *)dialect
{
    [CCLogger d:@"Do action '%@' - identifier=%@ tag=%@ (thread:%@)"
     , dialect.action
     , dialect.celletIdentifier
     , dialect.ownerTag
     , [NSThread currentThread]];
}

#pragma mark UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self changeImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
