//
//  EditExerciseVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift

class EditExerciseVC : UIViewController, UIScrollViewDelegate {
    let viewModel : EditExerciseVM?
    let disposeBag = DisposeBag()
    
    init(viewModel: EditExerciseVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainView = UIView()
    
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
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
        return view
        
    }()
    
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "dumbbellPic.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
        
    }()
    
    
    lazy private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = true
        tableView.register(ExerciseCell.self, forCellReuseIdentifier: "ExerciseCell")

        return tableView
    }()
    
    let todayExerciseLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "오늘 한 활동 "
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
        
    }()
    
    let totalTodayExerciseLabel : UILabel = {
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
        
        addSubView()
        
        setBinds()
    }
    
    @objc
    func delCell( _ sender : UIButton){

        let contentView = sender.superview
               let cell = contentView?.superview as! UITableViewCell
        var value : [Exercise] = []
        if let indexPath = self.tableView.indexPath(for: cell) {
            exerciseArr.subscribe(onNext: { arr in
                value = arr
                print("\(indexPath.row) row")
                print(value)
                value.remove(at: indexPath.row)
                
            }).disposed(by: DisposeBag())
            
               }
        exerciseArr.onNext(value)

    }
    
    var exerciseArr = BehaviorSubject<[Exercise]>(value: [])
    
    
    func setBinds(){
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.rowHeight.onNext(70)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        let input = EditExerciseVM.Input(viewWillApearEvent :  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , edmitButtonTapped : edmitButton.rx.tap.asObservable() , inputArr : exerciseArr  , addButtonTapped : addButton.rx.tap.asObservable())
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.exerciseArr.bind(to: self.exerciseArr).disposed(by: disposeBag)
        
        self.exerciseArr.subscribe(onNext: { arr in
            
            self.totalTodayExerciseLabel.text = String(arr.count)
            
            
            
        }).disposed(by: disposeBag)
        
        exerciseArr.bind(to: tableView.rx.items(cellIdentifier: "ExerciseCell" ,cellType: ExerciseCell.self )){index,item,cell in
            cell.layoutToEdit()
            cell.exerciseGram.text = "\(item.finalCalorie)Kcal"
            cell.name.text = item.name
            cell.time.text = "\(item.time)분"
            cell.deleteButton.addTarget(self, action: #selector(self.delCell), for: .touchUpInside)
            
            
            
            
        }.disposed(by: disposeBag)
        

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        

        self.navigationController?.view.backgroundColor = .white
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
     
    
    
    func addSubView(){
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.edmitButton.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.backgroundColor = .white
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mainView)
        
        self.mainView.addSubview(topView)
        self.mainView.addSubview(tableView)
        self.mainView.addSubview(todayExerciseLabel)
        self.mainView.addSubview(totalTodayExerciseLabel)
        self.mainView.addSubview(bottomView)
        
        topView.addSubview(imageView)
        
        bottomView.addSubview(addButton)
        bottomView.addSubview(edmitButton)
        
        NSLayoutConstraint.activate([
            
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor , constant: 15),
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),

            
            
            edmitButton.heightAnchor.constraint(equalToConstant: 60),
            edmitButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 15),
            edmitButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15),
            edmitButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor , constant: -10 ),

            
            
            
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            
            
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 300),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            
            
            imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor , constant:  -(self.navigationController?.navigationBar.frame.height ?? 0)/2 ),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            
            
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor ,constant: 60),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            todayExerciseLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            todayExerciseLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            todayExerciseLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor , constant: 20),
            
            totalTodayExerciseLabel.topAnchor.constraint(equalTo: topView.bottomAnchor),
            totalTodayExerciseLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            totalTodayExerciseLabel.leadingAnchor.constraint(equalTo: todayExerciseLabel.trailingAnchor , constant: 0),
            
        ])
    }
    
}
