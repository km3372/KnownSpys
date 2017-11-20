import UIKit
import Toaster
import Foundation

class SpyListViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    fileprivate var presenter: SpyListPresenter!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        presenter = SpyListPresenter()
        
        SpyCell.register(with: tableView)
        
        presenter.loadData { [weak self] source in
            self?.newDataReceived(from: source)
        }
    }
    
    func newDataReceived(from source: Source) {
        Toast(text: "New Data from \(source)").show()
        tableView.reloadData()
    }
}


//MARK: - UITableViewDataSource
extension SpyListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presnter.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let spy = presenter.data[indexPath.row]

        let cell = SpyCell.dequeue(from: tableView, for: indexPath, with: spy)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SpyListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spy = data[indexPath.row]
        
        let detailViewController = DetailViewController.fromStoryboard(with: spy)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - Data Methods
extension SpyListViewController {
    
    func loadData(finished: @escaping BlockWithSource) {
        loadData { [weak self] source, spies in
            self?.data = spies
            finished(source)
        }
    }
}

//MARK: - Model Methods
extension SpyListViewController {
    
    func loadData(resultsLoaded: @escaping SpiesAndSourceBlock) {
        func mainWork() {
            
            loadFromDB(from: .local)
            
            loadFromServer { data in
                let dtos = self.createSpyDTOsFromJsonData(data)
                self.save(dtos: dtos) {
                    loadFromDB(from: .network)
                }
            }
        }
        
        func loadFromDB(from source: Source) {
            loadFromDBWith { spies in
                resultsLoaded(source, spies)
            }
        }
        
        mainWork()
    }
}

//MARK: - Network Methods
extension SpyListViewController {
    func loadFromServer(finished: @escaping (Data) -> Void) {
        print("loading data from server")
        
        Alamofire.request("http://localhost:8080/spies")
            .responseJSON
            { response in
                guard let data = response.data else { return }
                
                finished(data)
        }
    }
    
}





