import Foundation
import UIKit

class MainNewsVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var viewModel: MainNewsVM!
    var newsCategoriesView: NewsCategoriesView!
    var isPerfomedOnce = false
    var skipCount = 0
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let header = UIImage(named: "HeaderName")?.resizeImageTo(size: imageView.frame.size)
        imageView.image = header?.withRenderingMode(.alwaysTemplate)
        
        navigationItem.titleView = imageView
        
        let rightBarButtonImage = UIImage(named: "CalendaryIcon")?.resizeImageTo(size: CGSize(width: 30, height: header?.size.height ?? 0))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    override func viewDidLoad() {
        
        newsCategoriesView = NewsCategoriesView(viewWidth: UIScreen.main.bounds.width, viewHeight: UIScreen.main.bounds.height/8, onAllNewsClicked: { [weak self] in
            self?.viewModel.showMode = "all"
            self?.isPerfomedOnce = false
            self?.viewModel.imageModel.imageArray = [:]
            self?.viewModel.getParsedData(limit: 10, skip: 0, isReloaded: true, completion: {
                DispatchQueue.main.async {
                self?.collectionView.reloadData()
                }
            })
            
        }, onBreakingNewsClicked: { [weak self] in
            self?.viewModel.showMode = "hot"
            self?.isPerfomedOnce = false
            self?.viewModel.imageModel.imageArray = [:]
            self?.viewModel.getParsedData(limit: 10, skip: 0, isReloaded: true, completion: {
                DispatchQueue.main.async {
                self?.collectionView.reloadData()
                }
            })
        })
        
        collectionView.addSubview(newsCategoriesView)
        
        viewModel = MainNewsVM(onModelChanges: { [weak self] in
            DispatchQueue.main.async {
                self?.performBatch()
            }
        })
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5)
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MainNewsCell.nib(), forCellWithReuseIdentifier: "MainNewsCell")
        collectionView.register(MainNewsCellBig.nib(), forCellWithReuseIdentifier: "MainNewsCellBig")
        
        viewModel.getParsedData(limit: 10, skip: 0, isReloaded: false, completion: {})
    }
    
    func performBatch() {
        var previousRowCount: Int
        if isPerfomedOnce == false {
           previousRowCount = 1
            isPerfomedOnce = true
        } else {
            previousRowCount = viewModel.countOfNewsArray - 10
        }
        collectionView.performBatchUpdates {
            let indexes = (previousRowCount - 1...previousRowCount + 8)
            .map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: indexes)
        }
    }
    
    @objc
    func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        print("clicked")
    }
}
 
extension MainNewsVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfNewsArray
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if indexPath.row == 0 && viewModel.showMode == "all"{
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "MainNewsCellBig", for: indexPath) as! MainNewsCellBig
            viewModel.getDataToCell(
                indexPath: indexPath.row,
                completion: { newsPost in
                    cell.configure(newsObject: newsPost)
            })
            cell.cellIdentifier = viewModel.getImageToCell(indexPath: indexPath.row) { image, identifier in
                cell.setImage(image: image, identifier: identifier)
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainNewsCell", for: indexPath) as! MainNewsCell
            viewModel.getDataToCell(
                indexPath: indexPath.row,
                completion: { newsPost in
                    cell.configure(newsObject: newsPost)
            })
            cell.cellIdentifier = viewModel.getImageToCell(indexPath: indexPath.row) { image, identifier in
                cell.setImage(image: image, identifier: identifier)
            }
            return cell
        }
    }
    
}

extension MainNewsVC: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print(indexPath.row)
        guard viewModel.newsArrey[indexPath.row] != nil else { return }

        var cellItem = viewModel.newsArrey[indexPath.row]
        print(cellItem.id)
        let detailsNews = DetailsNewsVC(newsId: cellItem.id)
        self.navigationController?.pushViewController(detailsNews, animated: true)
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard indexPath.row > viewModel.countOfNewsArray - 5 else { return }
        skipCount += 10
        viewModel.getParsedData(limit: 10, skip: skipCount, isReloaded: false,  completion: {})
    }
}


extension MainNewsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.row == 0 && viewModel.showMode == "all" {
            return CGSize(width: UIScreen.main.bounds.width-15, height: UIScreen.main.bounds.height/2.25)
        } else {
            return CGSize(width: UIScreen.main.bounds.width-15, height: UIScreen.main.bounds.height/5)
        }
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



