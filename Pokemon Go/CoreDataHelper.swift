//
//  CoreDataHelper.swift
//  Pokemon Go
//
//  Created by Alexander Kotik on 11.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import CoreData
 class PokemonCoreDataHelper {
    

    static func addAllPokemon () {
        createPokemon(name: "Pikachu", imageName: "pikachu-2")
        createPokemon(name: "Meowth", imageName: "meowth")
        createPokemon(name: "Pidgey", imageName: "pidgey")
        createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
        createPokemon(name: "Caterpie", imageName: "caterpie")
        createPokemon(name: "Charmander", imageName: "charmander")
        createPokemon(name: "Dratini", imageName: "dratini")
        createPokemon(name: "Eevee", imageName: "eevee")
        createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
        createPokemon(name: "Mankey", imageName: "mankey")
        createPokemon(name: "Mew", imageName: "mew")
    }
    
    
    


    static func createPokemon (name: String, imageName :String) {
             if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let item = Pokemon(entity: Pokemon.entity(), insertInto: context)
                item.name = name
                item.imageName = imageName
                try? context.save()
        }
    }

    static func getAllPokemon() -> [Pokemon]{
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let pokeData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
                if let pokemons = pokeData {
                    if pokemons.count == 0 {
                        addAllPokemon()
                        return getAllPokemon()
                    }
                    return pokemons
                }
            }
        }
        return []
    }

    static func getCaughtPokemon() -> [Pokemon] {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
            fetchRequest.predicate = NSPredicate(format: "caught ==%@", true as CVarArg)
            
            if let pokeData = try? context.fetch(fetchRequest)  {
                return pokeData
            }
            
        }
        return []
    }
    
    static func getUnCaughtPokemon() -> [Pokemon] {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
            fetchRequest.predicate = NSPredicate(format: "caught ==%@", false as CVarArg)
            
            if let pokeData = try? context.fetch(fetchRequest)  {
                return pokeData
            }
            
        }
        return []
    }
    
    static func Save() {
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            try? context.save()
        }
    }
}
