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

#import "LMLayoutView.h"
#import "UIView+Markup.h"

#define DEFAULT_LAYOUT_MARGINS UIEdgeInsetsZero

#define HIDDEN_KEY "hidden"

@implementation LMLayoutView
{
    NSArray *_constraints;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#define INIT {\
    _arrangedSubviews = [NSMutableArray new];\
    _layoutMarginsRelativeArrangement = YES;\
    [self setLayoutMargins:DEFAULT_LAYOUT_MARGINS];\
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) INIT

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];

    if (self) INIT

    return self;
}

- (NSArray *)arrangedSubviews
{
    return [_arrangedSubviews copy];
}

- (void)addArrangedSubview:(UIView *)view
{
    [self insertArrangedSubview:view atIndex:[_arrangedSubviews count]];
}

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)index
{
    if ([_arrangedSubviews indexOfObject:view] == NSNotFound) {
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self addSubview:view];

        [_arrangedSubviews insertObject:view atIndex:index];

        [view addObserver:self forKeyPath:@HIDDEN_KEY options:0 context:nil];

        [self setNeedsUpdateConstraints];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"View is already an arranged subview."];
    }
}

- (void)removeArrangedSubview:(UIView *)view
{
    NSUInteger index = [_arrangedSubviews indexOfObject:view];

    if (index != NSNotFound) {
        [view removeObserver:self forKeyPath:@HIDDEN_KEY];

        [_arrangedSubviews removeObjectAtIndex:index];

        [self setNeedsUpdateConstraints];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@HIDDEN_KEY]) {
        [self setNeedsUpdateConstraints];
    }
}

- (void)willRemoveSubview:(UIView *)subview
{
    [self removeArrangedSubview:subview];

    [super willRemoveSubview:subview];
}

- (void)setLayoutMarginsRelativeArrangement:(BOOL)layoutMarginsRelativeArrangement
{
    _layoutMarginsRelativeArrangement = layoutMarginsRelativeArrangement;

    [self setNeedsUpdateConstraints];
}

- (void)setTopSpacing:(CGFloat)topSpacing
{
    _topSpacing = topSpacing;

    [self setNeedsUpdateConstraints];
}

- (void)setBottomSpacing:(CGFloat)bottomSpacing
{
    _bottomSpacing = bottomSpacing;

    [self setNeedsUpdateConstraints];
}

- (void)setLeadingSpacing:(CGFloat)leadingSpacing
{
    _leadingSpacing = leadingSpacing;

    [self setNeedsUpdateConstraints];
}

- (void)setTrailingSpacing:(CGFloat)trailingSpacing
{
    _trailingSpacing = trailingSpacing;

    [self setNeedsUpdateConstraints];
}

- (UIView *)viewForBaselineLayout
{
    return ([_arrangedSubviews count] == 0) ? [super viewForBaselineLayout] : [[_arrangedSubviews firstObject] viewForBaselineLayout];
}

- (UIView *)viewForFirstBaselineLayout
{
    return ([_arrangedSubviews count] == 0) ? [super viewForFirstBaselineLayout] : [[_arrangedSubviews firstObject] viewForFirstBaselineLayout];
}

- (UIView *)viewForLastBaselineLayout
{
    return ([_arrangedSubviews count] == 0) ? [super viewForLastBaselineLayout] : [[_arrangedSubviews lastObject] viewForLastBaselineLayout];
}

- (void)setNeedsUpdateConstraints
{
    if (_constraints != nil) {
        [NSLayoutConstraint deactivateConstraints:_constraints];

        _constraints = nil;
    }

    if ([_arrangedSubviews count] == 0) {
        return;
    }

    [super setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    if (_constraints == nil) {
        _constraints = [self createConstraints];

        if (_constraints != nil) {
            [NSLayoutConstraint activateConstraints:_constraints];
        }
    }

    [super updateConstraints];
}

- (NSArray *)createConstraints
{
    return nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];

    if (view == self && [self backgroundColor] == nil) {
        view = nil;
    }

    return view;
}

- (void)appendMarkupElementView:(UIView *)view
{
    [self addArrangedSubview:view];
}

@end
