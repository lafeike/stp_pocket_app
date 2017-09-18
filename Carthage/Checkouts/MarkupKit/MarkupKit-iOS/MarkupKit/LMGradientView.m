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

#import "LMGradientView.h"
#import "NSObject+Markup.h"
#import "LMViewBuilder.h"

@implementation LMGradientView
{
    CGGradientRef _gradient;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }

    return self;
}

- (void)dealloc
{
    CGGradientRelease(_gradient);
}

- (void)setColors:(NSArray *)colors
{
    _colors = [colors copy];

    [self setNeedsDisplay];
}

- (void)setLocations:(NSArray *)locations
{
    _locations = [locations copy];

    [self setNeedsDisplay];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];

    CGGradientRelease(_gradient);

    _gradient = nil;
}

- (void)drawRect:(CGRect)rect
{
    if (_colors != nil) {
        if (_gradient == nil) {
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

            NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:[_colors count]];

            for (UIColor *color in _colors) {
                [colors addObject:(id)[color CGColor]];
            }

            if (_locations == nil) {
                _gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, nil);
            } else {
                CGFloat locations[[_locations count]];

                int i = 0;

                for (NSNumber *location in _locations) {
                    locations[i++] = [location floatValue];
                }

                _gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
            }

            CGColorSpaceRelease(colorSpace);
        }

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSaveGState(context);
        CGContextAddRect(context, rect);
        CGContextClip(context);

        [self drawGradient:_gradient withContext:context];

        CGContextRestoreGState(context);
    }
}

- (void)drawGradient:(CGGradientRef)gradient withContext:(CGContextRef)context {
    // No-op
}

- (void)applyMarkupPropertyValue:(id)value forKey:(NSString *)key
{
    if ([key isEqual:@"colors"] && [value isKindOfClass:[NSString self]]) {
        NSArray *components = [value componentsSeparatedByString:@","];

        NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:[components count]];

        for (NSString *component in components) {
            [colors addObject:[LMViewBuilder colorValue:[component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
        }

        value = colors;
    } else if ([key isEqual:@"locations"] && [value isKindOfClass:[NSString self]]) {
        NSArray *components = [value componentsSeparatedByString:@","];

        NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:[components count]];

        for (NSString *component in components) {
            [locations addObject:[NSNumber numberWithFloat:[component floatValue]]];
        }

        value = locations;
    }

    [super applyMarkupPropertyValue:value forKey:key];
}

@end
