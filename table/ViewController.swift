import UIKit
import SnapKit

protocol TaskComponent {
    var name: String { get }
    func addComponent(_ component: TaskComponent)
    func getChildComponent(at index: Int) -> TaskComponent?
}

class Task: TaskComponent {
    let name: String
    var subtasks: [TaskComponent] = []

    init(name: String) {
        self.name = name
    }

    func addComponent(_ component: TaskComponent) {
        subtasks.append(component)
    }

    func getChildComponent(at index: Int) -> TaskComponent? {
        if index < subtasks.count {
            return subtasks[index]
        }
        return nil
    }
}

class SubtaskViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let subtaskCellIdentifier = "subtaskCell"
    var task: Task? = nil
    var taskName: String? = nil
    var subtasks: [TaskComponent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        tableView.allowsMultipleSelectionDuringEditing = true
        makeConstraints()
    }
}

extension SubtaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: subtaskCellIdentifier)
        if let subtask = subtasks[indexPath.row] as? Task {
            cell.textLabel?.text = subtask.name
        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subtasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subtask = subtasks[indexPath.row] as? Task {
            let vc = SubtaskViewController()
            vc.task = subtask
            vc.taskName = subtask.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

private extension SubtaskViewController {
    @objc func addSubtask() {
        let alert = UIAlertController(title: "Add Subtask", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter subtask name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text else { return }
            let subtask = Task(name: name)
            self?.task?.addComponent(subtask)
            self?.subtasks.append(subtask)
            self?.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func setupScene() {
        title = taskName
        let barButton = UIBarButtonItem(title: "Add Subtask", style: .plain, target: self, action: #selector(addSubtask))
        navigationItem.rightBarButtonItem = barButton
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
    }

    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

class CustomCell: UITableViewCell {
    weak var navigationController: UINavigationController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let contactCellIdentifier = "contactCell"
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        tableView.allowsMultipleSelectionDuringEditing = true
        makeConstraints()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomCell(style: .default, reuseIdentifier: contactCellIdentifier)
        if let task = tasks[indexPath.row] as? Task {
            cell.textLabel?.text = task.name
        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.navigationController = navigationController
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = tasks[indexPath.row] as? Task {
            let vc = SubtaskViewController()
            vc.taskName = task.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

private extension ViewController {
    @objc func tap() {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter task name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text else { return }
            let task = Task(name: name)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func setupScene() {
        title = "Task List"
        let barButton = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(tap))
        navigationItem.rightBarButtonItem = barButton
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
    }

    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
