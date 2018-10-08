//
//  DXUserDefaultsModel.swift
//  DXUserDefaultsModel
//
//  Created by fashion on 2018/10/7.
//  Copyright © 2018年 shangZhu. All rights reserved.
// Objective-C 版本 https://www.jianshu.com/p/681ef055f716 下载地址: https://github.com/liuchongfaye/NSUserDefaultsModel

import UIKit

@objcMembers class DXUserDefaultsModel: NSObject {
    
    @objc public var name : String = "chuanzhang"
    @objc public var interest : String = "swimming"
    @objc public var isMan : Bool = true
    @objc public var isLikeDog : Bool = true
    @objc public var gender : NSInteger = 0
    @objc public var height : CGFloat = 0.0
    @objc public var weight : Double = 0.0
    
    static public let sharedInstance = DXUserDefaultsModel()
    private static var properties = [String: String]()
    private static let userDefaults: UserDefaults = {
        
        if let tempDefault = UserDefaults.init(suiteName: "dx.UserDefatults"){
            return tempDefault
        }else{
            return UserDefaults.standard
        }
    }()
    
    private override init() {
        super.init()
        exchangeAccessMethods()
    }

    //MARK: - Private Methods
    private func exchangeAccessMethods() {
        var count : UInt32 = 0
        let propertyList = class_copyPropertyList(self.classForCoder, &count)
        
        for i in 0..<Int(count) {
            if let list = propertyList {
                let property = list[i]
                let propertyName = property_getName(property)
                
               // print(propertyName) // 0x000000010626916a
                if let getterKey = String.init(utf8String: propertyName),getterKey.count>1,let propertyAttributes = property_getAttributes(property)  {
                   // print(getterKey) // name
                    let startSlicingIndex = getterKey.index(getterKey.startIndex, offsetBy: 0)
                    let uppercaseStr = getterKey[...startSlicingIndex].uppercased()
                   // print(uppercaseStr) // n
                    
                    let startSlicingIndex1 = getterKey.index(getterKey.startIndex, offsetBy: 1)
                    let subStr = getterKey[startSlicingIndex1...]
                    
                    let setterKey = "set\(uppercaseStr)\(subStr)"
                   // print(setterKey) // setName
                    
                    let getterSEL : Selector = NSSelectorFromString(getterKey)
                    let setterSEL : Selector = NSSelectorFromString(setterKey)
                    DXUserDefaultsModel.properties[getterKey] = getterKey
                    DXUserDefaultsModel.properties[setterKey] = setterKey
                    
                    var getterIMP : IMP!
                    var setterIMP : IMP!
                    
                   // print(propertyAttributes) // 0x000000010e2c0110
                    let type = propertyAttributes[1]
                   // print(type)
                    switch type {
                    case 64: // 字符串
                        getterIMP = imp_implementationWithBlock(DXUserDefaultsModel.getObjectBlock)
                        setterIMP = imp_implementationWithBlock(DXUserDefaultsModel.setBlock)
                    case 66: // Bool
                        getterIMP = imp_implementationWithBlock(DXUserDefaultsModel.getBoolBlock)
                        setterIMP = imp_implementationWithBlock(DXUserDefaultsModel.setBlock)
                    case 113: // Integer
                        getterIMP = imp_implementationWithBlock(DXUserDefaultsModel.getIntegerBlock)
                        setterIMP = imp_implementationWithBlock(DXUserDefaultsModel.setBlock)
                    case 100: // CGFloat Double
                        getterIMP = imp_implementationWithBlock(DXUserDefaultsModel.getFloatBlock)
                        setterIMP = imp_implementationWithBlock(DXUserDefaultsModel.setBlock)
                    default:
                        break
                    }
          
                    let getterENC = method_getTypeEncoding(class_getInstanceMethod(self.classForCoder, getterSEL)!)
                    class_addMethod(self.classForCoder, getterSEL, getterIMP, getterENC)
                    
                    if let instance = class_getInstanceMethod(self.classForCoder, setterSEL) {
                        let setterENC = method_getTypeEncoding(instance)
                        class_addMethod(self.classForCoder, setterSEL, setterIMP, setterENC)
                    }
                    
                }
            }
            
        }
    }
    //MARK:- Setter Methods
    // @convention(swift) : 表明这个是一个swift的闭包
    // @convention(block) ：表明这个是一个兼容oc的block的闭包
    // @convention(c) : 表明这个是兼容c的函数指针的闭包
    static let setBlock : @convention(block) (_ value : Any,_ sel : Selector) ->Void = { (value : Any?,sel : Selector) in
        let userDefaults = DXUserDefaultsModel.userDefaults
        if value == nil {
            if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
                userDefaults.set(value, forKey: propertyKey)
                userDefaults.synchronize()
            }
        } else {
            if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
                userDefaults.removeObject(forKey: propertyKey)
                userDefaults.synchronize()
            }
        }
    }
    //MARK:- Getter Methods
    // object
    static let getObjectBlock: @convention(block) (_ sel : Selector) ->Any? = { (sel : Selector) in
        let userDefaults = DXUserDefaultsModel.userDefaults
        if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
            return userDefaults.object(forKey: propertyKey)
        }else{
            return nil
        }
    }
    
    // Bool
    static let getBoolBlock: @convention(block) (_ sel : Selector) ->Any? = { (sel : Selector) in
        let userDefaults = DXUserDefaultsModel.userDefaults
        if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
            
             return userDefaults.bool(forKey: propertyKey)
        }else{
            return nil
        }
    }
    
    // Integer
    static let getIntegerBlock: @convention(block) (_ sel : Selector) ->Any? = { (sel : Selector) in
        let userDefaults = DXUserDefaultsModel.userDefaults
        if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
            return userDefaults.integer(forKey: propertyKey)
        }else{
            return nil
        }
    }
    
    // float
    static let getFloatBlock: @convention(block) (_ sel : Selector) ->Any? = { (sel : Selector) in
        let userDefaults = DXUserDefaultsModel.userDefaults
        if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
            return userDefaults.float(forKey: propertyKey)
        }else{
            return nil
        }
    }
    
    // double
    static let getDoubleBlock: @convention(block) (_ sel : Selector) ->Any? = { (sel : Selector) in
        let userDefaults = DXUserDefaultsModel.userDefaults
        if let propertyKey = DXUserDefaultsModel.properties[NSStringFromSelector(sel)] {
            return userDefaults.double(forKey: propertyKey)
        }else{
            return nil
        }
    }

}
