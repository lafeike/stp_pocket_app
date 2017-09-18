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

#import "UIButton+Markup.h"

@implementation UIButton (Markup)

+ (UIButton *)systemButton
{
    return [UIButton buttonWithType:UIButtonTypeSystem];
}

+ (UIButton *)detailDisclosureButton
{
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

+ (UIButton *)infoLightButton
{
    return [UIButton buttonWithType:UIButtonTypeInfoLight];
}

+ (UIButton *)infoDarkButton
{
    return [UIButton buttonWithType:UIButtonTypeInfoDark];
}

+ (UIButton *)contactAddButton
{
    return [UIButton buttonWithType:UIButtonTypeContactAdd];
}

+ (UIButton *)plainButton
{
    return [UIButton buttonWithType:UIButtonTypePlain];
}

- (NSString *)title
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (UIColor *)titleColor
{
    return [self titleColorForState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (UIColor *)titleShadowColor
{
    return [self titleShadowColorForState:UIControlStateNormal];
}

- (void)setTitleShadowColor:(UIColor *)titleShadowColor
{
    [self setTitleShadowColor:titleShadowColor forState:UIControlStateNormal];
}

- (NSAttributedString *)attributedTitle
{
    return [self attributedTitleForState:UIControlStateNormal];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle
{
    [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

- (UIImage *)image
{
    return [self imageForState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (UIImage *)backgroundImage
{
    return [self backgroundImageForState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (CGFloat)contentEdgeInsetTop
{
    return [self contentEdgeInsets].top;
}

- (void)setContentEdgeInsetTop:(CGFloat)top
{
    UIEdgeInsets contentEdgeInsets = [self contentEdgeInsets];

    contentEdgeInsets.top = top;

    [self setContentEdgeInsets:contentEdgeInsets];
}

- (CGFloat)contentEdgeInsetLeft
{
    return [self contentEdgeInsets].left;
}

- (void)setContentEdgeInsetLeft:(CGFloat)left
{
    UIEdgeInsets contentEdgeInsets = [self contentEdgeInsets];

    contentEdgeInsets.left = left;

    [self setContentEdgeInsets:contentEdgeInsets];
}

- (CGFloat)contentEdgeInsetBottom
{
    return [self contentEdgeInsets].bottom;
}

- (void)setContentEdgeInsetBottom:(CGFloat)bottom
{
    UIEdgeInsets contentEdgeInsets = [self contentEdgeInsets];

    contentEdgeInsets.bottom = bottom;

    [self setContentEdgeInsets:contentEdgeInsets];
}

- (CGFloat)contentEdgeInsetRight
{
    return [self contentEdgeInsets].right;
}

- (void)setContentEdgeInsetRight:(CGFloat)right
{
    UIEdgeInsets contentEdgeInsets = [self contentEdgeInsets];

    contentEdgeInsets.right = right;

    [self setContentEdgeInsets:contentEdgeInsets];
}

- (CGFloat)titleEdgeInsetTop
{
    return [self titleEdgeInsets].top;
}

- (void)setTitleEdgeInsetTop:(CGFloat)top
{
    UIEdgeInsets titleEdgeInsets = [self titleEdgeInsets];

    titleEdgeInsets.top = top;

    [self setTitleEdgeInsets:titleEdgeInsets];
}

- (CGFloat)titleEdgeInsetLeft
{
    return [self titleEdgeInsets].left;
}

- (void)setTitleEdgeInsetLeft:(CGFloat)left
{
    UIEdgeInsets titleEdgeInsets = [self titleEdgeInsets];

    titleEdgeInsets.left = left;

    [self setTitleEdgeInsets:titleEdgeInsets];
}

- (CGFloat)titleEdgeInsetBottom
{
    return [self titleEdgeInsets].bottom;
}

- (void)setTitleEdgeInsetBottom:(CGFloat)bottom
{
    UIEdgeInsets titleEdgeInsets = [self titleEdgeInsets];

    titleEdgeInsets.bottom = bottom;

    [self setTitleEdgeInsets:titleEdgeInsets];
}

- (CGFloat)titleEdgeInsetRight
{
    return [self titleEdgeInsets].right;
}

- (void)setTitleEdgeInsetRight:(CGFloat)right
{
    UIEdgeInsets titleEdgeInsets = [self titleEdgeInsets];

    titleEdgeInsets.right = right;

    [self setTitleEdgeInsets:titleEdgeInsets];
}

- (CGFloat)imageEdgeInsetTop
{
    return [self imageEdgeInsets].top;
}

- (void)setImageEdgeInsetTop:(CGFloat)top
{
    UIEdgeInsets imageEdgeInsets = [self imageEdgeInsets];

    imageEdgeInsets.top = top;

    [self setImageEdgeInsets:imageEdgeInsets];
}

- (CGFloat)imageEdgeInsetLeft
{
    return [self imageEdgeInsets].left;
}

- (void)setImageEdgeInsetLeft:(CGFloat)left
{
    UIEdgeInsets imageEdgeInsets = [self imageEdgeInsets];

    imageEdgeInsets.left = left;

    [self setImageEdgeInsets:imageEdgeInsets];
}

- (CGFloat)imageEdgeInsetBottom
{
    return [self imageEdgeInsets].bottom;
}

- (void)setImageEdgeInsetBottom:(CGFloat)bottom
{
    UIEdgeInsets imageEdgeInsets = [self imageEdgeInsets];

    imageEdgeInsets.bottom = bottom;

    [self setImageEdgeInsets:imageEdgeInsets];
}

- (CGFloat)imageEdgeInsetRight
{
    return [self imageEdgeInsets].right;
}

- (void)setImageEdgeInsetRight:(CGFloat)right
{
    UIEdgeInsets imageEdgeInsets = [self imageEdgeInsets];

    imageEdgeInsets.right = right;

    [self setImageEdgeInsets:imageEdgeInsets];
}

@end
