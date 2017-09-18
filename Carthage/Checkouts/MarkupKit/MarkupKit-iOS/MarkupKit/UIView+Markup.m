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

#import "UIView+Markup.h"
#import "NSObject+Markup.h"
#import "LMViewBuilder.h"

#import <objc/message.h>

static NSDictionary *viewContentModeValues;
static NSDictionary *viewTintAdjustmentModeValues;
static NSDictionary *lineBreakModeValues;
static NSDictionary *textAlignmentValues;
static NSDictionary *textAutocapitalizationTypeValues;
static NSDictionary *textAutocorrectionTypeValues;
static NSDictionary *textSpellCheckingTypeValues;
static NSDictionary *textSmartQuotesTypeValues;
static NSDictionary *textSmartDashesTypeValues;
static NSDictionary *textSmartInsertDeleteTypeValues;
static NSDictionary *keyboardTypeValues;
static NSDictionary *keyboardAppearanceValues;
static NSDictionary *returnKeyTypeValues;
static NSDictionary *barStyleValues;

static NSDictionary *anchorValues;

@implementation UIView (Markup)

+ (void)initialize
{
    viewContentModeValues = @{
        @"scaleToFill": @(UIViewContentModeScaleToFill),
        @"scaleAspectFit": @(UIViewContentModeScaleAspectFit),
        @"scaleAspectFill": @(UIViewContentModeScaleAspectFill),
        @"redraw": @(UIViewContentModeRedraw),
        @"center": @(UIViewContentModeCenter),
        @"top": @(UIViewContentModeTop),
        @"bottom": @(UIViewContentModeBottom),
        @"left": @(UIViewContentModeLeft),
        @"right": @(UIViewContentModeRight),
        @"topLeft": @(UIViewContentModeTopLeft),
        @"topRight": @(UIViewContentModeTopRight),
        @"bottomLeft": @(UIViewContentModeBottomLeft),
        @"bottomRight": @(UIViewContentModeBottomRight)
    };

    viewTintAdjustmentModeValues = @{
        @"automatic": @(UIViewTintAdjustmentModeAutomatic),
        @"normal": @(UIViewTintAdjustmentModeNormal),
        @"dimmed": @(UIViewTintAdjustmentModeDimmed)
    };

    lineBreakModeValues = @{
        @"byWordWrapping": @(NSLineBreakByWordWrapping),
        @"byCharWrapping": @(NSLineBreakByCharWrapping),
        @"byClipping": @(NSLineBreakByClipping),
        @"byTruncatingHead": @(NSLineBreakByTruncatingHead),
        @"byTruncatingTail": @(NSLineBreakByTruncatingTail),
        @"byTruncatingMiddle": @(NSLineBreakByTruncatingMiddle)
    };

    textAlignmentValues = @{
        @"left": @(NSTextAlignmentLeft),
        @"center": @(NSTextAlignmentCenter),
        @"right": @(NSTextAlignmentRight),
        @"justified": @(NSTextAlignmentJustified),
        @"natural": @(NSTextAlignmentNatural)
    };

    textAutocapitalizationTypeValues = @{
        @"none": @(UITextAutocapitalizationTypeNone),
        @"words": @(UITextAutocapitalizationTypeWords),
        @"sentences": @(UITextAutocapitalizationTypeSentences),
        @"allCharacters": @(UITextAutocapitalizationTypeAllCharacters)
    };

    textAutocorrectionTypeValues = @{
        @"default": @(UITextAutocorrectionTypeDefault),
        @"yes": @(UITextAutocorrectionTypeYes),
        @"no": @(UITextAutocorrectionTypeNo)
    };

    textSpellCheckingTypeValues = @{
        @"default": @(UITextSpellCheckingTypeDefault),
        @"yes": @(UITextSpellCheckingTypeYes),
        @"no": @(UITextSpellCheckingTypeNo)
    };

    if (@available(iOS 11.0, tvOS 11, *)) {
        textSmartQuotesTypeValues = @{
            @"default": @(UITextSmartQuotesTypeDefault),
            @"no": @(UITextSmartQuotesTypeNo),
            @"yes": @(UITextSmartQuotesTypeYes)
        };

        textSmartDashesTypeValues = @{
            @"default": @(UITextSmartDashesTypeDefault),
            @"no": @(UITextSmartDashesTypeNo),
            @"yes": @(UITextSmartDashesTypeYes)
        };

        textSmartInsertDeleteTypeValues = @{
            @"default": @(UITextSmartInsertDeleteTypeDefault),
            @"no": @(UITextSmartInsertDeleteTypeNo),
            @"yes": @(UITextSmartInsertDeleteTypeYes)
        };
    };

    keyboardTypeValues = @{
        @"default": @(UIKeyboardTypeDefault),
        @"ASCIICapable": @(UIKeyboardTypeASCIICapable),
        @"numbersAndPunctuation": @(UIKeyboardTypeNumbersAndPunctuation),
        @"URL": @(UIKeyboardTypeURL),
        @"numberPad": @(UIKeyboardTypeNumberPad),
        @"phonePad": @(UIKeyboardTypePhonePad),
        @"namePhonePad": @(UIKeyboardTypeNamePhonePad),
        @"emailAddress": @(UIKeyboardTypeEmailAddress),
        @"decimalPad": @(UIKeyboardTypeDecimalPad),
        @"twitter": @(UIKeyboardTypeTwitter),
        @"webSearch": @(UIKeyboardTypeWebSearch)
    };

    keyboardAppearanceValues = @{
        @"default": @(UIKeyboardAppearanceDefault),
        @"dark": @(UIKeyboardAppearanceDark),
        @"light": @(UIKeyboardAppearanceLight)
    };

    returnKeyTypeValues = @{
        @"default": @(UIReturnKeyDefault),
        @"go": @(UIReturnKeyGo),
        @"google": @(UIReturnKeyGoogle),
        @"join": @(UIReturnKeyJoin),
        @"next": @(UIReturnKeyNext),
        @"route": @(UIReturnKeyRoute),
        @"search": @(UIReturnKeySearch),
        @"send": @(UIReturnKeySend),
        @"yahoo": @(UIReturnKeyYahoo),
        @"done": @(UIReturnKeyDone),
        @"emergencyCall": @(UIReturnKeyEmergencyCall)
    };

    barStyleValues = @{
        #if TARGET_OS_IOS
        @"default": @(UIBarStyleDefault),
        @"black": @(UIBarStyleBlack)
        #endif
    };

    anchorValues = @{
        @"none": @(LMAnchorNone),
        @"top": @(LMAnchorTop),
        @"bottom": @(LMAnchorBottom),
        @"left": @(LMAnchorLeft),
        @"right": @(LMAnchorRight),
        @"leading": @(LMAnchorLeading),
        @"trailing": @(LMAnchorTrailing),
        @"all": @(LMAnchorAll)
    };
}

