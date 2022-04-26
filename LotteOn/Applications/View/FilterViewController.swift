//
//  FilterViewController.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/25.
//

import UIKit
import SnapKit

class FilterViewController: UIViewController {
    
    private let filterTitleLabel: UILabel = {
        $0.text = "매장"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 20)
        
        return $0
    }(UILabel())
    
    lazy var storeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    
    private let countLabel: UILabel = {
        $0.text = "0개의 상품 보기"
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private let countView: UIView = {
        $0.backgroundColor = .systemRed
        
        return $0
    }(UIView())
    

    public let storeViewModel = FilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        let lotteRightBarItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(didTapRightBarButton))
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 15)]
        self.navigationController?.navigationBar.tintColor = .gray
        self.navigationItem.rightBarButtonItem = lotteRightBarItem
        self.navigationItem.title = "필터"
        
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
        
        [filterTitleLabel,storeCollectionView,countView].forEach {
            view.addSubview($0)
        }
        
        countView.addSubview(countLabel)
        
        filterTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.width.height.equalTo(40)
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterTitleLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        countView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        countLabel.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.centerX.centerY.equalTo(countView)
        }
        
    }
    
    //MARK: Action
    @objc
    private func didTapRightBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Notifications
    public func notificationsDefault(index: Int) {
        let lotteOnList = storeViewModel.selectProductCount(index: index)
        NotificationCenter.default.post(name: .lotteOn, object: lotteOnList)
    }
    
}



extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeViewModel.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.reuseIdentifier, for: indexPath) as? StoreCollectionViewCell else { return UICollectionViewCell() }
        cell.itemBind(storeList: storeViewModel.storeEntities, index: indexPath.item)
        
        cell.storeButtonAction = { [unowned self] in
            notificationsDefault(index: indexPath.item)
            countLabel.text = storeViewModel.productCount! + "개의 상품 보기"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (storeViewModel.storeEntities.name[indexPath.row] as NSString).size(withAttributes: [.font : UIFont.systemFont(ofSize: 17)]).width + 25
        return CGSize(width: size, height: 30)
    }
}
