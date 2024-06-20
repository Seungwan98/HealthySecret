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
import RxCocoa
import SnapKit

class ComentsVC: UIViewController, UIScrollViewDelegate, ComentsCellDelegate {
    func profileTapped(comentsUuid: String) {
        self.profileTapped.onNext(comentsUuid)
        
    }
    
    func report(comentsUid: String) {
        let arr = coments.filter({$0.comentUid == comentsUid})
        guard let coment = arr.first else {return}
        self.reportTapped.onNext(coment)
    }
    
    func delete(comentsUid: String) {
        
        let arr = coments.filter({$0.comentUid == comentsUid})
        guard let coment = arr.first else {return}
        self.coments = coments.filter({$0.comentUid != comentsUid})
        self.tableView.reloadData()
        
        self.comentsDelete.onNext(coment)
        
    }
    
    var coments = [ComentModel]()
    
    
    let disposeBag = DisposeBag()
    
    private var viewModel: ComentsVM?
    
    init(viewModel: ComentsVM ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var BOTTOMVIEW_ORIGIN_Y: CGFloat?
    
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        
        return view
        
        
        
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .clear
        
        
        textView.font = .boldSystemFont(ofSize: 20)
        textView.isScrollEnabled = false
        
        
        
        return textView
        
        
        
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = true
        tableView.allowsSelection = false
        return tableView
    }()
    
    var backgroundView = CustomBackgroundView()
    
    
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
    
    
    func setUI() {
        
        self.view.backgroundColor = .white
        
        
        self.backgroundView.isHidden = true
        self.backgroundView.backgroundLabel.text = "아직 댓글이 없어요"
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.register(ComentsCell.self, forCellReuseIdentifier: "ComentsCell")
        
        self.textView.delegate = self
        textViewDidChange(textView)
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.backgroundView)
        
        self.view.addSubview(self.bottomView)
        
        
        self.bottomView.addSubview(self.textView)
        self.bottomView.addSubview(self.addButton)
        
        self.backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.tableView)
            $0.bottom.equalTo(self.view)
        }
        self.tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        self.addButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.trailing.equalTo(self.bottomView).inset(10)
            $0.centerY.equalTo(self.bottomView)
        }
        self.bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(self.textView)
            
        }
        self.textView.snp.makeConstraints {
            $0.leading.equalTo(self.bottomView).inset(10)
            $0.trailing.equalTo(self.bottomView).inset(40)
            $0.bottom.equalTo(self.bottomView)
            $0.height.equalTo(40)
        }
        
        
        
    }
    
    var comentsDelete = PublishSubject<ComentModel>()
    
    var profileTapped = PublishSubject<String>()
    
    var reportTapped = PublishSubject<ComentModel>()
    
    
    func setBindings() {
        addButton.rx.tap.asObservable().subscribe({ _ in
            
            self.textView.text = ""
        }).disposed(by: disposeBag)
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        var feedUuid = ""
        
        
        let input = ComentsVM.Input(addButtonTapped: addButton.rx.tap.asObservable(), coments: self.textView.rx.text.orEmpty.distinctUntilChanged().asObservable(), comentsDelete: comentsDelete.asObservable(), profileTapped: self.profileTapped.asObservable(), reportTapped: self.reportTapped.asObservable() )
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else {return}
        
        output.backgroundHidden.bind(to: self.backgroundView.rx.isHidden ).disposed(by: disposeBag)
        
        output.feedUuid.subscribe(onNext: { feedUid in
            
            feedUuid = feedUid
            
            
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        
        
        output.coments.bind(to: self.tableView.rx.items(cellIdentifier: "ComentsCell", cellType: ComentsCell.self )) { _, item, cell in
            cell.comentsLabel.text = item.coment
            cell.nicknameLabel.text = item.nickname
            
            cell.delegate = self
            cell.delegate = self
            cell.comentsVC = self
            
            
            
            let date = CustomFormatter.shared.getDifferDate(date: item.date)
            
            self.coments.append(item)
            
            cell.dateLabel.text = date
            
            cell.comentsUuid = item.uid
            
            cell.comentUid = item.comentUid
            
            
            // 작성자 표시
            if feedUuid == item.uid {
                
                cell.ownTitle.isHidden = false
                
            } else {
                
                cell.ownTitle.isHidden = true
                
            }
            
            if uid == item.uid {
                
                cell.mine = true
                
                
            } else {
                cell.mine = false
            }
            
            let profileImage = item.profileImage
            if !(profileImage.isEmpty) {
                
                
                let url = URL(string: profileImage )
                
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
        
        
        
        output.alert.subscribe(onNext: { _ in
            
            AlertHelper.shared.showResult(title: "신고가 접수되었습니다", message: "신고는 24시간 이내 검토 후 반영됩니다", over: self)
            
            
        }).disposed(by: disposeBag)
    }
    
    
}

extension ComentsVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView ) {
        if !(textView.text.isEmpty ) {
            self.addButton.backgroundColor = .systemBlue
            self.addButton.isEnabled = true
        } else {
            self.addButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
            self.addButton.isEnabled = false
        }
        let size = CGSize(width: textView.frame.width, height: .infinity)
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
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowComents(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideComents(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShowComents(_ noti: NSNotification) {
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.BOTTOMVIEW_ORIGIN_Y =  self.bottomView.frame.origin.y
            
            self.bottomView.frame.origin.y -= keyboardSize.height
            self.view.frame.size.height -= keyboardSize.height
        }
        
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHideComents(_ noti: NSNotification) {
        print("hide")
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.bottomView.frame.origin.y != self.BOTTOMVIEW_ORIGIN_Y {
                self.bottomView.frame.origin.y = self.BOTTOMVIEW_ORIGIN_Y ?? 0
            }
            self.view.frame.size.height += keyboardSize.height
            
            
        }
    }
}