- (CGFloat)width
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(width));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setWidth:(CGFloat)width
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(width));

    [constraint setActive:NO];

    if (!isnan(width)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1 constant:width];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(width), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)minimumWidth
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(minimumWidth));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setMinimumWidth:(CGFloat)minimumWidth
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(minimumWidth));

    [constraint setActive:NO];

    if (!isnan(minimumWidth)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1 constant:minimumWidth];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(minimumWidth), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)maximumWidth
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(maximumWidth));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setMaximumWidth:(CGFloat)maximumWidth
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(maximumWidth));

    [constraint setActive:NO];

    if (!isnan(maximumWidth)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1 constant:maximumWidth];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(maximumWidth), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)height
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(height));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setHeight:(CGFloat)height
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(height));

    [constraint setActive:NO];

    if (!isnan(height)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
            relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1 constant:height];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(height), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)minimumHeight
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(minimumHeight));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setMinimumHeight:(CGFloat)minimumHeight
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(minimumHeight));

    [constraint setActive:NO];

    if (!isnan(minimumHeight)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
            relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1 constant:minimumHeight];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(minimumHeight), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)maximumHeight
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(maximumHeight));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setMaximumHeight:(CGFloat)maximumHeight
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(maximumHeight));

    [constraint setActive:NO];

    if (!isnan(maximumHeight)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
            relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1 constant:maximumHeight];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(maximumHeight), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)aspectRatio
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(aspectRatio));

    return (constraint == nil) ? NAN : [constraint constant];
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    NSLayoutConstraint *constraint = objc_getAssociatedObject(self, @selector(aspectRatio));

    [constraint setActive:NO];

    if (!isnan(aspectRatio)) {
        constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight
            multiplier:aspectRatio constant:0];
    } else {
        constraint = nil;
    }

    [constraint setActive:YES];

    objc_setAssociatedObject(self, @selector(aspectRatio), constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)weight
{
    NSNumber *weight = objc_getAssociatedObject(self, @selector(weight));

    return (weight == nil) ? NAN : [weight floatValue];
}

