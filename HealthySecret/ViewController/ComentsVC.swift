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
    func profileTapped(comentsUuid: String) {
        self.profileTapped.onNext(comentsUuid)
        
    }
    
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
    
    var BOTTOMVIEW_ORIGIN_Y : CGFloat?
    
    
    let bottomView : UIView = {
       let view = UIView()
        view.isUserInteractionEnabled = true
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
        self.hideKeyboardWhenTappedAround()
        setUI()
        setBindings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.title = "댓글"
        
        
        self.addKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.removeKeyboardNotifications()
        
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
            
            self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor , constant: 10),
            self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor , constant: -10 ),
            self.bottomView.bottomAnchor.constraint(equalTo : self.view.safeAreaLayoutGuide.bottomAnchor , constant: -10),
            self.bottomView.heightAnchor.constraint(equalTo: self.textView.heightAnchor ),
            
            self.textView.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor , constant: 10),
            self.textView.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor , constant: -40),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor),
            self.textView.heightAnchor.constraint(equalToConstant: 40)
        
        
        ])
        
        
    }
    
    var comentsDelete = PublishSubject<Coment>()
    
    var profileTapped = PublishSubject<String>()
    
    
    func setBindings(){
        
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        var feedUuid = ""

        
        let input = ComentsVM.Input(addButtonTapped : addButton.rx.tap.asObservable(), coments: self.textView.rx.text.orEmpty.asObservable() , comentsDelete : comentsDelete.asObservable() , profileTapped : self.profileTapped.asObservable()  )
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
        
        output.feedUuid.subscribe(onNext: { val in
            feedUuid = val
            
            
        }).disposed(by: disposeBag)
        
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
            
            cell.comentsUuid = item.uid
            
            cell.comentUid = item.comentUid
            
            
            //작성자 표시
            if(feedUuid == item.uid){
                
                cell.ownTitle.isHidden = false
                
            }else{
                
                cell.ownTitle.isHidden = true

            }
            
            if(uid == item.uid){
                
                cell.mine = true
                
                
            }else {
                cell.mine = false
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
extension ComentsVC {
    
  
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.BOTTOMVIEW_ORIGIN_Y =  self.bottomView.frame.origin.y
              
                   self.bottomView.frame.origin.y -= keyboardSize.height
            self.view.frame.size.height -= keyboardSize.height
           }
       
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomView.frame.origin.y != self.BOTTOMVIEW_ORIGIN_Y {
                self.bottomView.frame.origin.y = self.BOTTOMVIEW_ORIGIN_Y ?? 0
            }
            self.view.frame.size.height += keyboardSize.height
            
            
        }
    }
}
