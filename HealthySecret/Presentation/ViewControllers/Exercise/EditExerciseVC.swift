//
//  EditExerciseVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import SnapKit

class EditExerciseVC: UIViewController, UIScrollViewDelegate {
    let viewModel: EditExerciseVM?
    let disposeBag = DisposeBag()
    
    init(viewModel: EditExerciseVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainView = UIView()
    
    private let addButton: UIButton = {
        let button = UIButton()
        
        
        
        button.setTitle("추가", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue.withAlphaComponent(0.8)
        return button
    }()
    private let edmitButton: UIButton = {
        let button = UIButton()
        
        
        button.setTitle("기록하기", for: .normal)
        
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        return button
    }()
    
    
    
    
    private let topView: UIView = {
        let view =  UIView()
        
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
        return view
        
    }()
    
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_health.png"))
        
        return imageView
        
    }()
    
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = true
        tableView.register(EditExerciseCell.self, forCellReuseIdentifier: "ExerciseCell")
        
        return tableView
    }()
    
    let todayExerciseLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 한 활동 "
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
        
    }()
    
    let totalTodayExerciseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue.withAlphaComponent(0.8)
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    
    
    let bottomView = UIView()
    
    var exerciseArr = BehaviorSubject<[ExerciseModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubView()
        
        setBinds()
    }
    
    
    @objc
    func delCell( _ sender: UIButton) {
        
        let contentView = sender.superview
        let cell = contentView?.superview as! UITableViewCell
        var value: [ExerciseModel] = []
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
    
    
    
    func setBinds() {
        
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.rowHeight.onNext(70)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        let input = EditExerciseVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable(), edmitButtonTapped: edmitButton.rx.tap.asObservable(), inputArr: exerciseArr, addButtonTapped: addButton.rx.tap.asObservable())
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.exerciseArr.bind(to: self.exerciseArr).disposed(by: disposeBag)
        
        self.exerciseArr.subscribe(onNext: { arr in
            
            self.totalTodayExerciseLabel.text = String(arr.count)
            
            
            
        }).disposed(by: disposeBag)
        
        exerciseArr.bind(to: tableView.rx.items(cellIdentifier: "ExerciseCell", cellType: EditExerciseCell.self )) { _, item, cell in
            cell.layoutToEdit()
            cell.exerciseGram.text = "\(item.finalCalorie)Kcal"
            cell.name.text = item.name
            cell.time.text = "\(item.time)분"
            cell.deleteButton.addTarget(self, action: #selector(self.delCell), for: .touchUpInside)
            
            
            
            
        }.disposed(by: disposeBag)
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        
        
        self.navigationController?.view.backgroundColor = .white
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    
    
    func addSubView() {
        
        self.view.backgroundColor = .white
        mainView.backgroundColor = .white
        
        self.view.addSubview(mainView)
        
        self.mainView.addSubview(topView)
        self.mainView.addSubview(tableView)
        self.mainView.addSubview(todayExerciseLabel)
        self.mainView.addSubview(totalTodayExerciseLabel)
        self.mainView.addSubview(bottomView)
        
        topView.addSubview(imageView)
        
        bottomView.addSubview(addButton)
        bottomView.addSubview(edmitButton)
        
        
        mainView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(self.view)
        }
        addButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(100)
            $0.leading.equalTo(bottomView).inset(15)
            $0.centerY.equalTo(bottomView).offset(-10)
        }
        edmitButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalTo(addButton.snp.trailing).offset(15)
            $0.trailing.equalTo(bottomView).inset(15)
            $0.centerY.equalTo(bottomView).offset(-10)
        }
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(120)
            $0.centerX.equalTo(topView)
            $0.centerY.equalTo(topView).offset( -(self.navigationController?.navigationBar.frame.height ?? 0) / 2 )
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(60)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        todayExerciseLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.bottom.equalTo(tableView.snp.top)
            $0.leading.equalTo(topView).inset(20)
        }
        totalTodayExerciseLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(todayExerciseLabel)
            $0.leading.equalTo(todayExerciseLabel.snp.trailing)
        }
        
    }
    
}
