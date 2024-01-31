//
//  GoogleMapsController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit
import RxSwift


class IngredientsViewController : UIViewController   {
    
    
    
    
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
        tableView.backgroundView = backgroundView
        tableView.dataSource = self
        tableView.delegate = self
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
        
        
        self.setBind()
        self.makeView()
        self.setupSearchController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.09, green: 0.176, blue: 0.031, alpha: 1)
        
        
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
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        
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
    
    
    func makeView(){
        backgroundTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        self.navigationItem.titleView = titleLabelStackView
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        
        
        self.backgroundView.addSubview(backgroundTableView)
        self.view.addSubview(tableView)
        
        
        
        
        
        
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            backgroundTableView.centerXAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerXAnchor),
            backgroundTableView.centerYAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.centerYAnchor)
            
            
        ])
        
        
        
        
    }
    
    
    
    var likesInputArr = PublishSubject<[String:Int]>()
    var getBool = PublishSubject<Bool>()
    
    
    
    func setBind() {
        
        
        
        let input = IngredientsVM.Input( viewWillAppear : self.rx.methodInvoked(#selector(viewWillAppear(_:)))
            .map( { _ in }).asObservable(),
                                         rightButtonTapped: rightButton.rx.tap.asObservable(),
                                         searchText: Observable.merge( searchController.searchBar.rx.text.orEmpty.asObservable(),
                                                                       self.cellTouchToSearch),
                                         likesInputArr: self.likesInputArr.asObservable()
                                      
        )
        
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag ) else {return}
        
        
        output.recentsearchArr.subscribe(onNext: {
            arr in self.recentsearchArr = arr
            self.tableView.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
            
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        
        output.ingredientsArr.subscribe(onNext : {
            arr in self.ingredientsArr = arr
            print("ingredients")
            self.tableView.register(IngredientsCell.self, forCellReuseIdentifier: "IngredientsCell")
            
            self.tableView.reloadData()
            
            
        }).disposed(by: disposeBag)
        
        output.checkController.subscribe(onNext: {
            cont in self.cellController = cont
            
            
            self.tableView.register(IngredientsCell.self, forCellReuseIdentifier: "IngredientsCell")
            self.tableView.reloadData()
            
        }).disposed(by: disposeBag)
        
        
        output.rightButtonEnable.bind(to: rightButton.rx.isEnabled).disposed(by: disposeBag)
        
        output.titleLabelTexts.subscribe(onNext: { arr in
            
            self.titleLabel.text = arr[0]
            self.titleLabel2.text = arr[1]
            
            
        }).disposed(by: disposeBag)
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}


var checkBoxButtonTapped = PublishSubject<Void>()

extension IngredientsViewController: UITableViewDelegate , UITableViewDataSource , IngredientsCellDelegate {
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        var resultCell = UITableViewCell()
        if(self.cellController){
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell" , for: indexPath) as? IngredientsCell {
                
                cell.backgroundColor = .clear
                let index = String(ingredientsArr[indexPath.row].num)
                
                cell.delegate = self
                
                cell.title.text = String(ingredientsArr[indexPath.row].descKor)
                cell.kcal.text = String( "( " + ingredientsArr[indexPath.row].servingSize + "g )" + " " +  ingredientsArr[indexPath.row].kcal + " kcal")
                cell.index = index
                
                print(likes)
                
                if likes[index] == 1 {
                    cell.checkBoxButton.isSelected = true
                    cell.isTouched = true
                    
                }else{
                    cell.checkBoxButton.isSelected = false
                    cell.isTouched = false
                }

                resultCell = cell
                
            }
        }
        else{
            print("recentSearchCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell" , for: indexPath) as! RecentSearchCell
            cell.backgroundColor =  .clear
            
            cell.title.text = String(recentsearchArr[indexPath.row])
            resultCell = cell
        }
        
        
        
        
        
        return resultCell
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result : Int
        if(cellController){ result = self.ingredientsArr.count } else { result = self.recentsearchArr.count}
        
        return result
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let result : Int
        if(cellController){ result = 50 } else { result = 40}
        
        return CGFloat(result)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(cellController){
            
            
        } else {
            let text = recentsearchArr[indexPath.row]
            self.searchController.searchBar.text = text
            self.cellTouchToSearch.onNext(text)
            
            
        }
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
        self.contentView.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.contentView.addSubview(checkBoxButton)
        self.contentView.addSubview(title)
        self.contentView.addSubview(kcal)
        
        
        
        
        self.checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        self.checkBoxButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        self.checkBoxButton.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.checkBoxButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.checkBoxButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.title.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant:  -6).isActive = true
        
        self.kcal.translatesAutoresizingMaskIntoConstraints = false
        self.kcal.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.kcal.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor , constant: -4 ).isActive = true
        self.kcal.font = UIFont.systemFont(ofSize: 13)
        
        
        
        
    }
    
    
    
}


