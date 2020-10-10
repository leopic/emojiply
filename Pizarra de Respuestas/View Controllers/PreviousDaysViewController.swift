import Foundation
import UIKit

final class PreviousDaysViewController: UITableViewController {
  public var days = [Day]()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = LocalizedStrings.Screen.Title.stats
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    days.count + 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 3 : 1
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section > 0 else {
      return LocalizedStrings.StatsScreen.summary
    }

    guard let date = days[section - 1].date else { return nil }

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    return dateFormatter.string(from: date)
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    section == 0 ? nil : "\(LocalizedStrings.StatsScreen.total): \(days[section - 1].events.count)"
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = UITableViewCell()
      cell.textLabel?.numberOfLines = 0
      cell.textLabel?.textAlignment = .center
      cell.textLabel?.font = Fonts.title1
      let summary = Summary(days: days)

      if indexPath.row == 0 {
        let top = summary.top(3).joined(separator: "    ")
        let bottom = LocalizedStrings.StatsScreen.mostUsed
        cell.textLabel?.text = "\(top)\n\(bottom)"
      }

      if indexPath.row == 1 {
        let top = days.count
        let bottom = LocalizedStrings.StatsScreen.daysUsing
        cell.textLabel?.text = "\(top)\n\(bottom)"
      }

      if indexPath.row == 2 {
        let top = summary.unique
        let bottom = LocalizedStrings.StatsScreen.uniqueAnswers
        cell.textLabel?.text = "\(top)\n\(bottom)"
      }

      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
      let day = days[indexPath.section - 1]
      cell.textLabel?.text = day.events.map { $0.value }.joined(separator: " ")
      cell.textLabel?.textAlignment = .center
      cell.textLabel?.font = Fonts.title2

      return cell
    }
  }
}
