//
//  ViewController.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import UIKit
import SnapKit
import RxSwift


class ViewController: UIViewController {

    //MARK: Property
    
    private var listTotalCountLabel: UILabel = {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private var lotteRankFilterButton: UIButton = {
        $0.setTitle("롯데ON 랭킹순", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.setImage(UIImage(named: "downArrow"), for: .normal)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 5
        return $0
    }(UIButton())
    
    private var lotteAllFilterButton: UIButton = {
        $0.setTitle("필터", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 5
        
        return $0
    }(UIButton())
    

    lazy var lotteCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.itemSize = CGSize(width: (view.frame.width  - 20) / 2, height: 250)
        flowLayout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(LotteCollectionViewCell.self, forCellWithReuseIdentifier: LotteCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    public var viewModel: ViewModel = ViewModel(lotteShopUseCase: DefaultLotteShopUseCase(lotteRepository: DefaultShopListRepository()))
    private let disposeBag: DisposeBag = DisposeBag()
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
        notificationDefault()
    }
    
    
    //MARK: Configure
    
    private func bind() {
        viewModel.bindTotalCount { [weak self] count in
            self?.listTotalCountLabel.text = "총 " + count + " 개"
        }
        
        lotteRankFilterButton
            .rx.tap
            .bind(to: viewModel.didTapRankFilter)
            .disposed(by: disposeBag)
        
        
        viewModel.didTapRankFilter
            .withUnretained(self)
            .subscribe { vc, _ in
                let filterVC = ProductSortPanModalView()
                filterVC.modalPresentationStyle = .overFullScreen
                vc.present(filterVC, animated: false, completion: nil)
            }.disposed(by: disposeBag)
        
    }
    
    private func configure() {
        view.backgroundColor = .white
        lotteCollectionView.backgroundColor = .white
        lotteCollectionView.delegate = self
        lotteCollectionView.dataSource = self
        lotteCollectionView.prefetchDataSource = self
        
        
        [listTotalCountLabel,lotteRankFilterButton,lotteCollectionView,lotteAllFilterButton].forEach {
            view.addSubview($0)
        }
        
        listTotalCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(view.snp.left).offset(10)
            $0.height.equalTo(30)
        }
        
        lotteAllFilterButton.snp.makeConstraints {
            $0.top.equalTo(lotteRankFilterButton.snp.top)
            $0.right.equalTo(view.snp.right).offset(-10)
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
        
        lotteRankFilterButton.snp.makeConstraints {
            $0.top.equalTo(listTotalCountLabel.snp.top)
            $0.right.equalTo(lotteAllFilterButton.snp.left).offset(-10)
            $0.height.equalTo(lotteAllFilterButton.snp.height)
        }
        
        lotteCollectionView.snp.makeConstraints {
            $0.top.equalTo(lotteRankFilterButton.snp.bottom).offset(20)
            $0.left.right.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
    }
    
    //MARK: Notification
    
    private func notificationDefault() {
        NotificationCenter.default
            .rx
            .notification(.row, object: nil)
            .withUnretained(self)
            .subscribe { vc,noti in
                guard let rowList = noti.object as? [ShopList] else { return }
                vc.viewModel.entities = rowList
                DispatchQueue.main.async {
                    vc.lotteCollectionView.reloadData()
                }
            }.disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx
            .notification(.high, object: nil)
            .withUnretained(self)
            .subscribe { vc, noti in
                guard let highList = noti.object as? [ShopList] else { return }
                vc.viewModel.entities = highList
                DispatchQueue.main.async {
                    vc.lotteCollectionView.reloadData()
                }
            }.disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx
            .notification(.rank, object: nil)
            .withUnretained(self)
            .subscribe { vc, noti in
                guard let rankList = noti.object as? [ShopList] else { return }
                vc.viewModel.entities = rankList
                DispatchQueue.main.async {
                    vc.lotteCollectionView.reloadData()
                }
            }.disposed(by: disposeBag)
    }


}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LotteCollectionViewCell.reuseIdentifier, for: indexPath) as? LotteCollectionViewCell else { return  UICollectionViewCell() }
        cell.itemBind(viewModel.entities[indexPath.item], viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LotteCollectionViewCell.reuseIdentifier, for: $0) as? LotteCollectionViewCell else { return }
            viewModel.prefetchImage(index: $0.item) { image in
                DispatchQueue.main.async {
                    cell.productImageView.image = image
                }
            }
        }
    }

}
