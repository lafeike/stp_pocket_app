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

#import "UIStackView+Markup.h"
#import "NSObject+Markup.h"

static NSDictionary *layoutConstraintAxisValues;
static NSDictionary *stackViewAlignmentValues;
static NSDictionary *stackViewDistributionValues;

@implementation UIStackView (Markup)

+ (void)initialize
{
    layoutConstraintAxisValues = @{
        @"horizontal": @(UILayoutConstraintAxisHorizontal),
        @"vertical": @(UILayoutConstraintAxisVertical)
    };

    stackViewAlignmentValues = @{
        @"fill": @(UIStackViewAlignmentFill),
        @"leading": @(UIStackViewAlignmentLeading),
        @"top": @(UIStackViewAlignmentTop),
        @"firstBaseline": @(UIStackViewAlignmentFirstBaseline),
        @"center": @(UIStackViewAlignmentCenter),
        @"trailing": @(UIStackViewAlignmentTrailing),
        @"bottom": @(UIStackViewAlignmentBottom),
        @"lastBaseline": @(UIStackViewAlignmentLastBaseline)
    };

    stackViewDistributionValues = @{
        @"fill": @(UIStackViewDistributionFill),
        @"fillEqually": @(UIStackViewDistributionFillEqually),
        @"fillProportionally": @(UIStackViewDistributionFillProportionally),
        @"equalSpacing": @(UIStackViewDistributionEqualSpacing),
        @"equalCentering": @(UIStackViewDistributionEqualSpacing)
    };
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"axis"]) {
        value = [layoutConstraintAxisValues objectForKey:value];
    } else if ([key isEqual:@"alignment"]) {
        value = [stackViewAlignmentValues objectForKey:value];
    } else if ([key isEqual:@"distribution"]) {
        value = [stackViewDistributionValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

- (void)appendMarkupElementView:(UIView *)view
{
    [self addArrangedSubview:view];
}

@end
