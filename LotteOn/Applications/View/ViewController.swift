//
//  ViewController.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/21.
//

import UIKit
import SnapKit

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
    

    private var lotteCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.itemSize = CGSize(width: $0.frame.width / 2, height: 200)
        flowLayout.scrollDirection = .vertical
        $0.register(LotteCollectionViewCell.self, forCellWithReuseIdentifier: LotteCollectionViewCell.reuseIdentifier)
        return $0
    }(UICollectionView())

    private let viewModel: ViewModel = ViewModel(lotteShopUseCase: DefaultLotteShopUseCase(lotteRepository: DefaultShopListRepository()))
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
        configure()
    }
    
    
    //MARK: Configure
    
    private func bind() {
        viewModel.bindTotalCount { [weak self] count in
            self?.listTotalCountLabel.text = "총 " + count + " 개"
        }
    }
    
    private func configure() {
        view.backgroundColor = .white
        lotteCollectionView.delegate = self
        lotteCollectionView.dataSource = self
        
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
        
        
    }


}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LotteCollectionViewCell.reuseIdentifier, for: indexPath) as? LotteCollectionViewCell else { return  UICollectionViewCell() }
        
        
        return cell
    }


}
