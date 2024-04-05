


//
//  ViewController.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class CommuVC : UIViewController, UIScrollViewDelegate , FeedCollectionCellDelegate {
    
    var likesChange = PublishSubject<[String:Int]>()
    
    var likes : [String:Bool] = [:]
    
    var likesCount : [String:[String]] = [:]
    
    var authUid : String = ""
    
    var likesButtonTapped = PublishSubject<[String:Bool]>()
    
    // (delegate) Cell터치 시.
    
    func didPressHeart(for index: String, like: Bool) {
        var beforeArr : [String] = []
        likesButtonTapped.onNext([index:like])
        
        if like{
            print(index)
            beforeArr = likesCount[index] ?? []
            beforeArr.append(authUid)
            likesCount[index] = beforeArr
            
        }else{
            likesCount.removeValue(forKey: index)
            
        }
        
        
    }
    
    
    
    
    let disposeBag = DisposeBag()
    
    
    
    
    private var viewModel : CommuVM?
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 860
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = true
        tableView.allowsSelection = false
        return tableView
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        
        
        
        
        return button
        
        
    }()
    
    
    
    init(viewModel : CommuVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authUid = UserDefaults.standard.string(forKey: "uid") ?? ""
        
        
        setUI()
        setBindings()
        
        
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    
    
    func setUI(){
        self.view.addSubview(tableView)
        self.view.addSubview(addButton)

        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.dataSource = nil
        tableView.register(FeedCollectionCell.self, forCellReuseIdentifier: "FeedCollectionCell")
        
        
        
        NSLayoutConstraint.activate([
            
            self.addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor , constant: -20 ),
            self.addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor , constant: -20 ),
            self.addButton.widthAnchor.constraint(equalToConstant: 50 ),
            self.addButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
        
    }
    
    
    
    func setBindings() {
        
        
        let input = CommuVM.Input( viewWillApearEvent:  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }), likesButtonTapped: likesButtonTapped, addButtonTapped: self.addButton.rx.tap.asObservable()  )
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
        
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
        
        
        output.likesCount.subscribe(onNext: { likesCount in
            
            self.likesCount = likesCount
            print("\(likesCount)")
            
        }).disposed(by: disposeBag)
        
        
        output.feedModel.bind(to: self.tableView.rx.items(cellIdentifier: "FeedCollectionCell" , cellType: FeedCollectionCell.self )){
            index,item,cell in
            
            cell.mainImage.image = nil
            
            if self.likesCount[item.feedUid]?.contains(self.authUid) == true {
                cell.likesButton.isSelected = true
                cell.isTouched = true
                
                
            }else{
                cell.likesButton.isSelected = false
                cell.isTouched = false
            }
            
            cell.feedUid = item.feedUid
            cell.delegate = self
            cell.setLikesLabel(count: self.likesCount[item.feedUid]?.count ?? 0 )
            
            cell.nicknameLabel.text = item.nickname
            
            print(item.feedUid)
            cell.beforeContent = item.contents
            cell.comentsLabel.text = "댓글 \(String(describing: item.coments?.count ?? 0))개 보기"
            
            
            if let url = URL(string: item.profileImage ?? ""){
                
                
                
                
                DispatchQueue.main.async {
                    
                    let processor = DownsamplingImageProcessor(size: cell.profileImage.bounds.size ) // 크기 지정 다운 샘플링
        // 모서리 둥글게
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
                
                
                
                cell.profileImage.layer.cornerRadius = 20

                
            }

            
            
            
            var images : [UIImageView] = []
            
            
            _ = item.mainImgUrl.map{
                if let url = URL(string: $0 ) {
                    let image = UIImageView()
                    let processor = DownsamplingImageProcessor(size: cell.mainImage.bounds.size) // 크기 지정 다운 샘플링
                    |> RoundCornerImageProcessor(cornerRadius: 0) // 모서리 둥글게
                    image.kf.indicatorType = .activity  // indicator 활성화
                    image.kf.setImage(
                        with: url,  // 이미지 불러올 url
                        placeholder: UIImage(),  // 이미지 없을 때의 이미지 설정
                        options: [
                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(0.5)),  // 애니메이션 효과
                            .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                        ])
                    
                    images.append(image)


                }
                
                cell.dateLabel.text = CustomFormatter.shared.getDifferDate(date: item.date) 
                

                
            }
            cell.imageViews = images
            cell.addContentScrollView()
            cell.setContentLabel()

            
            if(images.count > 1){
                cell.setPageControl()
            }
            
            
            
        }.disposed(by: disposeBag)
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}










