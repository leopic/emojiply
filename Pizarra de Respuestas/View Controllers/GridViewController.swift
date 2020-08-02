import UIKit

class GridViewController: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!

  var screen = ScreenFactory.build(id: .home)!

  let itemsPerRow: CGFloat = 2
  let itemsPerColumn: CGFloat = 2
  static let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = screen.title
    navigationController?.navigationBar.barTintColor = Color.blackboard
    view.backgroundColor = Color.blackboard

    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.delegate = self

    guard screen.canUpdateOptions else { return }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeAnswersTapped))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.async { [weak self] in
      self?.collectionView.reloadData()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let gridViewController as GridViewController:
      if let option = sender as? Option,
        let screen = option.destination?.screen,
        let destinationScreen = ScreenFactory.build(id: screen) {
        gridViewController.screen = destinationScreen
      } else {
        print("error transitioning to another screen")
      }
    case let screenDetailViewController as ScreenDetailViewController:
      screenDetailViewController.screen = screen
    default:
      print("no op")
    }
  }

  @objc private func changeAnswersTapped() {
    guard screen.canUpdateOptions else { return }
    performSegue(withIdentifier: "showScreenDetail", sender: self)
  }
}
