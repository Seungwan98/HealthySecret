
import UIKit
import RxSwift
import SnapKit
final class SplashVC: UIViewController {
    private let viewModel: SplashVM
    init(viewModel: SplashVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.backgroundColor = .white
        setAutoLayout()
        startAnimation()
        
        viewModel.selectStart()
        
       
        
        viewModel.freeze.subscribe(onNext: { [weak self] _ in
            guard let self else {return}
            print("feeze")
            AlertHelper.shared.showResult(title: "계정 정지", message: "신고 누적으로 계정이 정지되었습니다" , over: self)
            
        }).disposed(by: disposeBag)
        
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "mainImage.jpeg")
        return imageView
    }()
     private lazy var mainView: UIImageView = {
        let view = UIImageView()
         view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        return view
    }()
    
    func startAnimation() {

    }
    
    private func setAutoLayout() {
        view.addSubview(mainView)

        view.addSubview(logoImageView)

   
        
        logoImageView.snp.makeConstraints{
            $0.centerX.centerY.equalTo(self.view)
            $0.height.width.equalTo(240)
        }
        
        mainView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalTo(self.view)
            
        }
        

    }
}
