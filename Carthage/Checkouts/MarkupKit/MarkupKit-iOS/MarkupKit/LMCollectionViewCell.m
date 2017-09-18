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

#import "LMCollectionViewCell.h"
#import "UIView+Markup.h"

static NSString * const kBackgroundViewTarget = @"backgroundView";
static NSString * const kSelectedBackgroundViewTarget = @"selectedBackgroundView";

typedef enum {
    kElementDefault,
    kElementBackgroundView,
    kElementSelectedBackgroundView
} __ElementDisposition;

@implementation LMCollectionViewCell
{
    __ElementDisposition _elementDisposition;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _layoutMarginsRelativeArrangement = YES;
    }

    return self;
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    if ([target isEqual:kBackgroundViewTarget]) {
        _elementDisposition = kElementBackgroundView;
    } else if ([target isEqual:kSelectedBackgroundViewTarget]) {
        _elementDisposition = kElementSelectedBackgroundView;
    } else {
        _elementDisposition = INT_MAX;

        [super processMarkupInstruction:target data:data];
    }
}

- (void)appendMarkupElementView:(UIView *)view
{
    switch (_elementDisposition) {
        case kElementDefault: {
            [view setTranslatesAutoresizingMaskIntoConstraints:NO];

            [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
            [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

            [view setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
            [view setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];

            UIView *contentView = [self contentView];

            [contentView addSubview:view];

            // Pin content to cell edges
            NSLayoutAttribute topAttribute, bottomAttribute, leftAttribute, rightAttribute;
            if ([self layoutMarginsRelativeArrangement]) {
                topAttribute = NSLayoutAttributeTopMargin;
                bottomAttribute = NSLayoutAttributeBottomMargin;
                leftAttribute = NSLayoutAttributeLeftMargin;
                rightAttribute = NSLayoutAttributeRightMargin;
            } else {
                topAttribute = NSLayoutAttributeTop;
                bottomAttribute = NSLayoutAttributeBottom;
                leftAttribute = NSLayoutAttributeLeft;
                rightAttribute = NSLayoutAttributeRight;
            }

            NSMutableArray *constraints = [NSMutableArray new];

            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                relatedBy:NSLayoutRelationEqual toItem:contentView attribute:topAttribute
                multiplier:1 constant:0]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom
                relatedBy:NSLayoutRelationEqual toItem:contentView attribute:bottomAttribute
                multiplier:1 constant:0]];

            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft
                relatedBy:NSLayoutRelationEqual toItem:contentView attribute:leftAttribute
                multiplier:1 constant:0]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight
                relatedBy:NSLayoutRelationEqual toItem:contentView attribute:rightAttribute
                multiplier:1 constant:0]];

            [NSLayoutConstraint activateConstraints:constraints];

            break;
        }

        case kElementBackgroundView: {
            [self setBackgroundView:view];
            
            break;
        }

        case kElementSelectedBackgroundView: {
            [self setSelectedBackgroundView:view];

            break;
        }

        default: {
            [super appendMarkupElementView:view];

            break;
        }
    }

    _elementDisposition = kElementDefault;
}

@end
