//
//  ChangeProfileVC.swift
//  MovieProject
//
//  Created by 양승완 on 2023/10/04.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class AddFeedVC : UIViewController {
    
    let disposeBag = DisposeBag()

    private var viewModel : AddFeedVM?

    var imagesArr : [UIImage] = []
    
    private let maxCount = 100
    
       private var textCount = 0 {
           didSet { self.writeContentLabel.text = "\(textCount)/\(maxCount)" }
       }
    
    lazy var writeContentLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "0/\(self.maxCount)"
        return label
        
        
    }()
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView : UIView = {
        let view = UIView()
        return view
    }()
    
  
    
   
    
    lazy var addFeedTextView : UITextView = {
        // Create a TextView.
        let textView: UITextView = UITextView()
        

        // Round the corners.
        textView.backgroundColor = .lightGray.withAlphaComponent(0.2)

        // Set the size of the roundness.
        textView.layer.cornerRadius = 10

        textView.textAlignment = .left
        
        
        textView.font = UIFont.boldSystemFont(ofSize: 18)

        // Set font color.
        textView.textColor = UIColor.black

        // Set left justified.
        textView.textAlignment = NSTextAlignment.left

        // Automatically detect links, dates, etc. and convert them to links.
        textView.dataDetectorTypes = UIDataDetectorTypes.all
  

        // Make text uneditable.
        textView.isEditable = true

        
        textView.tintColor = .black
        
        return textView
    }()

        
    let bottomView = UIView()
    
    private let addButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .black
    
        
        button.setTitle("완료", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let firstLabel : UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 26)
        label.text = "오늘의 일상을\n공유하여 주세요."
        label.numberOfLines = 2
        return label
    }()
    
    
    private let imageLabel : UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray.withAlphaComponent(0.8)
        label.text = "사진 등록(최대 5장)"
     
        return label
    }()
    
   
    

    
    
    let IMAGE_HEIGHT = CGFloat(100)
    let IMAGE_WIDTH = CGFloat(100)
    let plusImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus")
        image.layer.cornerRadius = 30

        image.backgroundColor = .lightGray.withAlphaComponent(0.2)
        image.tintColor = .lightGray.withAlphaComponent(0.6)
        image.snp.makeConstraints{
            $0.width.height.equalTo(120)
        }

        
       return image
    }()
    
    lazy var imageStackView : UIStackView = {
            
 
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
        
    }()
    
    
    
    
    private let informationLabel : UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray.withAlphaComponent(0.8)
        label.text = "내용"
     
        return label
    }()
    
    
    let imageScrollView = UIScrollView()
    
    //rxSwift
    //
    var imagesDatas = BehaviorSubject<[UIImage]>(value: [])

    
    
    init(viewModel : AddFeedVM){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationController?.navigationBar.backgroundColor = .white

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUI()
        setBindings()
        settingStackView()
        
    }
    
    
    
    func getInputView(image : UIImage ) -> UIView {
        let inputView = UIView()
        let inputImage = UIImageView()
    
        inputImage.layer.masksToBounds = true
        inputImage.layer.cornerRadius = 30
        inputImage.image = image
        inputView.addSubview(inputImage)


        inputView.snp.makeConstraints{
            $0.width.height.equalTo(120)
        }
        inputImage.snp.makeConstraints{
            $0.trailing.leading.top.bottom.equalTo(inputView)
        }

        
        return inputView
    }
    
    
    var index = 0
    func settingStackView(){
        
        self.imagesDatas.onNext(self.imagesArr)
        
        _ = self.imageStackView.arrangedSubviews.map{
            $0.removeFromSuperview()
            
        }
        print("\(self.imageStackView.arrangedSubviews.count ) settingStackview")

        if self.imagesArr.count <= 5 {
            print(imagesArr.count)
            for i in 0..<self.imagesArr.count {
                print(imagesArr.count)
                for i in 0..<self.imagesArr.count {
                    
                  
                    let inputView = self.getInputView(image: self.imagesArr[i])
                    
                    
                    
                    
                    let minusImage = UIButton()
                    inputView.addSubview(minusImage)

                    self.imageStackView.addArrangedSubview(inputView)
                    minusImage.tintColor = .lightGray
                    minusImage.setImage(UIImage(systemName: "x.circle.fill"), for: .normal )
                    minusImage.contentVerticalAlignment = .fill
                    minusImage.contentHorizontalAlignment = .fill
                    minusImage.backgroundColor = .white
                    minusImage.layer.cornerRadius = 13
                    minusImage.tag = i
                    minusImage.addTarget(self, action: #selector(removeImage), for: .touchUpInside )
                    
                    minusImage.snp.makeConstraints{
                        $0.trailing.top.equalTo(inputView)
                        $0.width.height.equalTo(24)
                    }
         
                    
                }
                if(self.imagesArr.count <= 4){
                    self.imageStackView.addArrangedSubview(self.plusImage)

                }
                
     
            }
            if(self.imagesArr.count <= 4){
                self.imageStackView.addArrangedSubview(self.plusImage)

            }
            
 
        }else{
            _ = self.imagesArr.map{
                self.imageStackView.addArrangedSubview(self.getInputView(image: $0))
                
            }
        }
        
        
        
    }
    
    
    @objc
    func removeImage(_ sender : UIButton ){
        //self.imageStackView.removeArrangedSubview()
        print("\(sender.tag)  sender tag")

        
        self.imagesArr.remove(at: sender.tag)
        self.settingStackView()
        
    }

    
    let mainView = UIView()

    func setUI(){
        
        self.view.backgroundColor = .white

        addFeedTextView.delegate = self
        addFeedTextView.text = "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다."
        addFeedTextView.textColor = .lightGray
        

        mainView.backgroundColor = .white

        self.view.addSubview(mainView)
        self.mainView.addSubview(contentScrollView)
        self.mainView.addSubview(bottomView)
        
        self.contentScrollView.addSubview(contentView)
        
        bottomView.addSubview(addButton)
        

        contentView.addSubview(imageScrollView)
        contentView.addSubview(addFeedTextView)
        contentView.addSubview(firstLabel)
        contentView.addSubview(informationLabel)
        contentView.addSubview(imageLabel)
        contentView.addSubview(writeContentLabel)
        
    
        imageScrollView.addSubview(imageStackView)
    
        
        

            
          
        mainView.snp.makeConstraints{
            $0.leading.trailing.bottom.top.equalTo(self.view)
        }
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalTo(self.view)
            $0.height.equalTo(100)
        }
        addButton.snp.makeConstraints{
            $0.leading.trailing.equalTo(bottomView).inset(20)
            $0.height.equalTo(60)
            $0.centerY.equalTo(bottomView).offset(-10)
        }
        contentScrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        contentView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.width.equalTo(self.contentScrollView)
            $0.height.equalTo(600)
        }
        firstLabel.snp.makeConstraints{
            $0.top.equalTo(contentView)
            $0.leading.equalTo(contentView).inset(20)
        }
        imageLabel.snp.makeConstraints{
            $0.top.equalTo(firstLabel.snp.bottom).offset(60)
            $0.leading.equalTo(contentView).inset(20)
        }
        imageScrollView.snp.makeConstraints{
            $0.top.equalTo(imageLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(self.contentView).inset(20)
            $0.height.equalTo(120)
        }
        imageStackView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.height.equalTo(imageScrollView)
        }
        informationLabel.snp.makeConstraints{
            $0.top.equalTo(imageScrollView.snp.bottom).offset(40)
            $0.leading.equalTo(contentView).inset(20)
        }
        addFeedTextView.snp.makeConstraints{
            $0.top.equalTo(informationLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(260)
        }
        writeContentLabel.snp.makeConstraints{
            $0.trailing.bottom.equalTo(addFeedTextView).inset(5)
            
        }
      
  
    }
   
    
    let feedTextChanged = BehaviorSubject<Int>(value: 0)
    
    
    func setBindings(){

        
        let imagesDataChanged = self.imagesDatas.map({ !$0.isEmpty }).distinctUntilChanged()

        Observable.combineLatest( feedTextChanged.map({  $0 != 0  }).distinctUntilChanged() , imagesDataChanged ){$0 && $1}.subscribe(onNext: { event in
            if(event){
                self.addButton.backgroundColor = .black
            }else{
                self.addButton.backgroundColor = .lightGray
            }
            self.addButton.isEnabled = event
            
            
        }).disposed(by: disposeBag)
        
        
        let input = AddFeedVM.Input(addButtonTapped: self.addButton.rx.tap.asObservable() , feedText : self.addFeedTextView.rx.text.orEmpty.asObservable()  , imagesDatas : self.imagesDatas.asObservable() )
        
        guard let output = self.viewModel?.transform(input: input, disposeBag: disposeBag) else {return}

       
        self.plusImage.rx.tapGesture().when(.recognized).subscribe(onNext:{ _ in
            self.actionSheetAlert()

            
            
        }).disposed(by: disposeBag)
        

        
       
        
    }
    
 
  
    
   
    




}

