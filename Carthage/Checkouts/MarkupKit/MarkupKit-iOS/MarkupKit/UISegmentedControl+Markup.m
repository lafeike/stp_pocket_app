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

#import "UISegmentedControl+Markup.h"
#import "UIView+Markup.h"

static NSString * const kSegmentTag = @"segment";
static NSString * const kSegmentTitleKey = @"title";
static NSString * const kSegmentImageKey = @"image";

@implementation UISegmentedControl (Markup)

- (void)processMarkupElement:(NSString *)tag properties:(NSDictionary *)properties
{
    if ([tag isEqual:kSegmentTag]) {
        NSUInteger index = [self numberOfSegments];

        NSString *title = [properties objectForKey:kSegmentTitleKey];

        if (title != nil) {
            [self insertSegmentWithTitle:title atIndex:index animated:NO];
        } else {
            NSString *image = [properties objectForKey:kSegmentImageKey];

            if (image != nil) {
                [self insertSegmentWithImage:[UIImage imageNamed:image] atIndex:index animated:NO];
            }
        }
    } else {
        [super processMarkupElement:tag properties:properties];
    }
}

@end
