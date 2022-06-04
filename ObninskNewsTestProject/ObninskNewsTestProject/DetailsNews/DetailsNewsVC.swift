import Foundation
import UIKit

class DetailsNewsVC: UIViewController {
    
    lazy var collectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
         cv.backgroundColor = .white
         cv.delegate = self
         cv.dataSource = self
         cv.clipsToBounds = true
         return cv
     }()
    
    let viewModel = DetailsNewsViewVM()
    let newsId: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.register(DetailsViewCell.nib(), forCellWithReuseIdentifier: "DetailsViewCell")
    }
    
    init(newsId: String) {
        self.newsId = newsId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailsNewsVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsViewCell", for: indexPath) as? DetailsViewCell else { return UICollectionViewCell() }
        viewModel.parseFromNewsId(id: newsId) { parsedItem, image in
            cell.configure(item: parsedItem, image: image)
        }
        return cell
    }
}
    
extension DetailsNewsVC: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print(indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
    }
}


    extension DetailsNewsVC: UICollectionViewDelegateFlowLayout {
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
     
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
            return 10
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int
        ) -> CGFloat {
            return 0
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt section: Int
        ) -> UIEdgeInsets {
            return UIEdgeInsets(top: UIScreen.main.bounds.height/12, left: 8, bottom: 8, right: 8)
        }
    }


