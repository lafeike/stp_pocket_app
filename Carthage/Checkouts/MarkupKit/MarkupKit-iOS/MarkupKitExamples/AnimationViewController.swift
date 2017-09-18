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

class AnimationViewController: UIViewController {
    @IBOutlet var detailView: LMColumnView!
    @IBOutlet var detailSwitch: UISwitch!

    override func loadView() {
        view = LMViewBuilder.view(withName:"AnimationViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Animation"

        edgesForExtendedLayout = UIRectEdge()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        detailView.height = 0
    }

    @IBAction func toggleDetail() {
        view.layoutIfNeeded()

        detailView.height = detailSwitch.isOn ? 175 : 0

        UIView.animate(withDuration: 0.33, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
