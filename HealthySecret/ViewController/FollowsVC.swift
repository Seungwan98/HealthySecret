//
//  FollowsVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit
import RxSwift


class FollowsVC : UIViewController, UIScrollViewDelegate , UISearchBarDelegate   {
    
    
    
    
    let disposeBag = DisposeBag()
    
    private var viewModel : FollowsVM?
    
    private var ingredientsArr : [Row] = []
    
    private var recentsearchArr : [String] = []
    
    private var filteredArr : [Row] = []
    
    private var pushArr : [Row] = []
    
    private var cellController : Bool = false
    
    private var likes : [String:Int] = [:]
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    

  
    
    
  
    
    
    private var cellTouchToSearch = PublishSubject<String>()
    
    
    
    init(viewModel : FollowsVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.setUI()
        self.setBind()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
   

        
       
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
        tableView.register(FollowsCell.self, forCellReuseIdentifier: "FollowsCell")

        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        self.view.addSubview(mainView)
        
        self.mainView.addSubview(tableView)
        
        
        
        
        
        
        
        
        NSLayoutConstraint.activate([
            
            
            
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            

            
      
//
            
            
        ])
        
        
        
        
    }
    
    
    
    var likesInputArr = PublishSubject<[String:Int]>()
    var getBool = PublishSubject<Bool>()
    var cellTouchToDetail = PublishSubject<Row>()
    
    
    
    func setBind() {
        
        
        
        
        
        let input = FollowsVM.Input( viewWillApearEvent : self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable()
                                         
        )
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        tableView.rx.rowHeight.onNext(50)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        output.userModels.bind(to: tableView.rx.items(cellIdentifier: "FollowsCell" , cellType: FollowsCell.self )){
          [weak self] index , item , cell in
            
            
            
            cell.nickname.text = item.name
            
            //
            
            
            
            
        }.disposed(by: disposeBag)
       
        
        
        
  

        
        
    }
    
    
    
    
    
    
    
    
}



















protocol FollowsCellDelegate {
    func didPressFollows(for index: String, like: Bool)
}

class FollowsCell : UITableViewCell {
    
    
    let followButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 13
       // button.clipsToBounds = true
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setTitle("팔로우", for: .normal )
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        
        
        return button
        
        
    }()
    var nickname = UILabel()
    var profileImage = UIImageView()
    var delegate: FollowsCellDelegate?
    var selector : Bool?
    var index : String?
    
    
    @IBAction func didPressedHeart(_ sender: UIButton) {
        
        guard let idx = index else {return}
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            isTouched = true
        }else {
            isTouched = false
            delegate?.didPressFollows(for: idx, like: false)
        }
        
        
    }
    var isTouched: Bool? {
        didSet {
            if isTouched == true {
                
                followButton.backgroundColor = .lightGray
                followButton.setTitle("팔로잉", for: .normal)
              
            }else{
                followButton.backgroundColor = .systemBlue
                followButton.setTitle("팔로우", for: .normal)
            }
        }
    }
    
    
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        followButton.addTarget(self, action: #selector(didPressedHeart) , for: .touchUpInside )
        
        layout()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    func layout() {
        self.followButton.translatesAutoresizingMaskIntoConstraints = false
        self.nickname.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.nickname.font = .systemFont(ofSize: 14)
        
        self.addSubview(contentView)
        self.contentView.addSubview(self.followButton)
        self.contentView.addSubview(self.nickname)
        self.contentView.addSubview(self.profileImage)
        
        
        NSLayoutConstraint.activate([
            
            
            self.profileImage.widthAnchor.constraint(equalToConstant: 30),
            self.profileImage.heightAnchor.constraint(equalToConstant: 30),
            self.profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: 16),
            
            
            self.followButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            self.followButton.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
            self.followButton.widthAnchor.constraint(equalToConstant: 60),
            self.followButton.heightAnchor.constraint(equalToConstant: 26),
            
            
            self.nickname.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor , constant: 10),
            self.nickname.centerYAnchor.constraint(equalTo: self.centerYAnchor ),
            
            
        ])
        
       
     
        
        
        
    }
    
    
    
}

