//
//  ProductSortPanModalView.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit



final class ProductSortPanModalView: ViewController {
    
    
    //MARK: Property
    
    public var dissolveView: UIView = {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.isOpaque = false
        
        return $0
    }(UIView())
    
    private var flexBoxTitleLabel: UILabel = {
        $0.text = "정렬"
        $0.font = .systemFont(ofSize: 19)
        $0.textColor = .black
        $0.textAlignment = .left
        
        return $0
    }(UILabel())
    
    private var flexBoxView: UIView = {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return $0
    }(UIView())
    
    
    private var rankFilterButton: UIButton = {
        $0.setTitle("랭킹순", for: .normal)
        $0.setImage(UIImage(named: "completeOff"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 0)
        $0.setTitleColor(.black, for: .normal)
        $0.contentVerticalAlignment = .top
        $0.contentHorizontalAlignment = .left
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        
        return $0
    }(UIButton())
    
    private var rowPriceFilterButton: UIButton = {
        $0.setTitle("낮은 가격순", for: .normal)
        $0.setImage(UIImage(named: "completeOff"), for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 0)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.contentVerticalAlignment = .top
        $0.contentHorizontalAlignment = .left

        return $0
    }(UIButton())
    
    private var highPriceFilterButton: UIButton = {
        $0.setTitle("높은 가격순", for: .normal)
        $0.setImage(UIImage(named: "completeOff"), for: .normal)
        $0.contentVerticalAlignment = .top
        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 0)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return $0
    }(UIButton())
    
    private let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    private var sortViewModel: ViewModel = ViewModel(lotteShopUseCase: DefaultLotteShopUseCase(lotteRepository: DefaultShopListRepository()))
    private let disposeBag: DisposeBag = DisposeBag()
    
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        configure()
        showPanModal()
    }
    
    
    //MARK: Configure
    
    private func bindUI() {
        tapGestureRecognizer.rx.event.subscribe { event in
            self.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        rowPriceFilterButton.rx.tap
            .bind(to: sortViewModel.didTapRowFilter)
            .disposed(by: disposeBag)
        
        sortViewModel.didTapRowFilter
            .withUnretained(self)
            .subscribe { vc, _ in
               
            }.disposed(by: disposeBag)
        
    }
    
    
    private func showPanModal() {
        dissolveView.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dissolveView.backgroundColor = .black.withAlphaComponent(0.5)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func configure() {
        view.addSubview(dissolveView)
        
        dissolveView.addGestureRecognizer(tapGestureRecognizer)
        dissolveView.addSubview(flexBoxView)
        [flexBoxTitleLabel,rankFilterButton,rowPriceFilterButton,highPriceFilterButton].forEach {
            flexBoxView.addSubview($0)
        }
        
        dissolveView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        flexBoxView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height / 2)
        }
        
        flexBoxTitleLabel.snp.makeConstraints {
            $0.top.equalTo(flexBoxView.snp.top).offset(20)
            $0.left.equalTo(flexBoxView.snp.left).offset(20)
            $0.width.height.equalTo(40)
        }
        
        rankFilterButton.snp.makeConstraints {
            $0.top.equalTo(flexBoxTitleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        
        rowPriceFilterButton.snp.makeConstraints {
            $0.top.equalTo(rankFilterButton.snp.bottom)
            $0.left.right.height.equalTo(rankFilterButton)
        }
        
        highPriceFilterButton.snp.makeConstraints {
            $0.top.equalTo(rowPriceFilterButton.snp.bottom)
            $0.left.right.height.equalTo(rowPriceFilterButton)
        }
        
        
    }
    
}


