//
//  RXUITableViewVC3.swift
//  RxSwiftDemo
//
//  Created by aStudyer on 2019/9/8.
//  Copyright © 2019 com.aStudyer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RXUITableViewVC3: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    //刷新按钮
    var refreshButton: UIBarButtonItem!
    //停止按钮
    var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        refreshButton = UIBarButtonItem(title: "刷新", style: .plain, target: nil, action: nil)
        cancelButton = UIBarButtonItem(title: "停止", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [refreshButton, cancelButton]
        
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "Cell")
        
        /**
         flatMapLatest 的作用是当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但表格只会接收并显示最后一次请求。避免表格出现连续刷新的现象。
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult)//连续请求时只取最后一次数据
         .share(replay: 1)
         
         也可以改用 flatMapFirst 来防止表格多次刷新，它与 flatMapLatest 刚好相反，如果连续发起多次请求，表格只会接收并显示第一次请求。
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapFirst(getRandomResult)  //连续请求时只取第一次数据
         .share(replay: 1)
         
         我们还可以在源头进行限制下。即通过 throttle 设置个阀值（比如 1 秒），如果在1秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求。
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult)
         .share(replay: 1)
         */
        //随机的表格数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest{//连续请求时只取最后一次数据
                self.getRandomResult().takeUntil(self.cancelButton.rx.tap)
            }
            .share(replay: 1)
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, Int>>(configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
                return cell
            })
        
        //绑定单元格数据
        randomResult
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
extension RXUITableViewVC3 {
    //获取随机数据
    private func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map {_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}
