//! \file TouchVGView.mm
//! \brief 实现iOS绘图视图类 TouchVGView
// Copyright (c) 2012-2013, https://github.com/rhcad/touchvg

#import "TouchVGView.h"
#import "GiViewHelper.h"
#import <QuartzCore/QuartzCore.h>
#include "GiCanvasAdapter.h"
#include "gicoreview.h"
#import "ARCMacro.h"

GiColor CGColorToGiColor(CGColorRef color) {
    size_t num = CGColorGetNumberOfComponents(color);
    CGColorSpaceModel space = CGColorSpaceGetModel(CGColorGetColorSpace(color));
    const CGFloat *rgba = CGColorGetComponents(color);
    
    if (space == kCGColorSpaceModelMonochrome && num >= 2) {
        int c = (int)lroundf(rgba[0] * 255.f);
        return GiColor(c, c, c, (int)lroundf(rgba[1] * 255.f));
    }
    if (num < 3) {
        return GiColor::Invalid();
    }
    
    return GiColor((int)lroundf(rgba[0] * 255.f),
                   (int)lroundf(rgba[1] * 255.f),
                   (int)lroundf(rgba[2] * 255.f),
                   (int)lroundf(CGColorGetAlpha(color) * 255.f));
}

//! 动态图形的绘图视图类
@interface BoardGiDynDrawView : UIView
{
    BoardViewAdapter *_adapter;
}

- (id)initWithFrame:(CGRect)frame :(BoardViewAdapter *)viewAdapter;

@end

#pragma mark BoardViewAdapter

//! 绘图视图适配器
class BoardViewAdapter : public GiView
{
private:
    UIView      *_view;
    UIView      *_dynview;
    GiCoreView  *_core;
    UIImage     *_tmpshot;
    int         _sid;

public:
    BoardViewAdapter(UIView *mainView)
        : _view(mainView), _dynview(nil), _tmpshot(nil)
    {
        _core = GiCoreView::createView(this, 0);
    }

    virtual ~BoardViewAdapter()
    {
        if (_core)
        {
            _core->release();
            _core = NULL;
        }
    }
    
    GiCoreView *coreView()
    {
        return _core;
    }
    
    UIView *getDynView()
    {
        return _dynview;
    }
    
    UIImage *snapshot()
    {
        UIGraphicsBeginImageContextWithOptions(_view.bounds.size, _view.opaque, 0);
        [_view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    bool drawAppend(GiCanvasAdapter* canvas)
    {
        bool ret = false;
        
        if (_tmpshot)
        {
            [_tmpshot drawAtPoint:CGPointZero];
            _tmpshot = nil;
            ret = _core->drawAppend(this, canvas, _sid);
        }
        return ret;
    }

    virtual void regenAll(bool changed)
    {
        if (_view.window)
        {
            if (changed)
            {
                _sid = 0;
                _core->submitBackDoc(this, changed);
            }
            _core->submitDynamicShapes(this);
            [_view setNeedsDisplay];
            [_dynview setNeedsDisplay];
        }
    }
    
    virtual void regenAppend(int sid, long playh)
    {
        if (_view.window)
        {
            _sid = sid;
            _core->submitBackDoc(this, true);
            _core->submitDynamicShapes(this);
            _tmpshot = nil;                 // renderInContext可能会调用drawRect
            _tmpshot = snapshot();

            [_view setNeedsDisplay];
            [_dynview setNeedsDisplay];
        }
    }

    virtual void redraw(bool changed)
    {
        if (_view.window)
        {
            _core->submitDynamicShapes(this);
            if (!_dynview && _view)
            {
                // 自动创建动态图形视图
                _dynview = [[BoardGiDynDrawView alloc] initWithFrame:_view.frame :this];
                _dynview.autoresizingMask = _view.autoresizingMask;
                [_view.superview addSubview:_dynview];
            }
            [_dynview setNeedsDisplay];
        }
    }
};

#pragma mark BoardGiDynDrawView

@implementation BoardGiDynDrawView

- (id)initWithFrame:(CGRect)frame :(BoardViewAdapter *)viewAdapter
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _adapter = viewAdapter;
        self.opaque = NO;                           // 透明背景
        self.userInteractionEnabled = NO;           // 禁止交互，避免影响主视图显示
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    GiCanvasAdapter canvas;

    if (canvas.beginPaint(UIGraphicsGetCurrentContext()))
    {
        _adapter->coreView()->dynDraw(_adapter, &canvas);
        canvas.endPaint();
    }
}

@end

#pragma mark TouchVGView

@interface TouchVGView ()
{
    BoardViewAdapter *_adapter;

