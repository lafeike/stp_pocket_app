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

#import "LMTableView.h"
#import "UIView+Markup.h"
#import "UITableView+Markup.h"
#import "UITableViewCell+Markup.h"

static NSString * const kSectionBreakTarget = @"sectionBreak";

static NSString * const kSectionNameTarget = @"sectionName";
static NSString * const kSectionSelectionModeTarget = @"sectionSelectionMode";

static NSString * const kBackgroundViewTarget = @"backgroundView";

static NSString * const kSectionHeaderTag = @"sectionHeader";
static NSString * const kSectionHeaderTitleKey = @"title";

static NSString * const kSectionFooterTag = @"sectionFooter";
static NSString * const kSectionFooterTitleKey = @"title";

static NSString * const kTableHeaderViewTarget = @"tableHeaderView";
static NSString * const kTableFooterViewTarget = @"tableFooterView";

static NSString * const kSectionHeaderViewTarget = @"sectionHeaderView";
static NSString * const kSectionFooterViewTarget = @"sectionFooterView";

#define ESTIMATED_HEIGHT 2

typedef enum {
    kElementDefault,
    kElementBackgroundView,
    kElementTableHeaderView,
    kElementTableFooterView,
    kElementSectionHeaderView,
    kElementSectionFooterView
} __ElementDisposition;

@interface LMTableViewSection : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) LMTableViewSelectionMode selectionMode;

@property (nonatomic) NSString *headerTitle;
@property (nonatomic) NSString *footerTitle;

@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *footerView;

@property (nonatomic, readonly) NSMutableArray *rows;

@end

@implementation LMTableView
{
    NSMutableArray *_sections;

    __ElementDisposition _elementDisposition;
}

+ (LMTableView *)plainTableView
{
    return [[LMTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
}

+ (LMTableView *)groupedTableView
{
    return [[LMTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
}

#define INIT {\
    _sections = [NSMutableArray new];\
    [self setDataSource:self];\
    [self setDelegate:self];\
    if ([self estimatedRowHeight] != UITableViewAutomaticDimension) {\
        [self setEstimatedRowHeight:ESTIMATED_HEIGHT];\
    }\
    if ([self estimatedSectionHeaderHeight] != UITableViewAutomaticDimension) {\
        [self setEstimatedSectionHeaderHeight:ESTIMATED_HEIGHT];\
    }\
    if ([self estimatedSectionFooterHeight] != UITableViewAutomaticDimension) {\
        [self setEstimatedSectionFooterHeight:ESTIMATED_HEIGHT];\
    }\
    [self insertSection:0];\
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];

    if (self) INIT

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];

    if (self) INIT

    return self;
}

- (void)insertSection:(NSInteger)section
{
    [_sections insertObject:[LMTableViewSection new] atIndex:section];
}

- (void)deleteSection:(NSInteger)section
{
    [_sections removeObjectAtIndex:section];
}

- (NSString *)nameForSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] name];
}

- (void)setName:(NSString *)name forSection:(NSInteger)section
{
    [[_sections objectAtIndex:section] setName:name];
}

- (LMTableViewSelectionMode)selectionModeForSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] selectionMode];
}

- (void)setSelectionMode:(LMTableViewSelectionMode)selectionMode forSection:(NSInteger)section
{
    [[_sections objectAtIndex:section] setSelectionMode:selectionMode];
}

- (id)valueForSection:(NSInteger)section
{
    id value = nil;

    for (UITableViewCell *cell in [[_sections objectAtIndex:section] rows]) {
        if ([cell checked]) {
            value = [cell value];

            break;
        }
    }

    return value;
}

- (void)setValue:(nullable id)value forSection:(NSInteger)section
{
    for (UITableViewCell *cell in [[_sections objectAtIndex:section] rows]) {
        [cell setChecked:[[cell value] isEqual:value]];
    }
}

- (NSArray *)valuesForSection:(NSInteger)section
{
    NSMutableArray *values = [NSMutableArray new];

    for (UITableViewCell *cell in [[_sections objectAtIndex:section] rows]) {
        if ([cell checked]) {
            id value = [cell value];

            if (value != nil) {
                [values addObject:value];
            }
        }
    }

    return values;
}

- (void)setValues:(NSArray *)values forSection:(NSInteger)section
{
    for (UITableViewCell *cell in [[_sections objectAtIndex:section] rows]) {
        id value = [cell value];

        if (value != nil) {
            [cell setChecked:[values containsObject:value]];
        }
    }
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] headerTitle];
}

- (void)setTitle:(NSString *)title forHeaderInSection:(NSInteger)section
{
    [[_sections objectAtIndex:section] setHeaderTitle:title];
}

- (NSString *)titleForFooterInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] footerTitle];
}

- (void)setTitle:(NSString *)title forFooterInSection:(NSInteger)section
{
    [[_sections objectAtIndex:section] setFooterTitle:title];
}

- (UIView *)viewForHeaderInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] headerView];
}

- (void)setView:(UIView *)view forHeaderInSection:(NSInteger)section
{
    [[_sections objectAtIndex:section] setHeaderView:view];
}

- (UIView *)viewForFooterInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] footerView];
}

