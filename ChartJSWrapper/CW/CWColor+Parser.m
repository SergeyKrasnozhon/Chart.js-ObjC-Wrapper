//
//  CWColor+Parser.m
//  MoneySpace
//
//  Created by Sergey on 10/30/15.
//  Copyright © 2015 MKGroup. All rights reserved.
//

#import "CWColor+Parser.h"

@implementation CWColor (Parser)
-(NSString*)toJsonColor{
#if TARGET_OS_IPHONE
    CGFloat fr;
    CGFloat fg;
    CGFloat fb;
    CGFloat fa;
    [self getRed:&fr green:&fg blue:&fb alpha:&fa];
    int r = (fr*255.0f);
    int g = (fg*255.0f);
    int b = (fb*255.0f);
    CGFloat a = fa;
#else
    CWColor* c = [self colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
    int r = (c.redComponent*255.0f);
    int g = (c.greenComponent*255.0f);
    int b = (c.blueComponent*255.0f);
    CGFloat a = (c.alphaComponent);
#endif
    NSString* jsonColor = [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)",r,g,b,a];
    return jsonColor;
}
@end