    GraphMeta *_currentMeta;
    NSMutableArray* _metaQueue;

    BOOL _drawing;
}

@end

@implementation TouchVGView

@synthesize lineColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = NO;                           // 透明背景
        self.autoresizingMask = 0xFF;               // 自动适应大小
        _adapter = new BoardViewAdapter(self);

        _drawing = NO;

        GiCoreView::setScreenDpi(giGetScreenDpi());
        [self coreView]->onSize(_adapter, frame.size.width, frame.size.height);

        _metaQueue = [NSMutableArray arrayWithCapacity:10];
    }

    //self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)dealloc
{
    _currentMeta = nil;

    [_metaQueue removeAllObjects];
    _metaQueue = nil;

    delete _adapter;
    [super DEALLOC];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    GiCanvasAdapter canvas;
    GiCoreView* coreView = [self coreView];

    coreView->onSize(_adapter, self.bounds.size.width, self.bounds.size.height);
    canvas.setPen(0xFFFF0000, 1.0, 0, 0, 0);
    canvas.setBrush(0xFFFF0000, 0);
    if (canvas.beginPaint(context))
    {

        if (!_adapter->drawAppend(&canvas))
        {
            coreView->drawAll(_adapter, &canvas);
        }
        canvas.endPaint();
    }
}

- (void)removeFromSuperview
{
    [_adapter->getDynView() removeFromSuperview];
    [super removeFromSuperview];
}

- (UIColor *)GiColorToUIColor:(GiColor)c {
    if (c.a == 0)
        return [UIColor clearColor];
    c.a = 255;
    if (c == GiColor::White())
        return [UIColor whiteColor];
    if (c == GiColor::Black())
        return [UIColor blackColor];
    if (c == GiColor(255, 0, 0))
        return [UIColor redColor];
    if (c == GiColor(0, 255, 0))
        return [UIColor greenColor];
    if (c == GiColor(0, 0, 255))
        return [UIColor blueColor];
    if (c == GiColor(255, 255, 0))
        return [UIColor yellowColor];
    
    return [UIColor colorWithRed:(float)c.r/255.f green:(float)c.g/255.f
                            blue:(float)c.b/255.f alpha:1];
}

- (UIColor *)lineColor {
    GiContext& ctx = [self coreView]->getContext(false);
    return [self GiColorToUIColor:ctx.getLineColor()];
}


- (void)setLineColor:(UIColor *)value {
    GiColor c = value ? CGColorToGiColor(value.CGColor) : GiColor::Invalid();
    _adapter->coreView()->getContext(true).setLineColor(c);
    _adapter->coreView()->setContext(c.a ? GiContext::kLineRGB : GiContext::kLineARGB);
}

- (int)lineARGB
{
    GiContext& ctx = [self coreView]->getContext(false);
    return ctx.getLineARGB();
}

- (void)setLineARGB:(int)lineARGB
{
    GiColor c = GiColor();
    c.setARGB(lineARGB);
    _adapter->coreView()->getContext(true).setLineColor(c);
    _adapter->coreView()->setContext(c.a ? GiContext::kLineRGB : GiContext::kLineARGB);
}

- (GiCoreView *)coreView
{
    return _adapter->coreView();
}

- (UIImage *)snapshot
{
    return _adapter->snapshot();
}

- (BOOL)exportPNG:(NSString *)filename
{
    BOOL ret = NO;
    UIImage *image = [self snapshot];
    NSData* imageData = UIImagePNGRepresentation(image);

    if (imageData)
    {
        ret = [imageData writeToFile:filename atomically:NO];                 
    }

    return ret;
}

- (NSMutableArray *)getMetaQueue
{
    return _metaQueue;
}

