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

#import "UIImageView+Markup.h"
#import "UIView+Markup.h"

#import <objc/message.h>

static NSString * const kOverlayContentTarget = @"overlayContent";

typedef enum {
    kOverlayContent
} __ElementDisposition;

#define ELEMENT_DISPOSITION_KEY @encode(__ElementDisposition)

@implementation UIImageView (Markup)

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    __ElementDisposition elementDisposition;
    if ([target isEqual:kOverlayContentTarget]) {
        elementDisposition = kOverlayContent;
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
            case kOverlayContent: {
                #if TARGET_OS_TV
                if (@available(tvOS 11, *)) {
                    [view setTranslatesAutoresizingMaskIntoConstraints:NO];

                    [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
                    [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

                    [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
                    [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

                    UIView *overlayContentView = [self overlayContentView];

                    [overlayContentView addSubview:view];

                    // Pin overlay content to image view edges
                    NSMutableArray *constraints = [NSMutableArray new];

                    [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                        relatedBy:NSLayoutRelationEqual toItem:overlayContentView attribute:NSLayoutAttributeTopMargin
                        multiplier:1 constant:0]];
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom
                        relatedBy:NSLayoutRelationEqual toItem:overlayContentView attribute:NSLayoutAttributeBottomMargin
                        multiplier:1 constant:0]];

                    [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft
                        relatedBy:NSLayoutRelationEqual toItem:overlayContentView attribute:NSLayoutAttributeLeftMargin
                        multiplier:1 constant:0]];
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight
                        relatedBy:NSLayoutRelationEqual toItem:overlayContentView attribute:NSLayoutAttributeRightMargin
                        multiplier:1 constant:0]];

                    [NSLayoutConstraint activateConstraints:constraints];
                }
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
