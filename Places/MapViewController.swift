//
//  MapViewController.swift
//  Places
//
//  Created by Алексей Моторин on 14.04.2022.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    
    var place = Places()
    let identifier = "identifier"
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    
    private var mapKit: MKMapView = {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }()
    
    private lazy var closeMapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(closeMap), for: .touchUpInside)
        return button
    }()
    
    private lazy var myLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "myLocation"), for: .normal)
        button.addTarget(self, action: #selector(showMyLocation), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPlaceMark()
        checkLocationAutorization()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(mapKit)
        mapKit.delegate = self
        
        mapKit.addSubview(closeMapButton)
        mapKit.addSubview(myLocationButton)
        
        NSLayoutConstraint.activate([
            closeMapButton.topAnchor.constraint(equalTo: mapKit.topAnchor, constant: 60),
            closeMapButton.trailingAnchor.constraint(equalTo: mapKit.trailingAnchor, constant: -40),
            closeMapButton.heightAnchor.constraint(equalToConstant: 30),
            closeMapButton.widthAnchor.constraint(equalToConstant: 30),
            
            myLocationButton.bottomAnchor.constraint(equalTo: mapKit.bottomAnchor, constant: -70),
            myLocationButton.trailingAnchor.constraint(equalTo: mapKit.trailingAnchor, constant: -40),
            myLocationButton.heightAnchor.constraint(equalToConstant: 50),
            myLocationButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func closeMap() {
        dismiss(animated: true)
    }
    
    @objc private func showMyLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapKit.setRegion(region, animated: true)
        }
    }
    
    private func setupPlaceMark() {
        guard let location = place.locationPlace else { return }
        
        // класс позваляет преобразовать координаты широты и долготы
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            // используется для описания точки на карте
            let annotation = MKPointAnnotation()
            annotation.title = self.place.namePlace
            annotation.subtitle = self.place.typePlace
            
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapKit.showAnnotations([annotation], animated: true)
            self.mapKit.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    private func checkLocationServices() {
        // проверка включена ли геолокация
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAutorization()
        } else {
            
        }
        
    }
    
    private func setupLocationManager() {
        // определение места нахождение
        locationManager.delegate = self 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // проверка статуса на использование геопозиции
    private func checkLocationAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Ваша локация недоступна", message: "Перейдите в настройки Places -> Геолокация")
            }
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapKit.showsUserLocation = true
            break
            
        @unknown default:
            fatalError()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    // отображение аннтонации
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // если проверяем отображение пользователя, тогда выходим из метода
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
        }
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorization()
    }
}
