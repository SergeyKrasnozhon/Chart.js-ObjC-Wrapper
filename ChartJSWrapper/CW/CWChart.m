//
//  CWChart.m
//  ChartJSWrapper
//
//  Created by András Gyetván on 22/03/15.
//  Copyright (c) 2015 Gyetván András. All rights reserved.
//

#import "CWChart.h"
#import "CWColors.h"
@interface CWChart ()
#if TARGET_OS_IPHONE
#else
@property (strong) id win;
#endif
@end

@implementation CWChart
- (instancetype) initWithWebView:(CWWebView*)webview name:(NSString*)name width:(NSInteger)w height:(NSInteger)h {
	self = [super init];
	if(self) {
		_width = w;
		_height = h;
		_webview = webview;
#if TARGET_OS_IPHONE
#else
		_win = [_webview windowScriptObject];
#endif
		_name = [NSString stringWithString:name];
	}
	return self;
}

BOOL _debugLogEnabled = NO;

- (void) callJavaScriptMethod:(NSString*)method withArguments:(NSArray*)args {
    [CWChart callJavaScriptMethod:method withArguments:args onWebView:self.webview];
}

+(void) callJavaScriptMethod:(NSString*)method withArguments:(NSArray*)args onWebView:(CWWebView*)webView{
#if TARGET_OS_IPHONE
    NSString* js = [NSString stringWithFormat:@"%@(",method];
    if(args) {
        NSString* params = @"";
        for(NSUInteger i = 0; i < args.count;i++) {
            if(i > 0) {
                params = [params stringByAppendingString:@","];
            }
            NSObject* o = args[i];
            params = [params stringByAppendingString:[NSString stringWithFormat:@"'%@'",o.description]];
        }
        js = [js stringByAppendingString:params];
    }
    js = [js stringByAppendingString:@")"];
    //	NSLog(@"JS to call: %@",js);
    
    [webView evaluateJavaScript:js completionHandler:^(id res, NSError *err) {
        if(err) {
            if(_debugLogEnabled) NSLog(@"Calling %@ results ERROR: %@",method, err.localizedDescription);
        } else {
            if(_debugLogEnabled) NSLog(@"Calling %@ results: %@",method, res);
        }
    }];
    return;
#else
    id res = [self.win callWebScriptMethod:method withArguments:args];
    NSLog(@"Calling %@ results: %@",method, res);
    return;
#endif
}

- (void) update {
	NSArray* params = @[self.name];
	[self callJavaScriptMethod:@"updateChart" withArguments:params];
}

- (void) setBackgroundColor:(CWColor*)color {
    NSString *colorString = [color toJsonColor];
    NSArray* params = @[self.name, colorString];
    [self callJavaScriptMethod:@"setChartBackgroundColor" withArguments:params];
//    [self callJavaScriptMethod:@"setBackgroundColor" withArguments:@[colorString]];
}

- (void) removeChart {
	NSArray* params = @[self.name];
	[self callJavaScriptMethod:@"deleteChart" withArguments:params];
}

- (void) addChart {
//	NSString* dataJSON = [ls JSON];
//	id win = [self.webview windowScriptObject];
//	CWLineChartOptions* opt = [[CWLineChartOptions alloc] init];
//	NSString* optJSON = [opt JSON];
//	NSArray* params = @[@"myCanvas",@"600",@"250",dataJSON,optJSON];
//	
//	id res = [win callWebScriptMethod:@"addLineChart" withArguments:params];
//	
//	NSLog(@"Result is:%@",res);
	
}

@end
