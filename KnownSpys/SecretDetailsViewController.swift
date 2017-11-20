import UIKit

protocol SecretDetailsDelegate: class {
    func passwordCrackingFinished()
}

class SecretDetailsViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var passwordLabel: UILabel!
    
    var spy: Spy
    weak var delegate: SecretDetailsDelegate?
    
    init(with spy: Spy, and delegate: SecretDetailsDelegate?) {
        self.spy = spy
        self.delegate = delegate
        
        super.init(nibName: "SecretDetailsViewController", bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showPassword()
        }
    }
    
    func showPassword() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        passwordLabel.text = spy.password
    }
    
    @IBAction func finishedButtonTapped(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
        
        delegate?.passwordCrackingFinished()
    }
}
