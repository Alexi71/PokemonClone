//
//  PokesViewController.swift
//  Pokemon Go
//
//  Created by Alexander Kotik on 11.08.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit

class PokesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        caughtPokemon = PokemonCoreDataHelper.getCaughtPokemon()
        uncaughtPokemon = PokemonCoreDataHelper.getUnCaughtPokemon()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backTabbed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        }
        else {
            return uncaughtPokemon.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var pokemon : Pokemon
        
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        }
        else {
            pokemon = uncaughtPokemon[indexPath.row]
        }
        cell.textLabel?.text = pokemon.name!
        
        if let imageName = pokemon.imageName {
            cell.imageView?.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0) {
            return "CAUGHT"
        }
        else {
            return "UNCAUGHT"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
