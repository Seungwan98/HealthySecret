//
//  likesVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit
import RxSwift
import Kingfisher


class LikesVC : UIViewController, UIScrollViewDelegate , UISearchBarDelegate , FollowsBlocksCellDelegate   {
    func didPressbutton(for index: String, like: Bool) {
        self.pressedFollows.onNext([index:like])

    }
    
    func didPressProfile(for index: String) {
        self.pressedProfile.onNext(index)
    }


    private var pressedFollows = PublishSubject<[String:Bool]>()
    private var pressedProfile = PublishSubject<String>()

    
    
    let disposeBag = DisposeBag()
    
    private var viewModel : LikesVM?
    
    
 
    
   
    
    
    
    
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.backgroundView = self.backgroundView
        return tableView
    }()
    
    
    
    
    private var backgroundView = CustomBackgroundView()
    
    
    
    
    
    
    
    init(viewModel : LikesVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        self.setUI()
        self.setBindings()
        
        
    }
    
    
    let backBarButtonItem = UIBarButtonItem() // title 부분 수정
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "좋아요"

        
        backBarButtonItem.tintColor = .black
        backBarButtonItem.image = UIImage(systemName: "chevron.backward")
        self.navigationItem.backBarButtonItem = nil
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    
    
    
    
    //SearchController로 SearchBar 추가
    
    
    let mainView = UIView()
    
    
  
    
    
    
    func setUI(){
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.register(FollowsBlocksCell.self, forCellReuseIdentifier: "FollowsBlocksCell")
        
        self.view.backgroundColor = .white
        
        self.backgroundView.backgroundLabel.text = "아직 좋아요가 없어요"
        
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false


        
      
        
        
        
        
        
        self.view.addSubview(self.mainView)
        

        self.mainView.addSubview(self.tableView)
        
        
        
        
        
        view.addSubview(self.loadingView)
        
        
        
        NSLayoutConstraint.activate([
            
            
            
            
            self.loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor  ),
            self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor ),
            self.loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor ),
            
            
            
       
            

            
            
            
            
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: mainView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            
            
            
            
            
            //
            
            
        ])
        
        
        
        
    }
    
    
  
    
    
    var loadingView = LoadingView()

    func setBindings() {
        
        loadingView.isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadingView.isLoading = false
            
          }
        
        guard let ownUid = UserDefaults.standard.string(forKey: "uid") else {
            print("ownUid nil")
            return  }
        
        
        let input = LikesVM.Input( viewWillApearEvent : self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable() , pressedFollows: self.pressedFollows.asObservable() ,
                                   pressedProfile : self.pressedProfile.asObservable()
                                     
                                     
        )
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        
        
        tableView.rx.rowHeight.onNext(60)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        output.backgroundViewHidden.bind(to: self.backgroundView.rx.isHidden).disposed(by: disposeBag)
    
        
        
        
        output.userModels.bind(to: tableView.rx.items(cellIdentifier: "FollowsBlocksCell" , cellType: FollowsBlocksCell.self )){
            [weak self] index , item , cell in
            guard let self = self else {return}
            
            cell.setFollowButton()
            if ownUid == item.uuid {
                cell.button.isHidden = true
                
            }else{
                if let followers = item.followers {
                    if(followers.contains(ownUid)){
                        cell.followIsTouched = true
                        cell.button.isSelected = true
                    }else{
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
                    
                    
                    let processor = DownsamplingImageProcessor(size: CGSize(width: cell.profileImage.bounds.width , height: cell.profileImage.bounds.height) ) // 크기 지정 다운 샘플링
                    |> RoundCornerImageProcessor(cornerRadius: 0) // 모서리 둥글게
                    cell.profileImage.kf.indicatorType = .activity  // indicator 활성화
                    cell.profileImage.kf.setImage(
                        with: url,  // 이미지 불러올 url
                        placeholder: UIImage(named: "일반적.png") ,  // 이미지 없을 때의 이미지 설정
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.none),  // 애니메이션 효과
                            .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                        ])
                    
                    
                    
                    
                }else{
                    cell.profileImage.image = UIImage(named: "일반적.png")
                }
                
                
                
                
            }
            
            
            
            
            
            
            
        }.disposed(by: disposeBag)
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}



















