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
        tableView.backgroundColor = .clear
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = ""
        return label
        
    }()
    
    
    private lazy var titleLabelStackView : UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [titleLabel])
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .center
        return stackview
        
    }()
    
    private let mainView = UIView()
    
    
    
    
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
    
        self.makeView()
        self.setupSearchController()
        self.setBinds()
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.hidesBarsOnSwipe = false

        self.navigationController?.navigationBar.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor =  UIColor.white
        }
    }
    override func viewWillDisappear(_ animated: Bool) {

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    func setBinds(){
        let input = ExerciseVM.Input(viewWillApearEvent :  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable(), cellTapped: tableView.rx.modelSelected(ExerciseDtoData.self).asObservable() , searchText: searchController.searchBar.rx.text.orEmpty.asObservable())
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.rowHeight.onNext(60)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
                        self?.tableView.deselectRow(at: indexPath, animated: true)
                    }).disposed(by: disposeBag)
        
        
        
        
        
        output.exerciseArr.bind(to: tableView.rx.items(cellIdentifier: "ExerciseCell" ,cellType: ExerciseCell.self )){index,item,cell in
            
            cell.layoutToAdd()
            cell.exerciseGram.text = item.exerciseGram
            cell.name.text = item.name

        }.disposed(by: disposeBag)
        
        output.titleLabelText.subscribe(onNext: { text in
            
            self.titleLabel.text = text
        
            
            
        }).disposed(by: disposeBag)
    }
    
    
    
    //SearchController로 SearchBar 추가
    func setupSearchController() {
        
        
        
        searchController.searchBar
            .searchTextField
            .attributedPlaceholder = NSAttributedString(string: "운동 검색",
                                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        searchController.searchBar.searchTextField.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)

        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.borderColor = UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1).cgColor
        
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        definesPresentationContext = false

        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController

        
        
    }
    
    
    func makeView(){
        
        self.navigationItem.titleView = titleLabelStackView
        self.navigationItem.rightBarButtonItem = self.rightButton
        
        mainView.translatesAutoresizingMaskIntoConstraints = false

        
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: "ExerciseCell")
        
        
        self.view.addSubview(mainView)
        self.view.addSubview(tableView)
        
 
        
        NSLayoutConstraint.activate([
            
    


            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
           
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            
         
            
            
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





