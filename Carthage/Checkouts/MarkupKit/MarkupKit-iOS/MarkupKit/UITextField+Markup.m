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

#import "UITextField+Markup.h"
#import "NSObject+Markup.h"
#import "UIView+Markup.h"

#import <objc/message.h>

static NSString * const kLeftViewTarget = @"leftView";
static NSString * const kRightViewTarget = @"rightView";
static NSString * const kInputViewTarget = @"inputView";
static NSString * const kInputAccessoryViewTarget = @"inputAccessoryView";

typedef enum {
    kElementLeftView,
    kElementRightView,
    kElementInputView,
    kElementInputAccessoryView
} __ElementDisposition;

static NSDictionary *textBorderStyleValues;
static NSDictionary *textFieldViewModeValues;

#define ELEMENT_DISPOSITION_KEY @encode(__ElementDisposition)

@implementation UITextField (Markup)

+ (void)initialize
{
    textBorderStyleValues = @{
        @"none": @(UITextBorderStyleNone),
        @"line": @(UITextBorderStyleLine),
        @"bezel": @(UITextBorderStyleBezel),
        @"roundedRect": @(UITextBorderStyleRoundedRect)
    };

    textFieldViewModeValues = @{
        @"never": @(UITextFieldViewModeNever),
        @"whileEditing": @(UITextFieldViewModeWhileEditing),
        @"unlessEditing": @(UITextFieldViewModeUnlessEditing),
        @"always": @(UITextFieldViewModeAlways)
    };
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"borderStyle"]) {
        value = [textBorderStyleValues objectForKey:value];
    } else if ([key isEqual:@"clearButtonMode"] || [key isEqual:@"leftViewMode"] || [key isEqual:@"rightViewMode"]) {
        value = [textFieldViewModeValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    __ElementDisposition elementDisposition;
    if ([target isEqual:kLeftViewTarget]) {
        elementDisposition = kElementLeftView;
    } else if ([target isEqual:kRightViewTarget]) {
        elementDisposition = kElementRightView;
    } else if ([target isEqual:kInputViewTarget]) {
        elementDisposition = kElementInputView;
    } else if ([target isEqual:kInputAccessoryViewTarget]) {
        elementDisposition = kElementInputAccessoryView;
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
            case kElementLeftView: {
                [view sizeToFit];

                [self setLeftView:view];

                break;
            }

            case kElementRightView: {
                [view sizeToFit];

                [self setRightView:view];

                break;
            }

            case kElementInputView: {
                [self setInputView:view];
                
                break;
            }

            case kElementInputAccessoryView: {
                [self setInputAccessoryView:view];
                
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