- (void)setWeight:(CGFloat)weight
{
    objc_setAssociatedObject(self, @selector(weight), isnan(weight) ? nil : [NSNumber numberWithFloat:weight],
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [[self superview] setNeedsUpdateConstraints];
}

- (LMAnchor)anchor
{
    NSNumber *anchor = objc_getAssociatedObject(self, @selector(anchor));

    return (anchor == nil) ? 0 : [anchor unsignedIntegerValue];
}

- (void)setAnchor:(LMAnchor)anchor
{
    objc_setAssociatedObject(self, @selector(anchor), [NSNumber numberWithUnsignedInteger:anchor],
        OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [[self superview] setNeedsUpdateConstraints];
}

- (CGFloat)layoutMarginTop
{
    return [self layoutMargins].top;
}

- (void)setLayoutMarginTop:(CGFloat)top
{
    UIEdgeInsets layoutMargins = [self layoutMargins];

    layoutMargins.top = top;

    [self setLayoutMargins:layoutMargins];
}

- (CGFloat)layoutMarginLeft
{
    return [self layoutMargins].left;
}

- (void)setLayoutMarginLeft:(CGFloat)left
{
    UIEdgeInsets layoutMargins = [self layoutMargins];

    layoutMargins.left = left;

    [self setLayoutMargins:layoutMargins];
}

- (CGFloat)layoutMarginBottom
{
    return [self layoutMargins].bottom;
}

- (void)setLayoutMarginBottom:(CGFloat)bottom
{
    UIEdgeInsets layoutMargins = [self layoutMargins];

    layoutMargins.bottom = bottom;

    [self setLayoutMargins:layoutMargins];
}

- (CGFloat)layoutMarginRight
{
    return [self layoutMargins].right;
}

- (void)setLayoutMarginRight:(CGFloat)right
{
    UIEdgeInsets layoutMargins = [self layoutMargins];

    layoutMargins.right = right;

    [self setLayoutMargins:layoutMargins];
}

- (CGFloat)layoutMarginLeading
{
    CGFloat leading;
    if (@available(iOS 11, tvOS 11, *)) {
        leading = [self directionalLayoutMargins].leading;
    } else {
        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:[self semanticContentAttribute]] == UIUserInterfaceLayoutDirectionLeftToRight) {
            leading = [self layoutMargins].left;
        } else {
            leading = [self layoutMargins].right;
        }
    }

    return leading;
}

- (void)setLayoutMarginLeading:(CGFloat)leading
{
    if (@available(iOS 11, tvOS 11, *)) {
        NSDirectionalEdgeInsets directionalLayoutMargins = [self directionalLayoutMargins];

        directionalLayoutMargins.leading = leading;

        [self setDirectionalLayoutMargins:directionalLayoutMargins];
    } else {
        UIEdgeInsets layoutMargins = [self layoutMargins];

        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:[self semanticContentAttribute]] == UIUserInterfaceLayoutDirectionLeftToRight) {
            layoutMargins.left = leading;
        } else {
            layoutMargins.right = leading;
        }

        [self setLayoutMargins:layoutMargins];
    }
}

- (CGFloat)layoutMarginTrailing
{
    CGFloat trailing;
    if (@available(iOS 11, tvOS 11, *)) {
        trailing = [self directionalLayoutMargins].trailing;
    } else {
        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:[self semanticContentAttribute]] == UIUserInterfaceLayoutDirectionLeftToRight) {
            trailing = [self layoutMargins].right;
        } else {
            trailing = [self layoutMargins].left;
        }
    }

    return trailing;
}

- (void)setLayoutMarginTrailing:(CGFloat)trailing
{
    if (@available(iOS 11, tvOS 11, *)) {
        NSDirectionalEdgeInsets directionalLayoutMargins = [self directionalLayoutMargins];

        directionalLayoutMargins.trailing = trailing;

        [self setDirectionalLayoutMargins:directionalLayoutMargins];
    } else {
        UIEdgeInsets layoutMargins = [self layoutMargins];

        if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:[self semanticContentAttribute]] == UIUserInterfaceLayoutDirectionLeftToRight) {
            layoutMargins.right = trailing;
        } else {
            layoutMargins.left = trailing;
        }

        [self setLayoutMargins:layoutMargins];
    }
}

