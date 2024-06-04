


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

class CommuVC : UIViewController, UIScrollViewDelegate , FeedCollectionCellDelegate  , UITableViewDataSource, UITableViewDelegate {
    
    func getCell(idx : Int) -> FeedCollectionCell {
        
        var cell =  FeedCollectionCell()

        if(idx == 0 ){
            
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "firstCell") as! FeedCollectionCell

        }
        else if( (idx + 1 ) % 4  == 0){
            
            print("idx \(idx) count \(self.feeds.count)")
            
            cell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! FeedCollectionCell
            
        }
        else{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "FeedCollectionCell") as! FeedCollectionCell

        }
        
        return cell
        
    }
    
    
    func tolikeCount(idx : String) -> Bool{
        
        if self.likesCount[idx]?.contains(self.authUid) == true {
            
            return true
            
        }else{
            return false
        }
    }
    
  
                           
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.feeds.count
        
       
    
        
        return count

    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Cell의 애니메이션 중단
        cell.layer.removeAllAnimations()
        cell.alpha = 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let uid = UserDefaults.standard.string(forKey: "uid")
        
        
        
       
        let cell = getCell(idx: indexPath.row)
        
        let item = feeds[indexPath.row]
        


        
        cell.commuVC = self
        
        cell.delegate = self

        cell.feedUid = item.feedUid
        
        cell.beforeContent = item.contents



            
            
            
            if(uid!.contains(item.uuid)){
                
                cell.own = true
            }else{
                cell.own = false
            }
            
          
        let val = tolikeCount(idx: item.feedUid)
        
        cell.likesButton.isSelected = val
        cell.isTouched = val
          
            
            
            cell.setLikesLabel(count: self.likesCount[item.feedUid]?.count ?? 0 )
            
            cell.nicknameLabel.text = item.nickname
            
        cell.comentsLabel.text = "댓글 \(String(describing: item.coments.count ?? 0))개 보기"
            
            cell.dateLabel.text = CustomFormatter.shared.getDifferDate(date: item.date)

            
            let url = URL(string: item.profileImage ?? "")
            
            
            
            
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
                cell.profileImage.layer.cornerRadius = 20

                
            }
            
            
            
            
            
          
          
       
            
            
            DispatchQueue.main.async {

//
                
                
                
                var idx = 0
                
          
                let placeholdImage = UIImageView()
                placeholdImage.backgroundColor = .white
                let xPos = cell.scrollView.frame.width * CGFloat(idx)
                placeholdImage.frame = CGRect(x: xPos, y: 0, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height)
                cell.scrollView.addSubview(placeholdImage)
               
                
                
                _ = item.mainImgUrl.map{
                    let xPos = cell.scrollView.frame.width * CGFloat(idx)
                    placeholdImage.frame = CGRect(x: xPos, y: 0, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height)

                    print("mainImgUrl \(item.mainImgUrl)")
                    

                    if let url = URL(string: $0 ) {
                        let placeholdImage = UIImage()
                      
                        let image = UIImageView()
                        let processor = DownsamplingImageProcessor(size: CGSize(width: cell.contentView.bounds.width , height: cell.scrollView.bounds.height) ) // 크기 지정 다운 샘플링
                        |> RoundCornerImageProcessor(cornerRadius: 0) // 모서리 둥글게
                        image.kf.indicatorType = .activity  // indicator 활성화
                        image.kf.setImage(
                            with: url,  // 이미지 불러올 url
                            placeholder: placeholdImage ,  // 이미지 없을 때의 이미지 설정
                            options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.none),  // 애니메이션 효과
                                .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                            ])
                        
                        
                        
                        
                        image.frame = CGRect(x: xPos, y: 0, width: cell.scrollView.bounds.width, height: cell.scrollView.bounds.height)
                        cell.scrollView.contentSize.width = image.frame.width * CGFloat(idx + 1)

                        cell.scrollView.addSubview(image)
                        
                        
                    }
                    
                    idx = idx + 1
                    
                    
                }
                

                
                cell.setContentLabel()
                
                if(idx > 1){
                    
                    cell.setPageControl(count: idx)
                    
                }else{
                    
                    cell.setPageControl(count: 0)
                    
                }
            }
            
        
        return cell
        

    }
    
    var feeds  = [FeedModel]()
    
   
    
    
    func didPressedProfile(for index: String) {
        print("tapped")
        profileTapped.onNext(index)
    }
    
    func update(for index: String) {
        updateFeed.onNext(index)
    }
    
    
    func report(for index : String) {
        reportFeed.onNext(index)
    }
    
    func delete(for index : String) {
        
        deleteFeed.onNext(index)
        
    }
    func didPressedLikes(for index : String) {
        
        likesTapped.onNext(index)
        
    }
    
    var likesChange = PublishSubject<[String:Int]>()
    
    var likes : [String:Bool] = [:]
    
    var likesCount : [String:[String]] = [:]
    
    var authUid : String = ""
    
    var likesButtonTapped = PublishSubject<[String:Bool]>()
    
    var comentsTapped = PublishSubject<String>()
    
    var updateFeed = PublishSubject<String>()
    
    var reportFeed = PublishSubject<String>()
    
    var deleteFeed = PublishSubject<String>()
    
    var profileTapped = PublishSubject<String>()
    
    var likesTapped = PublishSubject<String>()
    
    var isPaging = false
    
    var isLastPage = false
    
    var isRefresh = false

    var backgroundView = CustomBackgroundView()
    
    let refreshControl = UIRefreshControl()
    
    
    // (delegate) Cell터치 시.
    func didPressHeart(for index: String, like: Bool) {
        var beforeArr : [String] = []
        likesButtonTapped.onNext([index:like])
        
        if like{
            beforeArr = likesCount[index] ?? []
            beforeArr.append(authUid)
            likesCount[index] = beforeArr
            
        }else{
            
            likesCount.removeValue(forKey: index)
            
        }
        
        
    }
    
    func didPressComents(for index: String) {
        
        self.comentsTapped.onNext(index)
        
    }
    
    
    
    let disposeBag = DisposeBag()
    
    
    
    
    private var viewModel : CommuVM?
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = true
        tableView.allowsSelection = false
    
        return tableView
    }()
    
    let addButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        
        
        
        
        return button
        
        
    }()
    

    
  
    private lazy var segmentControl: UISegmentedControl = {
        
        let segment = UnderlineSegmentedControl(items: [ "전체" , "팔로잉"])
        

       
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segment.setTitleTextAttributes(
             [
               NSAttributedString.Key.foregroundColor: UIColor.black,
               .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
             ],
             for: .selected
           )
        
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    
    
    
    let containerView = UIView()
    
    var segmentChanged = PublishSubject<Bool>()
    
    
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        print("didchangeValue")
            
            self.segmentChanged.onNext(segmentControl.selectedSegmentIndex == 0)

    }
    
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
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        
    }
    
    
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    func setUI(){
        
        
        
        self.segmentControl.addTarget(self, action: #selector(didChangeValue(segment: )), for: .valueChanged )

        
        self.view.backgroundColor = .white
        backgroundView.backgroundLabel.text = "아직 피드가 없어요"
        
        
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(segmentControl)
        
        self.view.addSubview(tableView)
        self.view.addSubview(addButton)
        self.view.addSubview(backgroundView)
        
        
        self.refreshControl.endRefreshing()
        tableView.refreshControl = self.refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedCollectionCell.self, forCellReuseIdentifier: "FeedCollectionCell")
        tableView.register(FeedCollectionCell.self, forCellReuseIdentifier: "firstCell")
        tableView.register(FeedCollectionCell.self, forCellReuseIdentifier: "lastCell")
       

        tableView.backgroundView = self.backgroundView
        
        self.containerView.snp.makeConstraints{
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(40)
        }
        self.segmentControl.snp.makeConstraints{
            $0.top.trailing.centerY.centerX.equalTo(self.containerView)
        }
        self.addButton.snp.makeConstraints{
            $0.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(50)
        }
        self.backgroundView.snp.makeConstraints{
            $0.top.equalTo(self.containerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.tableView.snp.makeConstraints{
            $0.top.equalTo(self.containerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
     
        
    }
    
    
    
    func setBindings() {
        
        let paging = PublishSubject<Bool>()
 
        
        let input = CommuVM.Input( viewWillAppearEvent:  self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }), likesButtonTapped: likesButtonTapped, comentsTapped: self.comentsTapped.asObservable() , addButtonTapped: self.addButton.rx.tap.asObservable() , deleteFeed: deleteFeed , reportFeed : reportFeed , updateFeed: updateFeed , paging : paging.asObservable() , profileTapped : profileTapped.asObservable(), likesTapped : self.likesTapped.asObservable() , refreshControl: self.refreshControl.rx.controlEvent(.valueChanged).asObservable()  , segmentChanged : segmentChanged.asObservable())
        
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {return}
       
        
        
        output.endRefreshing.subscribe(onNext: { event in
            if(event){
                
                self.refreshControl.endRefreshing()
            }
            
            
        }).disposed(by: disposeBag)
        
    
        
        
        output.likesCount.subscribe(onNext: { likesCount in
            _ = likesCount.map({ value in
                self.likesCount[value.key] = value.value
                
            })
            
        }).disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: false)
        }).disposed(by: disposeBag)
        
        

        
        output.feedModel.subscribe(onNext:{ [weak self] feeds in
            guard let self = self else {return}
            self.feeds = feeds
            self.backgroundView.isHidden = !(feeds.count <= 0 )
            
            self.tableView.reloadData()
            
            
        }).disposed(by: disposeBag)
        
        output.isLastPage.subscribe(onNext: { isLastPage in
            
            self.isLastPage = isLastPage
            
        }).disposed(by: disposeBag) 
        
        output.isPaging.subscribe(onNext: { isPaging in
            
            self.isPaging = isPaging
            
        }).disposed(by: disposeBag)
        
        
        
        
        self.tableView.rx.contentOffset.distinctUntilChanged({$0 == $1}).subscribe(onNext: {  a in
            
            let yOffset = self.tableView.contentOffset.y
            
            let contentHeight = self.tableView.contentSize.height
            let height = self.tableView.frame.height

            if yOffset > 0  && yOffset > (contentHeight - height) {

                if !(self.isPaging ) && !self.isLastPage {


                        paging.onNext(true)
                        self.isPaging = true
                        
                    }
                    
                
                
            }
            
            
        }).disposed(by: self.disposeBag)
        
        
        
        output.alert.subscribe(onNext: { _ in 
            
            AlertHelper.shared.showResult(title: "신고가 접수되었습니다", message: "신고는 24시간 이내 검토 후 반영됩니다", over: self)

        }).disposed(by: disposeBag)
        
    }
    
    
    
    
    
    
    
    
    
}










