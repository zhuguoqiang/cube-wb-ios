//! \file TouchVGView.h
//! \brief 定义iOS绘图视图类 TouchVGView
// Copyright (c) 2012-2013, https://github.com/rhcad/touchvg

#import "GiPaintView.h"
#import "GraphMeta.h"

class BoardViewAdapter;
class GiCoreView;

enum kTestFlags {
    kSplinesCmd = 1,
    kSelectCmd  = 2,
    kSelectLoad = 3,
    kLineCmd    = 4,
    kLinesCmd   = 5,
    kHitTestCmd = 6,
    kAddImages  = 7,
    kLoadImages = 8,
    kSVGImages  = 9,
    kSVGPages   = 10,
    kCmdMask    = 15,
    kSwitchCmd  = 16,
    kRandShapes = 32,
    kRecord     = 64,
};

//! iOS测试绘图视图类
@interface TouchVGView : UIView
{
    
}
@property (nonatomic, assign) UIColor*   lineColor;//!< 线条颜色，忽略透明度，clearColor或nil表示不画线
@property (nonatomic, assign) int lineARGB;

- (GiCoreView *)coreView;               //!< 得到跨平台内核视图
- (UIImage *)snapshot;                  //!< 得到静态图形的快照，自动释放
- (BOOL)exportPNG:(NSString *)filename; //!< 保存静态图形的快照到PNG文件

- (NSMutableArray *)getMetaQueue;

- (void)drawMeta:(GraphMeta *)meta;

- (void)drawMeta:(GraphMeta *)meta withLineARGB:(int)lineARGB;

- (void)clear;

@end
