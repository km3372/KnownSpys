import UIKit

class DetailPresenter {
    var spy: Spy!
    var imageName: String { return spy.imageName }
    var name: String { return spy.name }
    var age: String { return  String(spy.age) }
    var gender: String { return spy.gender }
    
    init(with spy: Spy) {
        self.spy = spy
    }
    
   
}

class DetailViewController: UIViewController, SecretDetailsDelegate {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    fileprivate var presenter: DetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func configure(with presnter: DetailPresenter) {
        self.presenter = presnter
    }
    
    func setupView() {
        profileImage.image = UIImage(named: presenter.imageName)
        nameLabel.text = presenter.name
        ageLabel.text  = presenter.age //String(spy.age)
        genderLabel.text = presenter.gender
    }
}

//MARK: - Touch Events
extension DetailViewController {
    @IBAction func briefcaseTapped(_ button: UIButton) {
        let vc = SecretDetailsViewController(with: spy, and: self as SecretDetailsDelegate)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SecretDetailsDelegate
extension DetailViewController {
    func passwordCrackingFinished() {
        //close middle layer too
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Helper Methods
extension DetailViewController {
    static func fromStoryboard(with spy: Spy) -> DetailViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.configure(with: spy)
        
        return vc
    }
}

