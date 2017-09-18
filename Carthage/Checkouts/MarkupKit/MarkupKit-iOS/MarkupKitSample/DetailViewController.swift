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

/**
 * Detail view.
 */
class DetailViewController: UIViewController {
    // Outlets
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!

    // View initialization
    override func loadView() {
        view = LMViewBuilder.view(withName: "DetailViewController", owner: self, root: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let layoutView = view as! LMLayoutView

        layoutView.topSpacing = topLayoutGuide.length
        layoutView.bottomSpacing = bottomLayoutGuide.length
    }

    // Done button press handler
    @IBAction func doneButtonPressed() {
        dismiss(animated: true)
    }
}

