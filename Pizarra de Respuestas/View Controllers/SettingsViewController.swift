import Foundation
import UIKit

final class SettingsController: UITableViewController {
  private var settings = UserPreferences()
  private let logger = Logger.shared
  private var days = [Day]() {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    days = logger.getAll()

    navigationItem.title = LocalizedStrings.Screen.Title.settings
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 2 : 3
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    section == 0 ? LocalizedStrings.SettingsScreen.feedbackOptions : nil
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell

      if indexPath.row == 0 {
        cell.setting = .sound
      }

      if indexPath.row == 1 {
        cell.setting = .vibration
      }

      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
      cell.accessoryType = .disclosureIndicator

      if indexPath.row == 0 {
        cell.textLabel?.text = LocalizedStrings.SettingsScreen.stats
      }

      if indexPath.row == 1 {
        cell.textLabel?.text = LocalizedStrings.SettingsScreen.faq
      }

      if indexPath.row == 2 {
        cell.textLabel?.text = LocalizedStrings.SettingsScreen.acknowledgments
      }

      return cell
    }
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard section == 1,
          let appInfo = Bundle.main.infoDictionary,
          let shortVersionString = appInfo["CFBundleShortVersionString"] as? String else {
      return nil
    }

    return "\(LocalizedStrings.SettingsScreen.appVersion) \(shortVersionString)"
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 1 else { return }

    if indexPath.row == 0 {
      performSegue(withIdentifier: "showPreviousDays", sender: self)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "showPreviousDays",
          let previousDays = segue.destination as? PreviousDaysViewController else {
      return
    }

    previousDays.days = days
  }

  @objc private func doneTapped() -> Void {
    dismiss(animated: true, completion: nil)
  }
}
