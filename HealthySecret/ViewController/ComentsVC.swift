//
//  ComentsVC.swift
//  HealthySecret
//
//  Created by 양승완 on 4/4/24.
//

import Foundation
import UIKit
import RxSwift
import Kingfisher

class ComentsVC : UIViewController, UIScrollViewDelegate , ComentsCellDelegate {
    func report(comentsUid : String) {
       let arr = coments.filter({$0.comentUid == comentsUid})
        guard let coment = arr.first else {return}
        //self.comentsDelete.onNext(coment)
    }
    
    func delete(comentsUid : String) {
        
        let arr = coments.filter({$0.comentUid == comentsUid})
        guard let coment = arr.first else {return}
        self.comentsDelete.onNext(coment)

    }
    
    var coments = [Coment]()
    
    
    let disposeBag = DisposeBag()
    
    private var viewModel : ComentsVM?

    init(viewModel : ComentsVM ){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let bottomView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)


        return view
        
        
        
    }()
    
    let addButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textView : UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false // for auto layout
          

        textView.font = .boldSystemFont(ofSize: 20)
                textView.isScrollEnabled = false
                
        
        
        return textView
        
        
        
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = true
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        setUI()
        setBindings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.title = "댓글"
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    func setUI(){
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.register(ComentsCell.self, forCellReuseIdentifier: "ComentsCell")
        
        self.textView.delegate = self
        textViewDidChange(textView)

        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomView)
        self.bottomView.addSubview(self.textView)
        self.bottomView.addSubview(self.addButton)
        
        
        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            self.addButton.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor , constant: -10 ),
            self.addButton.widthAnchor.constraint(equalToConstant: 30 ),
            self.addButton.heightAnchor.constraint(equalToConstant: 30 ),
            self.addButton.centerYAnchor.constraint(equalTo: self.bottomView.centerYAnchor ),
            
            self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 40),
            self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -10 ),
            self.bottomView.bottomAnchor.constraint(equalTo : self.view.bottomAnchor , constant: -40),
            self.bottomView.heightAnchor.constraint(equalTo: self.textView.heightAnchor ),
            
            self.textView.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 10),
            self.textView.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor , constant: -40),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor),
            self.textView.heightAnchor.constraint(equalToConstant: 40)
        
        
        ])
        
        
    }
    
    var comentsDelete = PublishSubject<Coment>()
    
    
    func setBindings(){
        
        
        let uid = UserDefaults.standard.string(forKey: "uid")

        
        let input = ComentsVM.Input(addButtonTapped : addButton.rx.tap.asObservable(), coments: self.textView.rx.text.orEmpty.asObservable() , comentsDelete : comentsDelete.asObservable())
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        
        
        
        output.coments.bind(to: self.tableView.rx.items(cellIdentifier: "ComentsCell" , cellType: ComentsCell.self )){
            index,item,cell in
            cell.comentsLabel.text = item.coment
            cell.nicknameLabel.text = item.nickname
            
            cell.delegate = self
            cell.comentsVC = self
            
            
            
            let date = CustomFormatter.shared.getDifferDate(date: item.date)
            
            self.coments.append(item)
            
            cell.dateLabel.text = date
            
            cell.comentUid = item.comentUid
            
            if(uid == item.uid){
                
                cell.ownTitle.isHidden = false
                
            }else{
                
                cell.ownTitle.isHidden = true

            }
            
            if (!item.profileImage.isEmpty){
                
                
                let url = URL(string: item.profileImage )
                
                DispatchQueue.main.async {
                    
                    let processor = DownsamplingImageProcessor(size: cell.profileImage.bounds.size ) // 크기 지정 다운 샘플링

                    cell.profileImage.kf.indicatorType = .activity  // indicator 활성화
                    cell.profileImage.kf.setImage(
                        with: url,  // 이미지 불러올 url
                        placeholder: UIImage(named: "일반적.png"),  // 이미지 없을 때의 이미지 설정
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(0.5)),  // 애니메이션 효과
                            .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                        ])
                    
                    
                }
                
                
                
               // cell.profileImage.layer.cornerRadius = 20

                
            }
            
        }.disposed(by: disposeBag)
    }
    
    
}
    
extension ComentsVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView ) {
        if(textView.text.count > 0) {
            self.addButton.backgroundColor = .systemBlue
            self.addButton.isEnabled = true
        }else{
            self.addButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
            self.addButton.isEnabled = false
        }
        let size = CGSize(width: textView.frame.width , height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
       
    }
    
}