- (CGFloat)horizontalContentCompressionResistancePriority
{
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setHorizontalContentCompressionResistancePriority:(CGFloat)priority
{
    [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
}

- (CGFloat)horizontalContentHuggingPriority
{
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setHorizontalContentHuggingPriority:(CGFloat)priority
{
    [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
}

- (CGFloat)verticalContentCompressionResistancePriority
{
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
}

- (void)setVerticalContentCompressionResistancePriority:(CGFloat)priority
{
    [self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
}

- (CGFloat)verticalContentHuggingPriority
{
    return [self contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical];
}

- (void)setVerticalContentHuggingPriority:(CGFloat)priority
{
    [self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"contentMode"]) {
        value = [viewContentModeValues objectForKey:value];
    } else if ([key isEqual:@"tintAdjustmentMode"]) {
        value = [viewTintAdjustmentModeValues objectForKey:value];
    } else if ([key isEqual:@"lineBreakMode"]) {
        value = [lineBreakModeValues objectForKey:value];
    } else if ([key isEqual:@"textAlignment"]) {
        value = [textAlignmentValues objectForKey:value];
    } else if ([key isEqual:@"autocapitalizationType"]) {
        value = [textAutocapitalizationTypeValues objectForKey:value];

        if (value != nil) {
            [(UIView<UITextInputTraits> *)self setAutocapitalizationType:[value integerValue]];
        }

        return;
    } else if ([key isEqual:@"autocorrectionType"]) {
        value = [textAutocorrectionTypeValues objectForKey:value];

        if (value != nil) {
            [(UIView<UITextInputTraits> *)self setAutocorrectionType:[value integerValue]];
        }

        return;
    } else if ([key isEqual:@"spellCheckingType"]) {
        value = [textSpellCheckingTypeValues objectForKey:value];

        if (value != nil) {
            [(UIView<UITextInputTraits> *)self setSpellCheckingType:[value integerValue]];
        }

        return;
    } else if ([key isEqual:@"smartQuotesType"]) {
        value = [textSmartQuotesTypeValues objectForKey:value];

        if (value != nil) {
            if (@available(iOS 11.0, tvOS 11, *)) {
                [(UIView<UITextInputTraits> *)self setSmartQuotesType:[value integerValue]];
            }
        }

        return;
    } else if ([key isEqual:@"smartDashesType"]) {
        value = [textSmartDashesTypeValues objectForKey:value];

        if (value != nil) {
            if (@available(iOS 11.0, tvOS 11, *)) {
                [(UIView<UITextInputTraits> *)self setSmartDashesType:[value integerValue]];
            }
        }

        return;
    } else if ([key isEqual:@"smartInsertDeleteType"]) {
        value = [textSmartInsertDeleteTypeValues objectForKey:value];

        if (value != nil) {
            if (@available(iOS 11.0, tvOS 11, *)) {
                [(UIView<UITextInputTraits> *)self setSmartInsertDeleteType:[value integerValue]];
            }
        }

        return;
    } else if ([key isEqual:@"keyboardType"]) {
        value = [keyboardTypeValues objectForKey:value];

        if (value != nil) {
            [(UIView<UITextInputTraits> *)self setKeyboardType:[value integerValue]];
        }

        return;
    } else if ([key isEqual:@"keyboardAppearance"]) {
        value = [keyboardAppearanceValues objectForKey:value];

        if (value != nil) {
            [(UIView<UITextInputTraits> *)self setKeyboardAppearance:[value integerValue]];
        }

        return;
    } else if ([key isEqual:@"returnKeyType"]) {
        value = [returnKeyTypeValues objectForKey:value];

        if (value != nil) {
            [(UIView<UITextInputTraits> *)self setReturnKeyType:[value integerValue]];
        }

        return;
    } else if ([key isEqual:@"barStyle"]) {
        value = [barStyleValues objectForKey:value];
    } else if ([key isEqual:@"layoutMargins"] || [key rangeOfString:@"^.*Insets?$"
        options:NSRegularExpressionSearch].location != NSNotFound) {
        CGFloat inset = [value floatValue];

        value = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
    } else if ([key rangeOfString:@"^(?:horizontal|vertical)Content(?:CompressionResistance|Hugging)Priority$"
        options:NSRegularExpressionSearch].location != NSNotFound) {
        if ([value isEqual:@"required"]) {
            value = @(UILayoutPriorityRequired);
        } else if ([value isEqual:@"defaultHigh"]) {
            value = @(UILayoutPriorityDefaultHigh);
        } else if ([value isEqual:@"defaultLow"]) {
            value = @(UILayoutPriorityDefaultLow);
        } else if ([value isEqual:@"fittingSizeLevel"]) {
            value = @(UILayoutPriorityFittingSizeLevel);
        }
    } else if ([key isEqual:@"anchor"]) {
        NSArray *components = [value componentsSeparatedByString:@","];

        LMAnchor anchor = LMAnchorNone;

        for (NSString *component in components) {
            NSString *name = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            anchor |= [[anchorValues objectForKey:name] unsignedIntegerValue];
        }

        value = @(anchor);
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    // No-op
}

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    // No-op
}

- (void)appendMarkupElementView:(UIView *)view
{
    // No-op
}

@end
