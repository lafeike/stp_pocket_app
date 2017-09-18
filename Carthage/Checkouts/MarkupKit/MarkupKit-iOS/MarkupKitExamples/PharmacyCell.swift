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

import UIKit
import MarkupKit

class PharmacyCell: LMTableViewCell {
    @objc dynamic var name: String?
    @objc dynamic var distance: String?
    @objc dynamic var address: String?
    @objc dynamic var phone: String?
    @objc dynamic var fax: String?
    @objc dynamic var email: String?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        LMViewBuilder.view(withName: "PharmacyCell", owner: self, root: self)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    deinit {
        unbindAll()
    }
}
