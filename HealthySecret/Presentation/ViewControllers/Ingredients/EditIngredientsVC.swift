//
//  EditIngredientsVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift

class EditIngredientsVC : UIViewController, UIScrollViewDelegate {
    let viewModel : EditIngredientsVM?
    let disposeBag = DisposeBag()
    
    init(viewModel: EditIngredientsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("추가", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        return button
    }()
    private let edmitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.setTitle("기록하기", for: .normal)

        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    
    
    private let topView : UIView = {
        let view =  UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.03, alpha: 1)

        
        return view
        
    }()
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    lazy var mealView : UIView = {
       let view = UIView()
        view.addSubview(imageView)
                
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor =  UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        
        return view
        
    }()
    
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = true
        tableView.register(EditIngredientsCell.self, forCellReuseIdentifier: "EditIngredientsCell")

        return tableView
    }()
    
    
    let todayIngredientsLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " "
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
        
    }()
    
    let todayTotalIngredientsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue.withAlphaComponent(0.8)
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
  
    
     let bottomView : UIView = {
        let view = UIView()
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
      
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        setBinds()
    }
    
    @objc
    func delCell( _ sender : UIButton){

        let contentView = sender.superview
               let cell = contentView?.superview as! UITableViewCell
        var value : [Row] = []
        if let indexPath = self.tableView.indexPath(for: cell) {
            ingredientsArr.subscribe(onNext: { arr in
                value = arr
             
                value.remove(at: indexPath.row)

                
            }).disposed(by: DisposeBag())
            
               }
        
        self.ingredientsArr.onNext(value)


    }
    
    var ingredientsArr = BehaviorSubject<[Row]>(value: [])
    
    
    func setBinds(){
        
        let imageArr = [UIImage(named: "edmitBreakfast.png"),UIImage(named: "edmitLunch.png"),UIImage(named: "edmitDinner.png"),UIImage(named: "edmitSnack.png")]
        
        todayIngredientsLabel.text = (UserDefaults.standard.string(forKey: "meal") ?? "")+" "
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.rowHeight.onNext(70)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        let input = EditIngredientsVM.Input(viewWillApearEvent :  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , edmitButtonTapped : edmitButton.rx.tap.asObservable() , inputArr : ingredientsArr.asObservable()  , addButtonTapped : addButton.rx.tap.asObservable())
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.ingredientsArr.bind(to: self.ingredientsArr).disposed(by: disposeBag)
        
        self.ingredientsArr.subscribe(onNext: { arr in
            self.todayTotalIngredientsLabel.text = String(arr.count)
            
            
            
        }).disposed(by: disposeBag)
        
        ingredientsArr.bind(to: tableView.rx.items(cellIdentifier: "EditIngredientsCell" ,cellType: EditIngredientsCell.self )){index,item,cell in
            cell.kcal.text = item.calorie + "kcal"
            cell.gram.text = (item.addServingSize ?? item.servingSize) + "g"
            cell.name.text = item.descKor
            
            cell.deleteButton.addTarget(self, action: #selector(self.delCell), for: .touchUpInside)
            
            
        }.disposed(by: disposeBag)
        

        output.imagePicker.subscribe(onNext: { value in
            self.imageView.image = imageArr[value]
            
        }).disposed(by: disposeBag)
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.03, alpha: 1)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.hidesBottomBarWhenPushed = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    let mainView = UIView()
    
    func setUI(){
        
        self.view.backgroundColor = .white
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.edmitButton.translatesAutoresizingMaskIntoConstraints = false
        
    
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mainView)
        self.mainView.addSubview(topView)
        self.mainView.addSubview(tableView)
        self.mainView.addSubview(todayIngredientsLabel)
        self.mainView.addSubview(todayTotalIngredientsLabel)
        self.mainView.addSubview(bottomView)
        
        topView.addSubview(mealView)
        
        bottomView.addSubview(addButton)
        bottomView.addSubview(edmitButton)
        
        NSLayoutConstraint.activate([
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor , constant: 15),
            
            edmitButton.heightAnchor.constraint(equalToConstant: 60),
            edmitButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 15),
            edmitButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15),
            
            
            
            bottomView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            
            topView.topAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 300),
            topView.leadingAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.trailingAnchor),
            
            
            
            mealView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            mealView.centerYAnchor.constraint(equalTo: topView.centerYAnchor , constant:  -(self.navigationController?.navigationBar.frame.height ?? 0)/2 ),
            mealView.widthAnchor.constraint(equalToConstant: 120),
            mealView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.centerXAnchor.constraint(equalTo: mealView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: mealView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            
            
            
            
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor ,constant: 60),
            tableView.leadingAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.bottomAnchor),
            
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            mainView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            todayIngredientsLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            todayIngredientsLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            todayIngredientsLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor , constant: 20),
            
            todayTotalIngredientsLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            todayTotalIngredientsLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            todayTotalIngredientsLabel.leadingAnchor.constraint(equalTo: todayIngredientsLabel.trailingAnchor , constant: 0),
            
        ])
    }
    
}
