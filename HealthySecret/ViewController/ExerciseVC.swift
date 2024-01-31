//
//  GoogleMapsController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit
import RxSwift


class ExerciseViewController : UIViewController, UIScrollViewDelegate  {
   
    
    
    
    
    
    let disposeBag = DisposeBag()
    private let viewModel : ExerciseVM?
    
    init(viewModel : ExerciseVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: nil)
        button.isEnabled = false
        return button
    }()
 
    
    private var titleLabel2 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.text = ""
        return label
        
    }()
    
    
    private lazy var titleLabelStackView : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [titleLabel2])
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .center
        return stackview
        
    }()
    
    
    
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
     
    
        self.makeView()
        self.setupSearchController()
        self.setBinds()
        
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
    
    
    
    func setBinds(){
        let input = ExerciseVM.Input(viewWillApearEvent :  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable(), cellTapped: tableView.rx.modelSelected(Data.self).asObservable() )
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.rowHeight.onNext(60)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
                        self?.tableView.deselectRow(at: indexPath, animated: true)
                    }).disposed(by: disposeBag)
        
        
        
        
        
        output.exerciseArr.bind(to: tableView.rx.items(cellIdentifier: "ExerciseCell" ,cellType: ExerciseCell.self )){index,item,cell in
            cell.exerciseGram = item.exerciseGram
            cell.name.text = item.name
            
            

            
        }.disposed(by: disposeBag)
    }
    
    
    
    //SearchController로 SearchBar 추가
    func setupSearchController() {
        
        
        
        searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "운동 검색",
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
        
        
        
        self.navigationItem.titleView = titleLabelStackView
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: "ExerciseCell")
        
        self.view.addSubview(tableView)
        
 
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
         
            
            
        ])
        
        
        
        
    }

   
    
}


//
//extension ExerciseViewController : UITableViewDelegate , UITableViewDataSource  {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//
//
//        return 10
//    }
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as? ExerciseCell else { return .init() }
//        cell.title.text = "test"
//            return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//
//
//
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//}


class ExerciseCell : UITableViewCell {
    let name = UILabel()
    var exerciseGram = ""
    
    required override init( style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier )
        
        layout()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layout() {
        self.contentView.addSubview(self.name)
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        self.name.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        
    }
    
    
    
    
}


