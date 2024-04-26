


//
//  OtherProfileVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class OtherProfileVC : UIViewController , CustomCollectionCellDelegate{
    
    func imageTapped(feedUid: String) {
        
        self.imageTapped.onNext(feedUid)
    }
    
    
    
    
    
    
    let disposeBag = DisposeBag()
    
    var firstBind = true
    var loadControll = false

    
    private var viewModel : OtherProfileVM?
    
    
    init(viewModel : OtherProfileVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
   



    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
      
        
        collectionView.register( ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
        
        collectionView.allowsMultipleSelection = false
        collectionView.alwaysBounceVertical = true
        
        
        return collectionView
    }()
    
    
    
   
    
    
    
    var imageTapped = PublishSubject<String>()
    
    var outputProfileImage = BehaviorSubject<Data?>(value: nil)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        
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
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self.collectionView)
        
        
        NSLayoutConstraint.activate([
            
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor ),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor  ),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor ),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor ),
      
        
        
        
        
        
        ])
        
        
        
        
        
        
        
        
        
    }
    var imagesArr : [[String]] = []
    var uidsArr : [String] = []
    func setHeaderBindings(header : ProfileHeaderView){


        let input = OtherProfileVM.HeaderInput( viewWillApearEvent: header.appearEvent  ,  outputProfileImage: self.outputProfileImage.asObservable() )
                
                
        guard let output = self.viewModel?.HeaderTransform(input: input, disposeBag: header.disposeBag) else { return }

                
                
                Observable.zip( output.calorie , output.goalWeight , output.nowWeight , output.name , output.introduce , output.profileImage ).subscribe(onNext: { [self] in
                    
                    
                    
                    header.calorieLabel.text = $0 + " kcal"
                    header.goalWeight.text = $1 + " kg"
                    header.nowWeight.text = $2 + " kg"
                    header.introduceLabel.text = $4
                    
                    
                    self.navigationController?.navigationBar.topItem?.title = $3
                    
                    
                    
                    
                    let weight = (Double($1) ?? 0.0) - (Double($2) ?? 0.0)
                    
                    if weight > 0 {
                        header.gramLabel.text = "+" + String(weight) + " kg"
                    }else{
                        header.gramLabel.text = String(weight) + " kg"
                    }
                    
                    if let url = URL(string: $5 ?? ""){
                        
                     
                        DispatchQueue.main.async {
                            
                            
                            let processor = DownsamplingImageProcessor(size: header.profileImage.bounds.size) // 크기 지정 다운 샘플링
                            // 모서리 둥글게
                            
                            header.profileImage.kf.indicatorType = .activity  // indicator 활성화
                            header.profileImage.kf.setImage(
                                with: url,  // 이미지 불러올 url
                                placeholder: UIImage(named: "일반적.png"),  // 이미지 없을 때의 이미지 설정
                                options: [
                                    .processor(processor),
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.fade(0.5)),  // 애니메이션 효과
                                    .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                                ])
                            
                            
                            
                         
                            
                            
                            
                        }
                        
                        header.profileImage.layer.cornerRadius = 60

                    } else {
                        header.profileImage.layer.cornerRadius = 0
                        
                        let bottomImage = UIImage(named: "일반적.png")
                        let topImage = UIImage(named: "camera.png")
                        
                        
                        let bottomSize = CGSize(width: 300, height: 300)
                        let topSize = CGSize(width: 80, height: 80)
                        UIGraphicsBeginImageContext(bottomSize)
                        
                        let areaSize = CGRect(x: 0, y: 0, width: bottomSize.width, height: bottomSize.height)
                        let areaSize2 = CGRect(x: 212, y: 220, width: topSize.width, height: topSize.height)
                        bottomImage!.draw(in: areaSize)
                        
                        topImage!.draw(in: areaSize2 , blendMode: .normal , alpha: 1)
                        
                        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                        UIGraphicsEndImageContext()
                        
                        header.profileImage.image = newImage
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }).disposed(by: header.disposeBag)
     
        
       
        
        
    }
    
    
    func setBindings() {
        print("setbind")
    
        
        
        let input = OtherProfileVM.Input(viewWillApearEvent: self.rx.methodInvoked(#selector(viewWillAppear(_:))).map({ _ in }).asObservable()  , outputProfileImage : outputProfileImage.asObservable(), imageTapped: self.imageTapped.asObservable() 
                                      
        )
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: self.disposeBag) else { return }
        
        
        
    
            
    
            
        output.feedImage.subscribe( onNext: { [weak self] imagesArr in
            guard let imagesArr = imagesArr else { return }
            
            
            self?.loadControll = true

            
            self?.imagesArr = imagesArr
            self?.collectionView.reloadData()
            
        }).disposed(by: disposeBag)
        
        output.feedUid.subscribe( onNext: { [weak self] uidsArr in
            guard let uidsArr = uidsArr else { return }

            self?.uidsArr = uidsArr
            
        }).disposed(by: disposeBag)
       
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}

extension OtherProfileVC :  UICollectionViewDataSource , UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.imagesArr[indexPath.row])
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderView.identifier, for: indexPath) as? ProfileHeaderView  else {
            
            return UICollectionViewCell()
        }
        
        

        if(firstBind){
            print("바인드")
            self.setHeaderBindings(header: header)
            
            firstBind = false
        }

        if(loadControll){
            header.appearEvent.onNext(true)
            loadControll = false

        }

        print("header reload")
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.imagesArr.count)
        return self.imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let url = URL(string: self.imagesArr[indexPath.row].first ?? "" ){
            cell.delegate = self
            cell.feedUid = uidsArr[indexPath.row]
            
            if self.imagesArr[indexPath.row].count > 1 {
                cell.squareImage.isHidden = false
            }else{
                cell.squareImage.isHidden = true
            }
            
            DispatchQueue.main.async {
                
                let processor = DownsamplingImageProcessor(size: cell.image.bounds.size) // 크기 지정 다운 샘플링
                |> RoundCornerImageProcessor(cornerRadius: 0 ) // 모서리 둥글게
                cell.image.kf.indicatorType = .activity  // indicator 활성화
                cell.image.kf.setImage(
                    with: url,  // 이미지 불러올 url
                    placeholder: UIImage(),  // 이미지 없을 때의 이미지 설정
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(0.5)),  // 애니메이션 효과
                        .cacheOriginalImage // 이미 캐시에 다운로드한 이미지가 있으면 가져오도록
                    ])
            }
            
            
            
            
            
        }
        
        
        
        
        return cell
    }
    
}






extension OtherProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width / 3

        return CGSize(width: width  , height: width  )
    }
}


