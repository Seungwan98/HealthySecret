//
//  EditIngredientsVC.swift
//  HealthySecret
//
//  Created by 양승완 on 2023/11/20.
//

import UIKit
import RxSwift
import SnapKit

class EditIngredientsVC: UIViewController, UIScrollViewDelegate {
    let viewModel: EditIngredientsVM?
    let disposeBag = DisposeBag()
    
    init(viewModel: EditIngredientsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        
        
        view.backgroundColor = UIColor(red: 0.09, green: 0.18, blue: 0.03, alpha: 1)
        
        
        return view
        
    }()
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        
        
        return imageView
        
    }()
    
    lazy var mealView: UIView = {
        let view = UIView()
        view.addSubview(imageView)
        
        
        view.layer.cornerRadius = 20
        view.backgroundColor =  UIColor(red: 0.949, green: 0.918, blue: 0.886, alpha: 1)
        
        return view
        
    }()
    
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = true
        tableView.register(EditIngredientsCell.self, forCellReuseIdentifier: "EditIngredientsCell")
        
        return tableView
    }()
    
    
    let todayIngredientsLabel: UILabel = {
        let label = UILabel()
        
        label.text = " "
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
        
    }()
    
    let todayTotalIngredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue.withAlphaComponent(0.8)
        label.font = .boldSystemFont(ofSize: 26)
        return label
    }()
    
    
    
    let bottomView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        setBinds()
    }
    
    @objc
    func delCell( _ sender: UIButton) {
        
        let contentView = sender.superview
        let cell = contentView?.superview as! UITableViewCell
        var value: [IngredientsModel] = []
        if let indexPath = self.tableView.indexPath(for: cell) {
            ingredientsArr.subscribe(onNext: { arr in
                value = arr
                
                value.remove(at: indexPath.row)
                
                
            }).disposed(by: DisposeBag())
        }
        
        self.ingredientsArr.onNext(value)
        
        
    }
    
    var ingredientsArr = BehaviorSubject<[IngredientsModel]>(value: [])
    
    
    func setBinds() {
        
        let imageArr = [UIImage(named: "edmitBreakfast.png"), UIImage(named: "edmitLunch.png"), UIImage(named: "edmitDinner.png"), UIImage(named: "edmitSnack.png")]
        
        todayIngredientsLabel.text = (UserDefaults.standard.string(forKey: "meal") ?? "")+" "
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.rowHeight.onNext(70)
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        let input = EditIngredientsVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable(), edmitButtonTapped: edmitButton.rx.tap.asObservable(), inputArr: ingredientsArr.asObservable(), addButtonTapped: addButton.rx.tap.asObservable())
        
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        output.ingredientsArr.bind(to: self.ingredientsArr).disposed(by: disposeBag)
        
        self.ingredientsArr.subscribe(onNext: { arr in
            self.todayTotalIngredientsLabel.text = String(arr.count)
            
            
            
        }).disposed(by: disposeBag)
        
        ingredientsArr.bind(to: tableView.rx.items(cellIdentifier: "EditIngredientsCell", cellType: EditIngredientsCell.self )) { _, item, cell in
            cell.kcal.text = String(item.calorie) + "kcal"
            cell.gram.text = String(Int(item.addServingSize ?? item.servingSize)) + "g"
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
    
    func setUI() {
        
        self.view.backgroundColor = .white
        
        
        
        self.view.addSubview(mainView)
        self.mainView.addSubview(topView)
        self.mainView.addSubview(tableView)
        self.mainView.addSubview(todayIngredientsLabel)
        self.mainView.addSubview(todayTotalIngredientsLabel)
        self.mainView.addSubview(bottomView)
        
        topView.addSubview(mealView)
        
        bottomView.addSubview(addButton)
        bottomView.addSubview(edmitButton)
        
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(100)
            $0.leading.equalTo(bottomView).inset(15)
        }
        edmitButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.equalTo(addButton.snp.trailing).offset(15)
            $0.trailing.equalTo(bottomView).inset(15)
        }
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(mainView)
            $0.height.equalTo(100)
        }
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.mainView.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
        mealView.snp.makeConstraints {
            $0.centerX.equalTo(topView)
            $0.height.width.equalTo(120)
            $0.centerY.equalTo(topView).offset( -( self.navigationController?.navigationBar.frame.height ?? 0 ) / 2 )
        }
        imageView.snp.makeConstraints {
            $0.centerX.centerY.equalTo(mealView)
            $0.height.width.equalTo(60)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(60)
            $0.leading.trailing.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
        mainView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.view)
        }
        todayIngredientsLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.bottom.equalTo(tableView.snp.top)
            $0.leading.equalTo(topView).inset(20)
        }
        todayTotalIngredientsLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.bottom.equalTo(tableView.snp.top)
            $0.leading.equalTo(todayIngredientsLabel.snp.trailing)
        }
        
    }
    
}
