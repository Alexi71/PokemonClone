//
//  ViewController.swift
//  Pokemon Go
//
//  Created by Alexander Kotik on 11.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var allPokemons : [Pokemon] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPokemons = PokemonCoreDataHelper.getAllPokemon()
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           
            setup()
        }
        else {
             manager.requestWhenInUseAuthorization()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func setup() {
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        mapView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let loc = self.manager.location?.coordinate {
                var anno = loc
                anno.latitude += Double.random(min: -0.002, max: 0.002)
                anno.longitude += Double.random(min: -0.002, max: 0.002)
                let index :Int = Int(arc4random_uniform(UInt32(self.allPokemons.count)))
                let annotation = PokeAnnotation(coordinate: anno, pokemon: self.allPokemons[index])
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        print("tapped")
        if view.annotation is MKUserLocation {
            //user
        }
        else {
            //pokemon
            if let center = manager.location {
                if let pokeCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegionMakeWithDistance(pokeCenter, 200, 200)
                    mapView.setRegion(region, animated: false)
                    
                    if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(center.coordinate)) {
                        print ("you can catch it")
                        if let currentPoke = view.annotation as? PokeAnnotation {
                            currentPoke.pokemon.caught = true
                            PokemonCoreDataHelper.Save()
                            
                            let alervc = UIAlertController(title: "Congrats", message: "You caught a \(currentPoke.pokemon.name!)", preferredStyle: .alert)
                            let pokeAction = UIAlertAction(title: "PokeDex", style: .default, handler: { (action) in
                                self.performSegue(withIdentifier: "moveToPokeDex", sender: nil)
                            })
                            
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                alervc.dismiss(animated: true, completion: nil)
                            })
                            
                            alervc.addAction(pokeAction)
                            alervc.addAction(okAction)
                            present(alervc, animated: true, completion: nil)
                        }
                    }
                    else {
                        print ("No you can not catch it")
                        if let currentPoke = view.annotation as? PokeAnnotation {
                            let alervc = UIAlertController(title: "Oops", message: "You could not caught a \(currentPoke.pokemon.name!), you are our of reach", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                alervc.dismiss(animated: true, completion: nil)
                            })
                            
                           
                            alervc.addAction(okAction)
                            present(alervc, animated: true, completion: nil)
                        }
                    }
                }
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
        }
        else {
            if let pokeAnnotation = annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image = UIImage(named: imageName)
                }
            }
            
        }
        
        
        
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        annoView.frame = frame
        return annoView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            manager.stopUpdatingLocation()
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 400 , 400)
            mapView.setRegion(region, animated: true)
        }
        //if let center = location.coordinate {
        
        //}
       
    }
    @IBAction func compassTapped(_ sender: UIButton) {
        if let center = manager.location {
            let region = MKCoordinateRegionMakeWithDistance(center.coordinate, 400, 400)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

