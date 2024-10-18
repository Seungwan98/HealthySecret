//
//  SearchVC.swift
//  HealthySecret
//
//  Created by 양승완 on 9/25/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchVC: UIViewController, UIScrollViewDelegate, FollowsBlocksCellDelegate {
    func didPressbutton(for index: String, like: Bool) {
        self.pressedFollows.onNext([index: like])
        
    }
    
    func didPressProfile(for index: String) {
        self.pressedProfile.onNext(index)
    }
    
    
    private var pressedFollows = PublishSubject<[String: Bool]>()
    private var pressedProfile = PublishSubject<String>()
    
    
    
    
    
    let disposeBag = DisposeBag()
    private let viewModel: SearchVM?
    
    init(viewModel: SearchVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    

    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = ""
        return label
        
    }()
    
    
    private lazy var titleLabelStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [titleLabel])
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .center
        return stackview
        
    }()
    
    private let mainView = UIView()
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeView()
        self.setupSearchController()
        self.setBinds()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.navigationController?.hidesBarsOnSwipe = false
        
      //  self.navigationController?.navigationBar.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
//        if #available(iOS 13.0, *) {
//            searchController.searchBar.searchTextField.textColor =  UIColor.white
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    func setBinds() {
        
        guard let ownUid = UserDefaults.standard.string(forKey: "uid") else {
            print("ownUid nil")
            return  }
        let input = SearchVM.Input( viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable(), pressedFollows: self.pressedFollows.asObservable(), pressedProfile: self.pressedProfile.asObservable(), searchText: self.searchController.searchBar.rx.text.orEmpty.skip(1).throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged().asObservable())
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
       
        
        
        output.userModels.bind(to: tableView.rx.items(cellIdentifier: "FollowsBlocksCell", cellType: FollowsBlocksCell.self )) { [weak self] _, item, cell in
            guard let self = self else {return}
            
            cell.setFollowButton()
            if ownUid == item.uuid {
                cell.button.isHidden = true
                
            } else {
                cell.button.isHidden = false

                if let followers = item.followers {
                    if followers.contains(ownUid) {
                        cell.followIsTouched = true
                        cell.button.isSelected = true
                    } else {
                        cell.followIsTouched = false
                        cell.button.isSelected = false
                    }
                }
                
                
            }
            cell.index = item.uuid
            cell.nickname.text = item.name
            
            
            
            
            cell.delegate = self
            
            DispatchQueue.main.async {
                
                
                
                if let url = URL(string: item.profileImage ?? "" ) {
                    
                    
                    let processor = DownsamplingImageProcessor(size: CGSize(width: cell.profileImage.bounds.width, height: cell.profileImage.bounds.height) ) // 크기 지정 다운 샘플링
                    |> RoundCornerImageProcessor(cornerRadius: 0) // 모서리 둥글게
                    cell.profileImage.kf.indicatorType = .activity  // indicator 활성화
                    cell.profileImage.kf.setImage(
                        with: url,  // 이미지 불러올 url
                        placeholder: UIImage(named: "일반적.png"),  // 이미지 없을 때의 이미지 설정
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.none),  // 애니메이션 효과
                            .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                        ])
                    
                    
                    
                    
                } else {
                    cell.profileImage.image = UIImage(named: "일반적.png")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    
    
    // SearchController로 SearchBar 추가
    func setupSearchController() {
        
        
        
        searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "유저 검색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        definesPresentationContext = false
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        
        
        
    }
    
    
    func makeView() {
        
        self.navigationItem.titleView = titleLabelStackView
        
        
        
        tableView.register(FollowsBlocksCell.self, forCellReuseIdentifier: "FollowsBlocksCell")

        
        self.view.addSubview(mainView)
        self.view.addSubview(tableView)
        
        mainView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(mainView)
        }
        
        
        
        
        
    }
    
    
    
}
