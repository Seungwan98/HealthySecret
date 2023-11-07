//
//  GoogleMapsController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/05.
//
import UIKit

class IngredientsViewController : UIViewController  {
    
    private var ingredientsArr : [Row] = []
    
    private var filteredDataSource : [Row] = []
    
  
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.gray
        return label
    }()
    
    
    private let tableView = UITableView()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.makeView()
        
        setupSearchController()
        
        
        //데이터 받아옴
        getDataFromFireStore.share.getAll{
            parsed in self.toAppendList(parsed)}
    }
    
    
    
    
    //API 에서 받아온 데이터들 배열에 추가.
    func toAppendList(_ rows: [Row]){
        self.ingredientsArr += rows
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            
            
            
        }
    }
    
    
    
    
    
    
    func makeView(){
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //        let cancel = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
        //            // cancel action
        //        }))
        //        self.navigationItem.rightBarButtonItem = cancel
        //
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        //
        //        let searchController = UISearchController(searchResultsController: nil)
        //
        //        self.navigationItem.searchController = searchController
        //
        //        let cancel = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
        //                    // cancel action
        //                }))
        //                self.navigationItem.rightBarButtonItem = cancel
        //
        //                let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        //                searchBar.placeholder = "Search User"
        //                self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        //        let searchController = UISearchController(searchResultsController: nil)
        //        self.navigationItem.searchController = searchController
    }
    
    
    
    
}



extension IngredientsViewController: UITableViewDelegate , UITableViewDataSource{
    
    var isFiletered : Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isTexting = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isTexting
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        print(filteredDataSource.map{$0.descKor})
        
        if self.isFiletered == false {
            
            cell.textLabel?.text  = String(ingredientsArr[indexPath.row].descKor)        }
        else{
            cell.textLabel?.text = String(filteredDataSource[indexPath.row].descKor)
        }
        
        
        
        
        //cell.textLabel?.text = ingredientsArr[IndexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiletered ? self.filteredDataSource.count : self.ingredientsArr.count
    }
    
    
    
    
    
}

extension IngredientsViewController : UISearchResultsUpdating {
    
    
    
    //SearchController로 SearchBar 추가
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Dj"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    func updateSearchResults (for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.filteredDataSource = self.ingredientsArr.filter{ $0.descKor.localizedCaseInsensitiveContains(text)}
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
}