- (void)drawMeta:(GraphMeta *)meta
{
    // 绘制
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *x = [meta.begin objectForKey:@"x"];
        NSNumber *y = [meta.begin objectForKey:@"y"];
        [self coreView]->onGesture(_adapter, kGiGesturePan, kGiGestureBegan, x.floatValue, y.floatValue);
        
        for (int i = 0; i < meta.path.count; ++i)
        {
            NSDictionary *item = [meta.path objectAtIndex:i];
            x = [item objectForKey:@"x"];
            y = [item objectForKey:@"y"];
            
            [self coreView]->onGesture(_adapter, kGiGesturePan, kGiGestureMoved, x.floatValue, y.floatValue);
        }
        
        x = [meta.end objectForKey:@"x"];
        y = [meta.end objectForKey:@"y"];
        [self coreView]->onGesture(_adapter, kGiGesturePan, kGiGestureEnded, x.floatValue, y.floatValue);
    });
}

- (void)drawMeta:(GraphMeta *)meta withLineARGB:(int)lineARGB
{
    self.lineARGB = lineARGB;
    // 绘制
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber *x = [meta.begin objectForKey:@"x"];
        NSNumber *y = [meta.begin objectForKey:@"y"];
        [self coreView]->onGesture(_adapter, kGiGesturePan, kGiGestureBegan, x.floatValue, y.floatValue);
        
        for (int i = 0; i < meta.path.count; ++i)
        {
            NSDictionary *item = [meta.path objectAtIndex:i];
            x = [item objectForKey:@"x"];
            y = [item objectForKey:@"y"];
            
            [self coreView]->onGesture(_adapter, kGiGesturePan, kGiGestureMoved, x.floatValue, y.floatValue);
        }
        
        x = [meta.end objectForKey:@"x"];
        y = [meta.end objectForKey:@"y"];
        [self coreView]->onGesture(_adapter, kGiGesturePan, kGiGestureEnded, x.floatValue, y.floatValue);
    });
}

- (void)clear
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self coreView]->clear();
    });
}


#pragma mark Data records

- (void)recordCoord:(NSString *)action x:(float)x y:(float)y
{
    NSNumber *nX = [NSNumber numberWithFloat:x];
    NSNumber *nY = [NSNumber numberWithFloat:y];

    if ([action isEqualToString:@"moved"])
    {
        if (!_drawing)
        {
            return;
        }

        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:nX, @"x", nY, @"y", nil];
        [_currentMeta.path addObject:item];
    }
    else if ([action isEqualToString:@"began"])
    {
        if (_drawing)
        {
            return;
        }

        _drawing = YES;

        _currentMeta = nil;
        _currentMeta = [[GraphMeta alloc] init];
        _currentMeta.begin = [NSDictionary dictionaryWithObjectsAndKeys:nX, @"x", nY, @"y", nil];
    }
    else if ([action isEqualToString:@"ended"])
    {
        if (!_drawing)
        {
            return;
        }

        _currentMeta.end = [NSDictionary dictionaryWithObjectsAndKeys:nX, @"x", nY, @"y", nil];

        @synchronized(_metaQueue) {
            [_metaQueue addObject:_currentMeta];
        }

        _drawing = NO;
    }
}


#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
//    [self setLineColor:[UIColor greenColor]];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:touch.view];

    // 记录
    [self recordCoord:@"began" x:pt.x y:pt.y];
    [self coreView]->onGesture(_adapter, kGiGesturePan,
                               kGiGestureBegan,  pt.x, pt.y);
    //NSLog(@"touchesBegan x = %0.2f, y = %0.2f",pt.x,pt.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:touch.view];

    // 记录
    [self recordCoord:@"moved" x:pt.x y:pt.y];
    [self coreView]->onGesture(_adapter, kGiGesturePan,
                               kGiGestureMoved,  pt.x, pt.y);
    //NSLog(@"touchesMoved x = %0.2f, y = %0.2f",pt.x,pt.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:touch.view];

    // 记录
    [self recordCoord:@"ended" x:pt.x y:pt.y];
    [self coreView]->onGesture(_adapter, kGiGesturePan,
                               kGiGestureEnded,  pt.x, pt.y);
    //NSLog(@"touchesEnded x = %0.2f, y = %0.2f",pt.x,pt.y);
}

@end
