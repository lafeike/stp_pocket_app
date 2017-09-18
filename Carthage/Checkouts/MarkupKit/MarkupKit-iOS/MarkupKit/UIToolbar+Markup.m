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

#import "UIToolbar+Markup.h"
#import "UIView+Markup.h"

static NSString * const kItemTag = @"item";

static NSString * const kItemTypeKey = @"type";
static NSString * const kItemTitleKey = @"title";
static NSString * const kItemImageKey = @"image";

static NSString * const kItemActionKey = @"action";

@implementation UIToolbar (Markup)

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    if ([tag isEqual:kItemTag]) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:[self items]];

        SEL action = NSSelectorFromString([properties objectForKey:kItemActionKey]);

        UIBarButtonItem *item = nil;

        NSString *type = [properties objectForKey:kItemTypeKey];

        if (type != nil) {
            UIBarButtonSystemItem barButtonSystemItem;
            if ([type isEqual:@"done"]) {
                barButtonSystemItem = UIBarButtonSystemItemDone;
            } else if ([type isEqual:@"cancel"]) {
                barButtonSystemItem = UIBarButtonSystemItemCancel;
            } else if ([type isEqual:@"edit"]) {
                barButtonSystemItem = UIBarButtonSystemItemEdit;
            } else if ([type isEqual:@"save"]) {
                barButtonSystemItem = UIBarButtonSystemItemSave;
            } else if ([type isEqual:@"add"]) {
                barButtonSystemItem = UIBarButtonSystemItemAdd;
            } else if ([type isEqual:@"flexibleSpace"]) {
                barButtonSystemItem = UIBarButtonSystemItemFlexibleSpace;
            } else if ([type isEqual:@"fixedSpace"]) {
                barButtonSystemItem = UIBarButtonSystemItemFixedSpace;
            } else if ([type isEqual:@"compose"]) {
                barButtonSystemItem = UIBarButtonSystemItemCompose;
            } else if ([type isEqual:@"reply"]) {
                barButtonSystemItem = UIBarButtonSystemItemReply;
            } else if ([type isEqual:@"action"]) {
                barButtonSystemItem = UIBarButtonSystemItemAction;
            } else if ([type isEqual:@"organize"]) {
                barButtonSystemItem = UIBarButtonSystemItemOrganize;
            } else if ([type isEqual:@"bookmarks"]) {
                barButtonSystemItem = UIBarButtonSystemItemBookmarks;
            } else if ([type isEqual:@"search"]) {
                barButtonSystemItem = UIBarButtonSystemItemSearch;
            } else if ([type isEqual:@"refresh"]) {
                barButtonSystemItem = UIBarButtonSystemItemRefresh;
            } else if ([type isEqual:@"stop"]) {
                barButtonSystemItem = UIBarButtonSystemItemStop;
            } else if ([type isEqual:@"camera"]) {
                barButtonSystemItem = UIBarButtonSystemItemCamera;
            } else if ([type isEqual:@"trash"]) {
                barButtonSystemItem = UIBarButtonSystemItemTrash;
            } else if ([type isEqual:@"play"]) {
                barButtonSystemItem = UIBarButtonSystemItemPlay;
            } else if ([type isEqual:@"pause"]) {
                barButtonSystemItem = UIBarButtonSystemItemPause;
            } else if ([type isEqual:@"rewind"]) {
                barButtonSystemItem = UIBarButtonSystemItemRewind;
            } else if ([type isEqual:@"fastForward"]) {
                barButtonSystemItem = UIBarButtonSystemItemFastForward;
            } else if ([type isEqual:@"undo"]) {
                barButtonSystemItem = UIBarButtonSystemItemUndo;
            } else if ([type isEqual:@"redo"]) {
                barButtonSystemItem = UIBarButtonSystemItemRedo;
            } else if ([type isEqual:@"pageCurl"]) {
                barButtonSystemItem = UIBarButtonSystemItemPageCurl;
            } else {
                return;
            }

            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:barButtonSystemItem
                target:nil action:action];
        } else {
            NSString *title = [properties objectForKey:kItemTitleKey];

            if (title != nil) {
                item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain
                    target:nil action:action];
            } else {
                NSString *image = [properties objectForKey:kItemImageKey];

                if (image != nil) {
                    item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:UIBarButtonItemStylePlain
                        target:nil action:action];
                }
            }
        }

        if (item != nil) {
            [items addObject:item];
        }

        [self setItems:items];

        [self sizeToFit];
    } else {
        [super processMarkupElement:tag properties:properties];
    }
}

@end
