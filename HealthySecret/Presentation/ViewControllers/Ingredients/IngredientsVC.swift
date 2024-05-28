//
//  GoogleMapsController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit
import RxSwift


class IngredientsViewController : UIViewController, UIScrollViewDelegate, IngredientsCellDelegate, UISearchBarDelegate   {
    
    
    
    
    let disposeBag = DisposeBag()
    
    private var viewModel : IngredientsVM?
    
    private var ingredientsArr : [Row] = []
    
    private var recentsearchArr : [String] = []
    
    private var filteredArr : [Row] = []
    
    private var pushArr : [Row] = []
    
    private var cellController : Bool = false
    
    private var likes : [String:Int] = [:]
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        button.isEnabled = false
        return button
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "/t/t식사"
        label.textColor = .white
        return label
        
    }()
    
    private var titleLabel2 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.text = "/t/t월/t/t일"
        return label
        
    }()
    
    
    private lazy var titleLabelStackView : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [titleLabel , titleLabel2])
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .center
        return stackview
        
    }()
    
    private var backgroundTableView = UIImageView(image: UIImage(named:"tableBackGround.png"))
    
    private var checkBoxButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    private var backgroundView = UIView()
    
    private var cellTouchToSearch = PublishSubject<String>()
    
    
    
    init(viewModel : IngredientsVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.setUI()
        self.setupSearchController()
        self.setBind()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
   

        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.03, alpha: 1)
        
       
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor =  UIColor.white
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
  
    
    
    
    
    //SearchController로 SearchBar 추가
    func setupSearchController() {
        
        
        
        searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "식품 검색",
                                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
      
        
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.borderColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1).cgColor
        searchController.searchBar.searchTextField.layer.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 0.45).cgColor
        
        
        
        searchController.searchBar.backgroundColor = UIColor(red: 0.09, green: 0.176, blue: 0.031, alpha: 1)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        
        
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        
        
    }
    
    
    let mainView = UIView()
    func setUI(){
        
        self.tableView.backgroundView = backgroundView
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.register(IngredientsCell.self, forCellReuseIdentifier: "IngredientsCell")

        backgroundTableView.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.navigationItem.titleView = titleLabelStackView
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        
        
        self.view.addSubview(mainView)
        
        self.mainView.addSubview(tableView)
        self.backgroundView.addSubview(backgroundTableView)
        
        
        
        
        
        
        
        
        NSLayoutConstraint.activate([
            
            
            
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            

            
            
            backgroundTableView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            backgroundTableView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
//          
            
            
        ])
        
        
        
        
    }
    
    
    
    var likesInputArr = PublishSubject<[String:Int]>()
    var getBool = PublishSubject<Bool>()
    var cellTouchToDetail = PublishSubject<Row>()
    
    
    
    func setBind() {
        
        
        
        
        
        let input = IngredientsVM.Input( viewWillAppear : self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable(),
                                         rightButtonTapped: rightButton.rx.tap.asObservable(),
                                         searchText: Observable.merge( searchController.searchBar.rx.text.orEmpty.distinctUntilChanged().asObservable()),
                                         likesInputArr: self.likesInputArr.asObservable() , cellTouchToDetail:  tableView.rx.modelSelected(Row.self).asObservable()
                                         
        )
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        tableView.rx.rowHeight.onNext(50)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
      
        
        output.rightButtonEnable.bind(to: rightButton.rx.isEnabled).disposed(by: disposeBag)
        
        
        
        output.titleLabelTexts.subscribe(onNext: { arr in
            
            self.titleLabel.text = arr[0]
            self.titleLabel2.text = arr[1]
            
            
        }).disposed(by: disposeBag)
        
        
        output.ingredientsArr.bind(to: tableView.rx.items(cellIdentifier: "IngredientsCell" , cellType: IngredientsCell.self )){
            index,item,cell in

            let index = item.num
            cell.backgroundColor = .clear

            cell.title.text = item.descKor
            cell.index = item.num
            cell.kcal.text = "( " + item.servingSize + "g )" + " " + item.calorie + " kcal"
            cell.delegate = self
            
            if self.likes[index] == 1 {
                cell.checkBoxButton.isSelected = true
                cell.isTouched = true


            }else{
                cell.checkBoxButton.isSelected = false
                cell.isTouched = false
            }
            
            print(item.descKor)

            
        }.disposed(by: disposeBag)
        
        
        
       
        
        
        
    }
    
    
    
    
    
    
    
    
}


var checkBoxButtonTapped = PublishSubject<Void>()

extension IngredientsViewController{
    func rightButtonEnabled() {
        if likes.isEmpty == true {
            self.rightButton.isEnabled = false
            
        }
        else{
            self.rightButton.isEnabled = true
            
            
        }
    }
    
    
    
    
    func didPressHeart(for index: String, like: Bool) {
        if like {
            likes[index] = 1
        }else{
            likes[index] = nil
        }
        viewModel?.likes = likes
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}











class RecentSearchCell : UITableViewCell {
    var title = UILabel()
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        layout()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layout() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.title)
        
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
    }
    
    
    
    
}




protocol IngredientsCellDelegate {
    func didPressHeart(for index: String, like: Bool)
    func rightButtonEnabled()
}

class IngredientsCell : UITableViewCell {
    
    var checkBoxButton = UIButton()
    var title = UILabel()
    var kcal = UILabel()
    var delegate: IngredientsCellDelegate?
    var selector : Bool?
    var index : String?
    
    
    @IBAction func didPressedHeart(_ sender: UIButton) {
        
        guard let idx = index else {return}
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            isTouched = true
            delegate?.didPressHeart(for: idx, like: true)
        }else {
            isTouched = false
            delegate?.didPressHeart(for: idx, like: false)
        }
        delegate?.rightButtonEnabled()
        
        
    }
    var isTouched: Bool? {
        didSet {
            if isTouched == true {
                checkBoxButton.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }else{
                checkBoxButton.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            }
        }
    }
    
    
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        checkBoxButton.addTarget(self, action: #selector(didPressedHeart) , for: .touchUpInside )
        
        layout()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    func layout() {
        self.checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.kcal.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(contentView)
        self.contentView.addSubview(checkBoxButton)
        self.contentView.addSubview(title)
        self.contentView.addSubview(kcal)
        
        
        
        
        self.checkBoxButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        self.checkBoxButton.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.checkBoxButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.checkBoxButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant:  -6).isActive = true
        
        self.kcal.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.kcal.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor , constant: -4 ).isActive = true
        self.kcal.font = UIFont.systemFont(ofSize: 13)
        
        
        
        
    }
    
    
    
}

