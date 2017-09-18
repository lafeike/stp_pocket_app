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

#import "LMColumnView.h"
#import "LMRowView.h"
#import "UIView+Markup.h"

@implementation LMColumnView

- (void)setVerticalAlignment:(LMVerticalAlignment)verticalAlignment
{
    if (verticalAlignment == LMVerticalAlignmentCenter) {
        [NSException raise:NSInvalidArgumentException format:@"Invalid vertical alignment."];
    }

    [super setVerticalAlignment:verticalAlignment];
}

- (void)setAlignToGrid:(BOOL)alignToGrid
{
    _alignToGrid = alignToGrid;

    [self setNeedsUpdateConstraints];
}

- (void)layoutSubviews
{
    LMHorizontalAlignment horizontalAlignment = [self horizontalAlignment];

    for (UIView * subview in _arrangedSubviews) {
        if ([subview isHidden]) {
            continue;
        }

        if (horizontalAlignment == LMHorizontalAlignmentFill) {
            [subview setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            [subview setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        }

        if (isnan([subview weight])) {
            [subview setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [subview setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        } else {
            [subview setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
            [subview setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        }
    }

    [super layoutSubviews];
}

- (NSArray *)createConstraints
{
    NSMutableArray *constraints = [NSMutableArray new];

    NSLayoutAttribute topAttribute, bottomAttribute, leadingAttribute, trailingAttribute;
    if ([self layoutMarginsRelativeArrangement]) {
        topAttribute = NSLayoutAttributeTopMargin;
        bottomAttribute = NSLayoutAttributeBottomMargin;
        leadingAttribute = NSLayoutAttributeLeadingMargin;
        trailingAttribute = NSLayoutAttributeTrailingMargin;
    } else {
        topAttribute = NSLayoutAttributeTop;
        bottomAttribute = NSLayoutAttributeBottom;
        leadingAttribute = NSLayoutAttributeLeading;
        trailingAttribute = NSLayoutAttributeTrailing;
    }

    LMHorizontalAlignment horizontalAlignment = [self horizontalAlignment];
    LMVerticalAlignment verticalAlignment = [self verticalAlignment];

    CGFloat leadingSpacing = [self leadingSpacing];
    CGFloat trailingSpacing = [self trailingSpacing];

    CGFloat spacing = [self spacing];

    BOOL alignToBaseline = [self alignToBaseline];

    UIView *previousSubview = nil;
    UIView *previousWeightedSubview = nil;

    for (UIView *subview in _arrangedSubviews) {
        if ([subview isHidden]) {
            continue;
        }

        // Align to siblings
        if (previousSubview == nil) {
            if (verticalAlignment != LMVerticalAlignmentBottom) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:topAttribute
                    multiplier:1 constant:[self topSpacing]]];
            }
        } else {
            if (alignToBaseline) {
                if (isnan(spacing)) {
                    if (@available(iOS 11.0, tvOS 11, *)) {
                        [constraints addObject:[[subview firstBaselineAnchor] constraintEqualToSystemSpacingBelowAnchor:[previousSubview lastBaselineAnchor] multiplier:1]];
                    }
                } else {
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeFirstBaseline
                        relatedBy:NSLayoutRelationEqual toItem:previousSubview attribute:NSLayoutAttributeLastBaseline
                        multiplier:1 constant:spacing]];
                }
            } else {
                if (isnan(spacing)) {
                    if (@available(iOS 11.0, tvOS 11, *)) {
                        [constraints addObject:[[subview topAnchor] constraintEqualToSystemSpacingBelowAnchor:[previousSubview bottomAnchor] multiplier:1]];
                    }
                } else {
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop
                        relatedBy:NSLayoutRelationEqual toItem:previousSubview attribute:NSLayoutAttributeBottom
                        multiplier:1 constant:spacing]];
                }
            }
        }

        CGFloat weight = [subview weight];

        if (!isnan(weight) && isnan([subview height])) {
            if (previousWeightedSubview != nil) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight
                    relatedBy:NSLayoutRelationEqual toItem:previousWeightedSubview attribute:NSLayoutAttributeHeight
                    multiplier:weight / [previousWeightedSubview weight] constant:0]];
            }

            previousWeightedSubview = subview;
        }

        // Align to parent
        switch (horizontalAlignment) {
            case LMHorizontalAlignmentFill: {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:leadingAttribute
                    multiplier:1 constant:leadingSpacing]];
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:trailingAttribute
                    multiplier:1 constant:-trailingSpacing]];

                break;
            }

            case LMHorizontalAlignmentLeading: {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:leadingAttribute
                    multiplier:1 constant:leadingSpacing]];

                break;
            }

            case LMHorizontalAlignmentTrailing: {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:trailingAttribute
                    multiplier:1 constant:-trailingSpacing]];

                break;
            }

            case LMHorizontalAlignmentCenter: {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX
                    relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX
                    multiplier:1 constant:0]];

                break;
            }
        }

        // Align subviews
        if (_alignToGrid && [subview isKindOfClass:[LMRowView self]] && [previousSubview isKindOfClass:[LMRowView self]]) {
            NSArray *nestedSubviews = ((LMLayoutView *)subview)->_arrangedSubviews;
            NSArray *previousNestedSubviews = ((LMLayoutView *)previousSubview)->_arrangedSubviews;

            for (NSUInteger i = 0, n = MIN([nestedSubviews count], [previousNestedSubviews count]); i < n; i++) {
                UIView *nestedSubview = [nestedSubviews objectAtIndex:i];
                UIView *previousNestedSubview = [previousNestedSubviews objectAtIndex:i];

                [constraints addObject:[NSLayoutConstraint constraintWithItem:nestedSubview attribute:NSLayoutAttributeWidth
                    relatedBy:NSLayoutRelationEqual toItem:previousNestedSubview attribute:NSLayoutAttributeWidth
                    multiplier:1 constant:0]];
            }
        }

        previousSubview = subview;
    }

    // Align final view to bottom edge
    if (previousSubview != nil && verticalAlignment != LMVerticalAlignmentTop) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:previousSubview attribute:NSLayoutAttributeBottom
            relatedBy:NSLayoutRelationEqual toItem:self attribute:bottomAttribute
            multiplier:1 constant:-[self bottomSpacing]]];
    }

    return constraints;
}

@end
