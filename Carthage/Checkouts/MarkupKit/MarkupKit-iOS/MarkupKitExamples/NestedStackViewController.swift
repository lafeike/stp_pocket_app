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

class NestedStackViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var middleNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!

    override func loadView() {
        view = LMViewBuilder.view(withName: "NestedStackViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nested Stack Views"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain,
            target: self, action: #selector(done))

        edgesForExtendedLayout = UIRectEdge()

        // Create custom constraints
        NSLayoutConstraint.activate([
            // Image view aspect ratio
            NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.height,
                multiplier: 1.0, constant: 0),

            // Equal text field widths
            NSLayoutConstraint(item: middleNameTextField, attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal, toItem: firstNameTextField, attribute: NSLayoutAttribute.width,
                multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: lastNameTextField, attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal, toItem: middleNameTextField, attribute: NSLayoutAttribute.width,
                multiplier: 1.0, constant: 0)
        ])
    }

    @objc func done() {
        navigationController!.popToRootViewController(animated: true)
    }
}
