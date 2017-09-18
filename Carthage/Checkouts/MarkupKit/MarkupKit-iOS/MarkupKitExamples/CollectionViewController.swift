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

class CollectionViewController: UICollectionViewController {
    let colors = [
        "#ffffff", "#c0c0c0", "#808080", "#000000",
        "#ff0000", "#800000", "#ffff00", "#808080",
        "#00ff00", "#008000", "#00ffff", "#008080",
        "#0000ff", "#000080", "#ff00ff", "#800080"
    ]

    override func loadView() {
        collectionView = LMViewBuilder.view(withName: "CollectionViewController", owner: self, root: nil) as? UICollectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Collection View"

        edgesForExtendedLayout = UIRectEdge()

        collectionView!.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.description())
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.description(), for: indexPath) as! ColorCell

        let index = indexPath.item
        let value = colors[index]

        cell.index = String(index)
        cell.color = LMViewBuilder.colorValue(value)
        cell.value = value

        return cell
    }
}
