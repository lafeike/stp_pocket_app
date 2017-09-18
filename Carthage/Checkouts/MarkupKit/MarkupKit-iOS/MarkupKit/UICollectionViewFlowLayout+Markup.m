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

#import "UICollectionViewFlowLayout+Markup.h"
#import "NSObject+Markup.h"

static NSDictionary *collectionViewScrollDirectionValues;
static NSDictionary *collectionViewFlowLayoutSectionInsetReferenceValues;

@implementation UICollectionViewFlowLayout (Markup)

+ (void)initialize
{
    collectionViewScrollDirectionValues = @{
        @"vertical": @(UICollectionViewScrollDirectionVertical),
        @"horizontal": @(UICollectionViewScrollDirectionHorizontal)
    };

    if (@available(iOS 11, tvOS 11, *)) {
        collectionViewFlowLayoutSectionInsetReferenceValues = @{
            @"fromContentInset": @(UICollectionViewFlowLayoutSectionInsetFromContentInset),
            @"fromSafeArea": @(UICollectionViewFlowLayoutSectionInsetFromSafeArea),
            @"fromLayoutMargins": @(UICollectionViewFlowLayoutSectionInsetFromLayoutMargins)
        };
    }
}

- (CGFloat)itemWidth
{
    return [self itemSize].width;
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    [self setItemSize:CGSizeMake(itemWidth, [self itemSize].height)];
}

- (CGFloat)itemHeight
{
    return [self itemSize].height;
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    [self setItemSize:CGSizeMake([self itemSize].width, itemHeight)];
}

- (CGFloat)estimatedItemWidth
{
    return [self estimatedItemSize].width;
}

- (void)setEstimatedItemWidth:(CGFloat)estimatedItemWidth
{
    [self setEstimatedItemSize:CGSizeMake(estimatedItemWidth, [self estimatedItemSize].height)];
}

- (CGFloat)estimatedItemHeight
{
    return [self estimatedItemSize].height;
}

- (void)setEstimatedItemHeight:(CGFloat)estimatedItemHeight
{
    [self setEstimatedItemSize:CGSizeMake([self estimatedItemSize].width, estimatedItemHeight)];
}

- (CGFloat)sectionInsetTop
{
    return [self sectionInset].top;
}

- (void)setSectionInsetTop:(CGFloat)top
{
    UIEdgeInsets sectionInset = [self sectionInset];

    sectionInset.top = top;

    [self setSectionInset:sectionInset];
}

- (CGFloat)sectionInsetLeft
{
    return [self sectionInset].left;
}

- (void)setSectionInsetLeft:(CGFloat)left
{
    UIEdgeInsets sectionInset = [self sectionInset];

    sectionInset.left = left;

    [self setSectionInset:sectionInset];
}

- (CGFloat)sectionInsetBottom
{
    return [self sectionInset].bottom;
}

- (void)setSectionInsetBottom:(CGFloat)bottom
{
    UIEdgeInsets sectionInset = [self sectionInset];

    sectionInset.bottom = bottom;

    [self setSectionInset:sectionInset];
}

- (CGFloat)sectionInsetRight
{
    return [self sectionInset].right;
}

- (void)setSectionInsetRight:(CGFloat)right
{
    UIEdgeInsets sectionInset = [self sectionInset];

    sectionInset.right = right;

    [self setSectionInset:sectionInset];
}

- (CGFloat)headerReferenceWidth
{
    return [self headerReferenceSize].width;
}

- (void)setHeaderReferenceWidth:(CGFloat)headerReferenceWidth
{
    [self setHeaderReferenceSize:CGSizeMake(headerReferenceWidth, [self headerReferenceSize].height)];
}

- (CGFloat)headerReferenceHeight
{
    return [self headerReferenceSize].height;
}

- (void)setHeaderReferenceHeight:(CGFloat)headerReferenceHeight
{
    [self setHeaderReferenceSize:CGSizeMake([self headerReferenceSize].width, headerReferenceHeight)];
}

- (CGFloat)footerReferenceWidth
{
    return [self footerReferenceSize].width;
}

- (void)setFooterReferenceWidth:(CGFloat)footerReferenceWidth
{
    [self setFooterReferenceSize:CGSizeMake(footerReferenceWidth, [self footerReferenceSize].height)];
}

- (CGFloat)footerReferenceHeight
{
    return [self footerReferenceSize].height;
}

- (void)setFooterReferenceHeight:(CGFloat)footerReferenceHeight
{
    [self setFooterReferenceSize:CGSizeMake([self footerReferenceSize].width, footerReferenceHeight)];
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"scrollDirection"]) {
        value = [collectionViewScrollDirectionValues objectForKey:value];
    } else if ([key isEqual:@"sectionInset"]) {
        CGFloat inset = [value floatValue];

        value = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(inset, inset, inset, inset)];
    } else if ([key isEqual:@"sectionInsetReference"]) {
        value = [collectionViewFlowLayoutSectionInsetReferenceValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

@end
