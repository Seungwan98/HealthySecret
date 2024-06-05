//
//  likesVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit
import RxSwift
import Kingfisher
import SnapKit


class BlockListVC : UIViewController, UIScrollViewDelegate , UISearchBarDelegate , FollowsBlocksCellDelegate   {
    func didPressbutton(for index: String, like: Bool) {
        self.pressedBlock.onNext([index:like])

    }
    
    func didPressProfile(for index: String) {
        //
    }
    
  
    
    private var pressedBlock = PublishSubject<[String:Bool]>()

    
    
    let disposeBag = DisposeBag()
    
    private var viewModel : BlockListVM?
    
    let backBarButtonItem = UIBarButtonItem()
    
    let mainView = UIView()

    
   
    
    
    
    
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.backgroundView = self.backgroundView
        return tableView
    }()
    
    
    
    
    private var backgroundView = CustomBackgroundView()
    
    
    
    
    
    
    
    init(viewModel : BlockListVM){
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
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "차단목록"

        
        backBarButtonItem.tintColor = .black
        backBarButtonItem.image = UIImage(systemName: "chevron.backward")
        self.navigationItem.backBarButtonItem = nil
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    
    
    
    
  
    
    
    
    func setUI(){
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.register(FollowsBlocksCell.self, forCellReuseIdentifier: "FollowsBlocksCell")
        
        self.view.backgroundColor = .white
        
        self.backgroundView.backgroundLabel.text = "아직 차단한 유저가 없어요"
        

        self.view.addSubview(self.mainView)

        self.mainView.addSubview(self.tableView)
        
        
        
        
        
        view.addSubview(self.loadingView)
        
        self.loadingView.snp.makeConstraints{
            $0.trailing.bottom.top.leading.equalTo(self.view)
        }
        self.mainView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        self.tableView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(mainView)
        }
        self.backgroundView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(mainView)
        }
       
        
        
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
        
        
        let input = BlockListVM.Input( viewWillApearEvent : self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable() ,
                                       pressedBlock : self.pressedBlock.asObservable()
                                     
                                     
        )
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        
        
        tableView.rx.rowHeight.onNext(60)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        output.backgroundViewHidden.bind(to: self.backgroundView.rx.isHidden).disposed(by: disposeBag)
    
        output.alert.subscribe(onNext: { [weak self] _ in
            
            guard let self = self else {return}
            
            AlertHelper.shared.showResult(title: "차단이 해제되었습니다", message: "상대방의 프로필에서 차단 할 수 있습니다", over: self)
            
            
        }).disposed(by: disposeBag)
        
        
        output.userModels.bind(to: tableView.rx.items(cellIdentifier: "FollowsBlocksCell" , cellType: FollowsBlocksCell.self )){
            [weak self] index , item , cell in
            guard let self = self else {return}
            

            cell.setBlockButton()
               
                    if(item.blocked.contains(ownUid)){
                        cell.blockIsTouched = true
                        
                        cell.button.isSelected = true
                    }else{

                        cell.blockIsTouched = false
                        cell.button.isSelected = false
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



















