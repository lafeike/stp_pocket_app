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

#import "UITabBar+Markup.h"
#import "UITabBarItem+Markup.h"
#import "NSObject+Markup.h"
#import "UIView+Markup.h"

static NSDictionary *tabBarItemPositioningValues;

static NSString * const kItemTag = @"item";

static NSString * const kItemTypeKey = @"type";
static NSString * const kItemTitleKey = @"title";
static NSString * const kItemImageKey = @"image";
static NSString * const kItemSelectedImageKey = @"selectedImage";
static NSString * const kItemNameKey = @"name";

@implementation UITabBar (Markup)

+ (void)initialize
{
    tabBarItemPositioningValues = @{
        @"automatic": @(UITabBarItemPositioningAutomatic),
        @"fill": @(UITabBarItemPositioningFill),
        @"centered": @(UITabBarItemPositioningCentered)
    };
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"itemPositioning"]) {
        value = [tabBarItemPositioningValues objectForKey:value];
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    if ([tag isEqual:kItemTag]) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:[self items]];

        UITabBarItem *item = nil;

        NSString *type = [properties objectForKey:kItemTypeKey];

        if (type != nil) {
            UITabBarSystemItem tabBarSystemItem;
            if ([type isEqual:@"more"]) {
                tabBarSystemItem = UITabBarSystemItemMore;
            } else if ([type isEqual:@"favorites"]) {
                tabBarSystemItem = UITabBarSystemItemFavorites;
            } else if ([type isEqual:@"featured"]) {
                tabBarSystemItem = UITabBarSystemItemFeatured;
            } else if ([type isEqual:@"topRated"]) {
                tabBarSystemItem = UITabBarSystemItemTopRated;
            } else if ([type isEqual:@"recents"]) {
                tabBarSystemItem = UITabBarSystemItemRecents;
            } else if ([type isEqual:@"contacts"]) {
                tabBarSystemItem = UITabBarSystemItemContacts;
            } else if ([type isEqual:@"history"]) {
                tabBarSystemItem = UITabBarSystemItemHistory;
            } else if ([type isEqual:@"bookmarks"]) {
                tabBarSystemItem = UITabBarSystemItemBookmarks;
            } else if ([type isEqual:@"search"]) {
                tabBarSystemItem = UITabBarSystemItemSearch;
            } else if ([type isEqual:@"downloads"]) {
                tabBarSystemItem = UITabBarSystemItemDownloads;
            } else if ([type isEqual:@"mostRecent"]) {
                tabBarSystemItem = UITabBarSystemItemMostRecent;
            } else if ([type isEqual:@"mostViewed"]) {
                tabBarSystemItem = UITabBarSystemItemMostViewed;
            } else {
                return;
            }

            item = [[UITabBarItem alloc] initWithTabBarSystemItem:tabBarSystemItem tag:0];
        } else {
            NSString *title = [properties objectForKey:kItemTitleKey];
            NSString *image = [properties objectForKey:kItemImageKey];
            NSString *selectedImage = [properties objectForKey:kItemSelectedImageKey];

            item = [[UITabBarItem alloc] initWithTitle:title
                image:(image == nil) ? nil : [UIImage imageNamed:image]
                selectedImage:(selectedImage == nil) ? nil : [UIImage imageNamed:selectedImage]];
        }

        [item setName:[properties objectForKey:kItemNameKey]];

        [items addObject:item];

        [self setItems:items];

        [self sizeToFit];
    } else {
        [super processMarkupElement:tag properties:properties];
    }
}

@end
