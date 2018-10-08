//
//  ViewController.swift
//  DXUserDefaultsModel
//
//  Created by fashion on 2018/10/7.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefault = DXUserDefaultsModel.sharedInstance
        
        let weight = userDefault.weight
        print(weight)
        
        let height = userDefault.height
        print(height)
        
        let name = userDefault.name
        print(name)
        
        let interest = userDefault.interest
        print(interest)

        let isMan = userDefault.isMan
        print(isMan)
        
        let isLikeDog = userDefault.isLikeDog
        print(isLikeDog)
        
        let gender = userDefault.gender
        print(gender)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("---------------------")
        let userDefault = DXUserDefaultsModel.sharedInstance
        
        userDefault.weight = 22.0
        userDefault.height = 180.0
        userDefault.name = "lidongxi"
        userDefault.interest = "fighting"
        userDefault.isMan = false
        userDefault.isLikeDog = false
        userDefault.gender = 1

        print(userDefault.weight)
        print(userDefault.height)
        print(userDefault.name)
        print(userDefault.interest)
        print(userDefault.isMan)
        print(userDefault.isLikeDog)
        print(userDefault.gender)
    }

}
