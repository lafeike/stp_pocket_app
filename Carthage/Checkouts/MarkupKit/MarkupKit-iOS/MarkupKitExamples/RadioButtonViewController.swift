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

class RadioButtonViewController: UITableViewController {
    let sizeSectionName = "sizes"

    override func loadView() {
        view = LMViewBuilder.view(withName: "RadioButtonViewController", owner: self, root: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Radio Buttons"

        tableView.setValue("L", forSection: tableView.section(withName: sizeSectionName))
    }

    @IBAction func submit() {
        let value = tableView.value(forSection: tableView.section(withName: sizeSectionName)) as! String

        let message = String(format: "You selected %@.", value)

        let alertController = UIAlertController(title: "Submitted", message: message, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true)
    }
}
