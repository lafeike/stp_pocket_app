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

#import "LMPickerView.h"
#import "NSObject+Markup.h"
#import "UIView+Markup.h"
#import "UIPickerView+Markup.h"

static NSString * const kComponentSeparatorTarget = @"componentSeparator";
static NSString * const kComponentNameTarget = @"componentName";

static NSString * const kRowTag = @"row";
static NSString * const kRowTitleKey = @"title";
static NSString * const kRowValueKey = @"value";

@interface LMPickerViewRow : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) id value;

- (instancetype)initWithTitle:(NSString *)title value:(id)value;

@end

@interface LMPickerViewComponent : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic, readonly) NSMutableArray *rows;

@end

@implementation LMPickerView
{
    NSMutableArray *_components;
}

#define INIT {\
    _components = [NSMutableArray new];\
    [self setDataSource:self];\
    [self setDelegate:self];\
    [self insertComponent:0];\
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

- (void)insertComponent:(NSInteger)component
{
    [_components insertObject:[LMPickerViewComponent new] atIndex:component];
}

- (void)deleteComponent:(NSInteger)component
{
    [_components removeObjectAtIndex:component];
}

- (NSString *)nameForComponent:(NSInteger)component
{
    return [[_components objectAtIndex:component] name];
}

- (void)setName:(NSString *)name forComponent:(NSInteger)component
{
    [[_components objectAtIndex:component] setName:name];
}

- (void)insertRow:(NSInteger)row inComponent:(NSInteger)component withTitle:(NSString *)title value:(id)value
{
    [[[_components objectAtIndex:component] rows] insertObject:[[LMPickerViewRow alloc] initWithTitle:title value:value] atIndex:row];
}

- (void)deleteRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[[_components objectAtIndex:component] rows] removeObjectAtIndex:row];
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] title];
}

- (void)setTitle:(NSString *)title forRow:(NSInteger)row forComponent:(NSInteger)component
{
    [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] setTitle:title];
}

- (id)valueForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] value];
}

- (void)setValue:(id)value forRow:(NSInteger)row forComponent:(NSInteger)component
{
    [(LMPickerViewRow *)[[[_components objectAtIndex:component] rows] objectAtIndex:row] setValue:value];
}

- (nullable id)valueForComponent:(NSInteger)component
{
    NSInteger row = [self selectedRowInComponent:component];

    return (row == -1) ? nil : [self valueForRow:row forComponent:component];
}

- (void)setValue:(nullable id)value forComponent:(NSInteger)component animated:(BOOL)animated
{
    NSInteger row = -1;

    if (value != nil) {
        for (NSUInteger i = 0, n = [self numberOfRowsInComponent:component]; i < n; i++) {
            if ([[self valueForRow:i forComponent:component] isEqual:value]) {
                row = i;

                break;
            }
        }
    }

    [self selectRow:row inComponent:component animated:animated];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [_components count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[_components objectAtIndex:component] rows] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self titleForRow:row forComponent:component];
}

- (void)processMarkupInstruction:(NSString *)target data:(NSString *)data
{
    if ([target isEqual:kComponentSeparatorTarget]) {
        [self insertComponent:[self numberOfComponents]];
    } else if ([target isEqual:kComponentNameTarget]) {
        [self setName:data forComponent:[self numberOfComponents] - 1];
    } else {
        [super processMarkupInstruction:target data:data];
    }
}

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    if ([tag isEqual:kRowTag]) {
        NSInteger component = [self numberOfComponentsInPickerView:self] - 1;

        NSString *title = [properties objectForKey:kRowTitleKey];

        if (title != nil) {
            [self insertRow:[self pickerView:self numberOfRowsInComponent:component] inComponent:component
                withTitle:title value:[properties objectForKey:kRowValueKey]];
        }
    } else {
        [super processMarkupElement:tag properties:properties];
    }
}

@end

@implementation LMPickerViewRow

- (instancetype)initWithTitle:(NSString *)title value:(id)value
{
    self = [super init];

    if (self) {
        _title = title;
        _value = value;
    }

    return self;
}

@end

@implementation LMPickerViewComponent

- (instancetype)init
{
    self = [super init];

    if (self) {
        _rows = [NSMutableArray new];
    }

    return self;
}

@end

