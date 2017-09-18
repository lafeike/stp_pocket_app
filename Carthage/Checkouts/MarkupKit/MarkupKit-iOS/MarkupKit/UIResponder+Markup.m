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

#import "UIResponder+Markup.h"

#import <objc/message.h>

@interface LMBinding : NSObject

@property (weak, nonatomic, readonly) id owner;
@property (nonatomic, readonly) NSString *property;

@property (weak, nonatomic, readonly) UIView *view;
@property (nonatomic, readonly) NSString *keyPath;

- (instancetype)initWithOwner:(id)owner property:(NSString *)property view:(UIView *)view keyPath:(NSString *)keyPath;

@end

@implementation UIResponder (Markup)

- (NSBundle *)bundleForView
{
    return [NSBundle bundleForClass:[self class]];
}

- (NSBundle *)bundleForImages
{
    return [NSBundle mainBundle];
}

- (NSBundle *)bundleForStrings
{
    return [NSBundle mainBundle];
}

- (NSString *)tableForStrings
{
    return nil;
}

- (void)bind:(NSString *)property toView:(UIView *)view withKeyPath:(NSString *)keyPath
{
    LMBinding *binding = [[LMBinding alloc] initWithOwner:self property:property view:view keyPath:keyPath];

    [self addObserver:binding forKeyPath:property options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];

    [[self bindings] addObject:binding];
}

- (void)unbindAll
{
    NSMutableArray *bindings = [self bindings];

    for (LMBinding *binding in bindings) {
        [self removeObserver:binding forKeyPath:[binding property] context:nil];
    }

    [bindings removeAllObjects];
}

- (NSMutableArray *)bindings
{
    NSMutableArray *bindings = objc_getAssociatedObject(self, @selector(bindings));

    if (bindings == nil) {
        bindings = [NSMutableArray new];

        objc_setAssociatedObject(self, @selector(bindings), bindings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return bindings;
}

@end

@implementation LMBinding

- (instancetype)initWithOwner:(id)owner property:(NSString *)property view:(UIView *)view keyPath:(NSString *)keyPath
{
    self = [super init];

    if (self) {
        _owner = owner;
        _property = property;

        _view = view;
        _keyPath = keyPath;
    }

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id value = [change objectForKey:NSKeyValueChangeNewKey];

    if (value != nil && value != [NSNull null]) {
        [_view setValue:value forKeyPath:_keyPath];
    }
}

@end
