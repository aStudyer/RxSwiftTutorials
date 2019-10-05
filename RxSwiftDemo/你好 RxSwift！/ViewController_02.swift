//
//  ViewController_02.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/24.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//
/*
 “share(replay: 1) 是用来做什么的？
 
 我们用 usernameValid 来控制用户名提示语是否隐藏以及密码输入框是否可用。shareReplay 就是让他们共享这一个源，而不是为他们单独创建新的源。这样可以减少不必要的开支。”
 
 “disposed(by: disposeBag) 是用来做什么的？
 
 和我们所熟悉的对象一样，每一个绑定也是有生命周期的。并且这个绑定是可以被清除的。disposed(by: disposeBag)就是将绑定的生命周期交给 disposeBag 来管理。当 disposeBag 被释放的时候，那么里面尚未清除的绑定也就被清除了。这就相当于是在用 ARC 来管理绑定的生命周期。 这个内容会在 Disposable 章节详细介绍。”
 */
import UIKit
import RxCocoa
import RxSwift

class ViewController_02: BaseViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameValidLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 用户名是否有效
        let usernameValid = usernameField.rx.text.map { (text) -> Bool in
            guard let text = text, text != "" else {
                return true
            }
            return text.count > 5
        }.share(replay: 1)
        // 用户名是否有效 -> 密码输入框是否可用
        usernameValid.bind(to: passwordField.rx.isEnabled).disposed(by: disposeBag)
        // 用户名是否有效 -> 用户名提示语是否隐藏
        usernameValid.bind(to: usernameValidLabel.rx.isHidden).disposed(by: disposeBag)
        // 密码是否有效
        let passwordValid = passwordField.rx.text.map { (text) -> Bool in
            guard let text = text, text != "" else {
                return true
            }
            return text.count > 5
        }.share(replay: 1)
        // 密码是否有效 -> 密码提示语是否隐藏
        passwordValid.bind(to: passwordValidLabel.rx.isHidden).disposed(by: disposeBag)
        // 用户名和密码是否同时有效
        let everyThingvalid = Observable.combineLatest(usernameValid, passwordValid){$0 && $1}.share(replay: 1)
        // 登录按钮是否可点击
        everyThingvalid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        // 点击绿色按钮 -> 弹出提示框
        loginBtn.rx.tap.subscribe {[weak self] (event) in
            self?.showAlert()
        }.disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alertVc = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVc, animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