extension AddFeedVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func actionSheetAlert(){
        
        let privacyChecker = PrivacyChecker(viewController: self)
        
        let alert = UIAlertController(title: "선택", message: "", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] (_) in
            privacyChecker.requestCameraPermission()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
            privacyChecker.requestAlbumPermission()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        //alert.addAction(replaceImage)
        
        present(alert, animated: true, completion: nil)
        
    }
    
   
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("picker -> \(String(describing: info[UIImagePickerController.InfoKey.imageURL]))")
        
        
        
        var newImage: UIImage? = nil // update 할 이미지
               
               if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                   newImage = possibleImage // 수정된 이미지가 있을 경우
               } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   newImage = possibleImage // 원본 이미지가 있을 경우
               }
        
       

        guard let newImage = newImage else {return}
        
        
        
        
 
        
        
        self.imagesArr.append(newImage)
        
        self.settingStackView()
        
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddFeedVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
   
        if textView.text.count <= 0 {
            
            textView.textColor = .lightGray
            textView.text = "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다."

            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text.count <= 0 {
            
            textView.textColor = .lightGray
            textView.text = "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다."

            
        }else if(textView.text == "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다." && textView.textColor == .lightGray){
            textView.text = ""
            textView.textColor = .black
            
        }else{
            textView.textColor = .black

        }
       

        
    }
    
    func textView(
           _ textView: UITextView,
           shouldChangeTextIn range: NSRange,
           replacementText text: String
       ) -> Bool {
           
           
           let lastText = textView.text as NSString
           let allText = lastText.replacingCharacters(in: range, with: text)

           let canUseInput = allText.count <= maxCount

           defer {
               if canUseInput {
                   textCount = allText.count
               } else {
                   textCount = textView.text.count
               }
               self.feedTextChanged.onNext(textCount)
           }
           
           guard !canUseInput else { return canUseInput }
           
               if textView.text.count < maxCount {
                 
                   
                   let appendingText = text.substring(from: 0, to: maxCount - textView.text.count - 1)
                   textView.text = textView.text.inserting(appendingText, at: range.lowerBound)
                   
                   let isLastCursor = range.lowerBound >= textView.text.count
                   let movingCursorPosition = isLastCursor ? maxCount : (range.lowerBound + appendingText.count)
                   DispatchQueue.main.async {
                       textView.selectedRange = NSMakeRange(movingCursorPosition, 0)
                   }
               } else {

                   DispatchQueue.main.async {
                       textView.selectedRange = NSMakeRange(range.lowerBound, 0)
                   }
               }

           return canUseInput
       }
   }






