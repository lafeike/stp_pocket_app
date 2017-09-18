//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "UIScrollView+Markup.h"
#import "NSObject+Markup.h"
#import "UIView+Markup.h"

#import <objc/message.h>

static NSString * const kRefreshControlTarget = @"refreshControl";

typedef enum {
    kElementRefreshControl
} __ElementDisposition;

static NSDictionary *scrollViewIndicatorStyleValues;
static NSDictionary *scrollViewKeyboardDismissModeValues;
static NSDictionary *scrollViewContentInsetAdjustmentBehaviorValues;

#define ELEMENT_DISPOSITION_KEY @encode(__ElementDisposition)

@implementation UIScrollView (Markup)

+ (void)initialize
{
    scrollViewIndicatorStyleValues = @{
        @"default": @(UIScrollViewIndicatorStyleDefault),
        @"black": @(UIScrollViewIndicatorStyleBlack),
        @"white": @(UIScrollViewIndicatorStyleWhite)
    };

    scrollViewKeyboardDismissModeValues = @{
        @"none": @(UIScrollViewKeyboardDismissModeNone),
        @"onDrag": @(UIScrollViewKeyboardDismissModeOnDrag),
        @"interactive": @(UIScrollViewKeyboardDismissModeInteractive)
    };

    if (@available(iOS 11, tvOS 11, *)) {
        scrollViewContentInsetAdjustmentBehaviorValues = @{
            @"automatic": @(UIScrollViewContentInsetAdjustmentAutomatic),
            @"scrollableAxes": @(UIScrollViewContentInsetAdjustmentScrollableAxes),
            @"never": @(UIScrollViewContentInsetAdjustmentNever),
            @"always": @(UIScrollViewContentInsetAdjustmentAlways)
        };
    }
}

- (CGFloat)contentInsetTop
{
    return [self contentInset].top;
}

- (void)setContentInsetTop:(CGFloat)top
{
    UIEdgeInsets contentInset = [self contentInset];

    contentInset.top = top;

    [self setContentInset:contentInset];
}

- (CGFloat)contentInsetLeft
{
    return [self contentInset].left;
}

- (void)setContentInsetLeft:(CGFloat)left
{
    UIEdgeInsets contentInset = [self contentInset];

    contentInset.left = left;

    [self setContentInset:contentInset];
}

- (CGFloat)contentInsetBottom
{
    return [self contentInset].bottom;
}

- (void)setContentInsetBottom:(CGFloat)bottom
{
    UIEdgeInsets contentInset = [self contentInset];

    contentInset.bottom = bottom;

    [self setContentInset:contentInset];
}

- (CGFloat)contentInsetRight
{
    return [self contentInset].right;
}

- (void)setContentInsetRight:(CGFloat)right
{
    UIEdgeInsets contentInset = [self contentInset];

    contentInset.right = right;

    [self setContentInset:contentInset];
}

- (NSInteger)currentPage
{
    return (NSInteger)([self contentOffset].x / [self bounds].size.width);
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [self setCurrentPage:currentPage animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake([self bounds].size.width * currentPage, 0) animated:animated];
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"indicatorStyle"]) {
        value = [scrollViewIndicatorStyleValues objectForKey:value];
    } else if ([key isEqual:@"keyboardDismissMode"]) {
        value = [scrollViewKeyboardDismissModeValues objectForKey:value];
    } else if ([key isEqual:@"contentInsetAdjustmentBehavior"]) {
        value = [scrollViewContentInsetAdjustmentBehaviorValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    __ElementDisposition elementDisposition;
    if ([target isEqual:kRefreshControlTarget]) {
        elementDisposition = kElementRefreshControl;
    } else {
        elementDisposition = INT_MAX;

        [super processMarkupInstruction:target data:data];
    }

    objc_setAssociatedObject(self, ELEMENT_DISPOSITION_KEY, [NSNumber numberWithInt:elementDisposition], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)appendMarkupElementView:(UIView *)view
{
    NSNumber *elementDisposition = objc_getAssociatedObject(self, ELEMENT_DISPOSITION_KEY);

    if (elementDisposition != nil) {
        switch ([elementDisposition intValue]) {
            case kElementRefreshControl: {
                #if TARGET_OS_IOS
                [self setRefreshControl:(UIRefreshControl *)view];
                #endif

                break;
            }

            default: {
                [super appendMarkupElementView:view];

                break;
            }
        }
    }

    objc_setAssociatedObject(self, ELEMENT_DISPOSITION_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
