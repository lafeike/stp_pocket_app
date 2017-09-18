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

class IncludesViewController: UIViewController {
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!

    override func loadView() {
        view = LMViewBuilder.view(withName: "IncludesViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Includes"

        edgesForExtendedLayout = UIRectEdge()

        firstLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
        secondLabel.text = "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
        thirdLabel.text = "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"
    }
}
