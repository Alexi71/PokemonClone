//
//  PokeAnnotation.swift
//  Pokemon Go
//
//  Created by Alexander Kotik on 11.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon :Pokemon
    
     init(coordinate : CLLocationCoordinate2D, pokemon:Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
    
}
