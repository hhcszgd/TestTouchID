//
//  DDTouchIDManager.swift
//  TestTouchID
//
//  Created by WY on 2018/6/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import LocalAuthentication
class DDTouchIDManager: NSObject {
    static let myContext = LAContext()
    static func prepare() {
        let myLocalizedReasonString = "指纹解锁"
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    if success {
                        print("识别成功")
                        // User authenticated successfully, take appropriate action
                    } else {
                        if let err = evaluateError as NSError?{
                            print(err.code)
                            print(err.userInfo)
                            self.status(code: Int32(err.code))
                        }
                        print("xxxxxxxxxxxxxxxxxxxx")
                        dump(evaluateError)
                        print("xxxxxxxxxxxxxxxxxxxx")
                        print("识别失败\(authError?.code)")
                        print("\(#line) : \(evaluateError?.localizedDescription)")
                        // User did not authenticate successfully, look at error and take appropriate action
                        print("\(#line) : ")
                        
                    }
                }
            } else {
                self.status(code: Int32(authError?.code ?? 0))
                // Could not evaluate policy; look at authError and present an appropriate message to user
            }
        } else {
            // Fallback on earlier versions
            print("系统太老,不支持touchID")
        }
    }
    static func status(code : Int32)  {
        print("\(#line) : \(code) ")
        switch code {
        case kLAErrorAuthenticationFailed:
            print("\(#line)")
            
        case kLAErrorUserCancel: // -2 点击了 touchID界面显示 取消 和 输入密码时的取消(有两个按钮)
            print("\(#line)")
            
        case kLAErrorUserFallback://-3 点击了输入密码
            print("\(#line)")
            performAuthorizeByPassword(title:"请输入密码")
        case kLAErrorSystemCancel: // -4 点击了touchID界面的取消 (只有一个取消按钮)
            print("\(#line)")
            
        case kLAErrorPasscodeNotSet:
            print("\(#line)")
            
        case kLAErrorTouchIDNotAvailable:
            print("\(#line)")
            
        case kLAErrorTouchIDNotEnrolled:
            print("\(#line)")
            
        case kLAErrorTouchIDLockout: // -8 touchID被锁定
            print("\(#line) : 失败次数过多 , 需验证密码")
            performAuthorizeByPassword(title:"失败次数过多 , 请输入密码")
        case kLAErrorAppCancel:
            print("\(#line)")
            
        case kLAErrorInvalidContext:
            print("\(#line)")
        case kLAErrorNotInteractive:
            print("\(#line)")
        case kLAErrorBiometryNotAvailable:
            print("\(#line)")
        case kLAErrorBiometryNotEnrolled:
            print("\(#line)")
        case kLAErrorBiometryLockout:
            print("\(#line)")
        case kLAErrorNotInteractive:
            print("\(#line)")
        default:
            print("\(#line)")
        }
    }
    
    static func performAuthorizeByPassword(title:String)  {
        var authError: NSError?
        if self.myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authError) {
            self.myContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: title) { (bool , error ) in
                if bool{//通过
                    
                }else  if let err = error as NSError?{
                    print(err.code)
                    print(err.userInfo)
                    self.status(code: Int32(err.code))
                }
            }
        }else{
            print("未设置密码")
        }
    }
    
}
