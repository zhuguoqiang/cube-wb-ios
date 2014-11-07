// ViewFactory.mm
// Copyright (c) 2012-2013, 

#import "TouchVGView.h"

static UIViewController *_tmpController;

static void addView(NSMutableArray *arr, UIView* view)
{
    if (view) {
        _tmpController = [[UIViewController alloc] init];
        
        _tmpController.view = view;
//        [_tmpController.view addSubview:view];
    }
}
static UIView* addGraphView(NSMutableArray *arr, NSUInteger &i,
                             CGRect frame, int type)
{
    UIView *v = nil;
    v = [[TouchVGView alloc]initWithFrame:frame];
    addView(arr, v);
    return v;
}


static void gatherTestView(NSMutableArray *arr, CGRect frame)
{
    NSUInteger i = 0;

    addGraphView(arr, i, frame, 0);

}

UIViewController *createTestView(CGRect frame)
{
    _tmpController = nil;
    gatherTestView(nil, frame);
    return _tmpController;
}
