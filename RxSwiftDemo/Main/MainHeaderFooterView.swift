//
//  MainHeaderFooterView.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/8/23.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainHeaderFooterView: UITableViewHeaderFooterView {
    @IBOutlet private weak var btn: UIButton!
    private let disposeBag = DisposeBag()
    var click: ((MainHeaderFooterView)->Void)?
    var sectionItem: SectionItem? {
        didSet {
            if let item = sectionItem {
                btn.setTitle(item.title, for: .normal)
            }
        }
    }
    init(_ click: @escaping (MainHeaderFooterView)->Void) {
        self.click = click
        super.init(reuseIdentifier: R.nib.mainHeaderFooterView.name)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.rx.tap.subscribe {[weak self] (event) in
            guard let self = self else {return}
            if let click = self.click {
                self.sectionItem?.isOpen = !self.sectionItem!.isOpen
                click(self)
            }
        }.disposed(by: disposeBag)
    }
}
