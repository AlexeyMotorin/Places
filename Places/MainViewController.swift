//
//  TableViewController.swift
//  Places
//
//  Created by Алексей Моторин on 04.04.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Places>!
    
    private var filtredPlaces: Results<Places>! // тут отфильтрованные записи
   
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var ascendingSorting = true
    
    
    private lazy var placeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    private lazy var segmentSort: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Дата", "Имя"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .white
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var reversButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "",
                                     style: .plain, target: self,
                                     action: #selector(reversSorted))
        button.image = UIImage(systemName: "arrow.up")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(placeTableView)
        view.addSubview(segmentSort)
        
        NSLayoutConstraint.activate([
            segmentSort.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentSort.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentSort.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeTableView.topAnchor.constraint(equalTo: segmentSort.bottomAnchor),
            placeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        places = realm.objects(Places.self)
        setupNavigationBar()
        
        setupSearchController()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Мои места"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        placeTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    // MARK: setup NavigationBar
    private func setupNavigationBar() {
        navigationItem.title = "Мои места"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Snell Roundhand", size: 24) ?? 0]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showAddPlaceVC))
        
        navigationItem.leftBarButtonItem = reversButton
    }
    
    // MARK: setup searchController
    private func setupSearchController() {
        searchController.searchResultsUpdater = self // получать информации должен быть наш класс
        searchController.obscuresBackgroundDuringPresentation = false // позволяет взаимодействовать с результатом поиска
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController // добавили поиск в нав бар
        definesPresentationContext = true // позволяет отпустить поиск при переходе на другой экран
    }
    
    @objc private func showAddPlaceVC() {
        navigationController?.pushViewController(NewPlacesViewController(), animated: true)
    }
    
    @objc private func reversSorted() {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversButton.image = UIImage(systemName: "arrow.down")
            reversSort()
        } else {
            reversButton.image = UIImage(systemName: "arrow.up")
            reversSort()
        }
    }
    
    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        reversSort()
    }
    
    private func reversSort() {
        if segmentSort.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "namePlace", ascending: ascendingSorting)
        }
        placeTableView.reloadData()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtredPlaces.count
        }
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        var place = Places()
        
        if isFiltering {
            place = filtredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
        cell.namePlace.text = place.namePlace
        cell.locationPlace.text = place.locationPlace
        cell.typePlace.text = place.typePlace
        cell.imagePlace.image = UIImage(data: place.imageData!)
        cell.ratingCount.text = String(format: "%.0f", place.raiting)
        
        return cell
    }
    
    // MARK: Table view delegate
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let place = places[indexPath.row]
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .fade )
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var place = Places()
        
        if isFiltering {
            place = filtredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
        let placesVC = NewPlacesViewController()
        placesVC.currentPlace = place
        navigationController?.pushViewController(placesVC, animated: true)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ searchText: String) {
        filtredPlaces = places.filter("namePlace CONTAINS[c] %@ OR locationPlace CONTAINS[c] %@" , searchText, searchText)
        placeTableView.reloadData()
    }
}
