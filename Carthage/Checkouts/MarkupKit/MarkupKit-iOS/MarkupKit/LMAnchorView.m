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

#import "LMAnchorView.h"
#import "UIView+Markup.h"

@implementation LMAnchorView

- (void)layoutSubviews
{
    // Ensure that subviews resize
    for (UIView *subview in _arrangedSubviews) {
        if ([subview isHidden]) {
            continue;
        }

        LMAnchor anchor = [subview anchor];

        if (anchor & LMAnchorTop && anchor & LMAnchorBottom) {
            [subview setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
            [subview setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        } else {
            [subview setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [subview setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        }

        if ((anchor & LMAnchorLeft && anchor & LMAnchorRight)
            || (anchor & LMAnchorLeading && anchor & LMAnchorTrailing)) {
            [subview setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            [subview setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        } else {
            [subview setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [subview setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        }
    }

    [super layoutSubviews];
}

- (NSArray *)createConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];

    // Align subview edges to anchor view edges
    NSLayoutAttribute topAttribute, bottomAttribute, leftAttribute, rightAttribute, leadingAttribute, trailingAttribute;
    if ([self layoutMarginsRelativeArrangement]) {
        topAttribute = NSLayoutAttributeTopMargin;
        bottomAttribute = NSLayoutAttributeBottomMargin;
        leftAttribute = NSLayoutAttributeLeftMargin;
        rightAttribute = NSLayoutAttributeRightMargin;
        leadingAttribute = NSLayoutAttributeLeadingMargin;
        trailingAttribute = NSLayoutAttributeTrailingMargin;
    } else {
        topAttribute = NSLayoutAttributeTop;
        bottomAttribute = NSLayoutAttributeBottom;
        leftAttribute = NSLayoutAttributeLeft;
        rightAttribute = NSLayoutAttributeRight;
        leadingAttribute = NSLayoutAttributeLeading;
        trailingAttribute = NSLayoutAttributeTrailing;
    }

    CGFloat topSpacing = [self topSpacing];
    CGFloat bottomSpacing = [self bottomSpacing];
    CGFloat leadingSpacing = [self leadingSpacing];
    CGFloat trailingSpacing = [self trailingSpacing];

    for (UIView *subview in _arrangedSubviews) {
        if ([subview isHidden]) {
            continue;
        }

        LMAnchor anchor = [subview anchor];

        if (anchor & LMAnchorTop || anchor & LMAnchorBottom) {
            if (anchor & LMAnchorTop) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:topAttribute
                    multiplier:1 constant:topSpacing]];
            }

            if (anchor & LMAnchorBottom) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:bottomAttribute
                    multiplier:1 constant:-bottomSpacing]];
            }
        } else {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY
                relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY
                multiplier:1 constant:0]];
        }

        if (anchor & LMAnchorLeft || anchor & LMAnchorRight
            || anchor & LMAnchorLeading || anchor & LMAnchorTrailing) {
            if (anchor & LMAnchorLeft) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeft
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:leftAttribute
                    multiplier:1 constant:0]];
            }

            if (anchor & LMAnchorRight) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeRight
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:rightAttribute
                    multiplier:1 constant:0]];
            }

            if (anchor & LMAnchorLeading) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:leadingAttribute
                    multiplier:1 constant:leadingSpacing]];
            }

            if (anchor & LMAnchorTrailing) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:trailingAttribute
                    multiplier:1 constant:-trailingSpacing]];
            }
        } else {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX
                relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX
                multiplier:1 constant:0]];
        }
    }

    return constraints;
}

@end