- (void)setView:(UIView *)view forFooterInSection:(NSInteger)section
{
    [[_sections objectAtIndex:section] setFooterView:view];
}

- (void)insertCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[_sections objectAtIndex:[indexPath section]] rows] insertObject:cell atIndex:[indexPath row]];
}

- (void)deleteCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[_sections objectAtIndex:[indexPath section]] rows] removeObjectAtIndex:[indexPath row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_sections objectAtIndex:section] rows] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[_sections objectAtIndex:[indexPath section]] rows] objectAtIndex:[indexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] footerTitle];
}

#if TARGET_OS_IOS
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];

    switch ([self selectionModeForSection:section]) {
        case LMTableViewSelectionModeDefault: {
            // No-op
            break;
        }

        case LMTableViewSelectionModeSingleCheckmark: {
            // Uncheck all cells except for current selection
            NSInteger row = [indexPath row];

            NSArray *rows = [[_sections objectAtIndex:section] rows];

            for (NSUInteger i = 0, n = [rows count]; i < n; i++) {
                [[rows objectAtIndex:i] setChecked:(i == row)];
            }

            [self deselectRowAtIndexPath:indexPath animated:YES];

            break;
        }

        case LMTableViewSelectionModeMultipleCheckmarks: {
            // Toggle check state of current selection
            UITableViewCell *cell = [[[_sections objectAtIndex:section] rows] objectAtIndex:[indexPath row]];

            [cell setChecked:![cell checked]];

            [self deselectRowAtIndexPath:indexPath animated:YES];

            break;
        }
    }
}

#if TARGET_OS_IOS
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @[];
}
#endif

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_sections objectAtIndex:[indexPath section]] selectionMode] != LMTableViewSelectionModeDefault;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] headerView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] footerView];
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    if ([target isEqual:kSectionBreakTarget]) {
        [self insertSection:[self numberOfSectionsInTableView:self]];
    } else if ([target isEqual:kSectionNameTarget]) {
        [self setName:data forSection:[self numberOfSectionsInTableView:self] - 1];
    } else if ([target isEqual:kSectionSelectionModeTarget]) {
        LMTableViewSelectionMode selectionMode;
        if ([data isEqual:@"default"]) {
            selectionMode = LMTableViewSelectionModeDefault;
        } else if ([data isEqual:@"singleCheckmark"]) {
            selectionMode = LMTableViewSelectionModeSingleCheckmark;
        } else if ([data isEqual:@"multipleCheckmarks"]) {
            selectionMode = LMTableViewSelectionModeMultipleCheckmarks;
        } else {
            return;
        }

        [self setSelectionMode: selectionMode forSection:[self numberOfSectionsInTableView:self] - 1];
    } else if ([target isEqual:kBackgroundViewTarget]) {
        _elementDisposition = kElementBackgroundView;
    } else if ([target isEqual:kTableHeaderViewTarget]) {
        _elementDisposition = kElementTableHeaderView;
    } else if ([target isEqual:kTableFooterViewTarget]) {
        _elementDisposition = kElementTableFooterView;
    } else if ([target isEqual:kSectionHeaderViewTarget]) {
        _elementDisposition = kElementSectionHeaderView;
    } else if ([target isEqual:kSectionFooterViewTarget]) {
        _elementDisposition = kElementSectionFooterView;
    } else {
        _elementDisposition = INT_MAX;

        [super processMarkupInstruction:target data:data];
    }
}

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    if ([tag isEqual:kSectionHeaderTag]) {
        NSString *title = [properties objectForKey:kSectionHeaderTitleKey];

        if (title != nil) {
            [self setTitle:title forHeaderInSection:[self numberOfSectionsInTableView:self] - 1];
        }
    } else if ([tag isEqual:kSectionFooterTag]) {
        NSString *title = [properties objectForKey:kSectionFooterTitleKey];

        if (title != nil) {
            [self setTitle:title forFooterInSection:[self numberOfSectionsInTableView:self] - 1];
        }
    } else {
        [super processMarkupElement:tag properties:properties];
    }
}

- (void)appendMarkupElementView:(UIView *)view
{
    NSInteger section = [self numberOfSectionsInTableView:self] - 1;

    switch (_elementDisposition) {
        case kElementDefault: {
            NSInteger row = [self tableView:self numberOfRowsInSection:section];

            [self insertCell:(UITableViewCell *)view forRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];

            break;
        }

        case kElementBackgroundView: {
            [self setBackgroundView:view];

            break;
        }

        case kElementTableHeaderView: {
            [self setTableHeaderView:view];
            
            [view sizeToFit];

            break;
        }

        case kElementTableFooterView: {
            [self setTableFooterView:view];

            [view sizeToFit];

            break;
        }

        case kElementSectionHeaderView: {
            [self setView:view forHeaderInSection:section];

            break;
        }

        case kElementSectionFooterView: {
            [self setView:view forFooterInSection:section];

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

@implementation LMTableViewSection

- (instancetype)init
{
    self = [super init];

    if (self) {
        _selectionMode = LMTableViewSelectionModeDefault;
        
        _rows = [NSMutableArray new];
    }

    return self;
}

@end
