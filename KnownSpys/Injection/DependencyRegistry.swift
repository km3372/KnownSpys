import UIKit
import Swinject
import SwinjectStoryboard

class DependencyRegistry {

    var container: Container
    
    init(container: Container) {
        
        Container.loggingFunction = nil
        
        self.container = container
        
        registerDependencies()
        registerPresenters()
        registerViewControllers()
    }
    
    func registerDependencies() {
        
        container.register(NetworkLayer.self    ) { _ in NetworkLayer()  }.inObjectScope(.container)
        container.register(DataLayer.self       ) { _ in DataLayer()     }.inObjectScope(.container)
        container.register(SpyTranslator.self   ) { _ in SpyTranslator() }.inObjectScope(.container)
        
        container.register(TranslationLayer.self) { r in
            TranslationLayer(spyTranslator: r.resolve(SpyTranslator.self)!)
        }.inObjectScope(.container)

        container.register(ModelLayer.self){ r in
            ModelLayer(dataLayer:        r.resolve(DataLayer.self)!,
                             networkLayer:     r.resolve(NetworkLayer.self)!,
                             translationLayer: r.resolve(TranslationLayer.self)!)
        }.inObjectScope(.container)
    }
    
    func registerPresenters() {
        container.register(SpyListPresenter.self) { r in SpyListPresenter(modelLayer: r.resolve(ModelLayer.self)!) }
        container.register( DetailPresenter.self) { (r, spy: SpyDTO)  in DetailPresenter(with: spy) }
        container.register(SpyCellPresenter.self) { (r, spy: SpyDTO) in SpyCellPresenter(with: spy) }
        container.register(SecretDetailsPresenter.self) { (r, spy: SpyDTO) in SecretDetailsPresenter(with: spy) }
    }
    
    func registerViewControllers() {
        container.register(SecretDetailsViewController.self) { (r, spy: SpyDTO, delegate: SecretDetailsDelegate) in
            let presenter = r.resolve(SecretDetailsPresenter.self, argument: spy)!
            return SecretDetailsViewController(with: presenter, and: delegate)
        }
        container.register(DetailViewController.self) { (r, spy:SpyDTO) in
            let presenter = r.resolve(DetailPresenter.self, argument: spy)!

            //NOTE: We don't have access to the constructor for this VC so we are using method injection
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.configure(with: presenter, secretDetailsViewControllerMaker: self.makeSecretDetailsViewController)
            return vc
        }
    }

    //MARK: - Maker Methods
    typealias SpyCellMaker = (UITableView, IndexPath, SpyDTO) -> SpyCell
    func makeSpyCell(for tableView: UITableView, at indexPath: IndexPath, spy: SpyDTO) -> SpyCell {
        let presenter = container.resolve(SpyCellPresenter.self, argument: spy)!
        let cell = SpyCell.dequeue(from: tableView, for: indexPath, with: presenter)
        return cell
    }
    
    typealias DetailViewControllerMaker = (SpyDTO) -> DetailViewController
    func makeDetailViewController(with spy: SpyDTO) -> DetailViewController {
        return container.resolve(DetailViewController.self, argument: spy)!
    }

    typealias SecretDetailsViewControllerMaker = (SpyDTO, SecretDetailsDelegate)  -> SecretDetailsViewController
    func makeSecretDetailsViewController(with spy: SpyDTO, delegate: SecretDetailsDelegate) -> SecretDetailsViewController {
        return container.resolve(SecretDetailsViewController.self, arguments: spy, delegate)!
    }
}
