//
//  ViewModel.swift
//  MVVM-Example
//
//  Created by ryoku on 2017/11/24.
//  Copyright © 2017 ryoku. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class MemoViewModel {
    
    enum Result {
        case success(String)
        case failure(String)
    }
    
    private let savingMemoUseCase = SavingMemoUseCase()
    
    let id = Variable<Int?>(nil)
    let memoTitle = Variable<String?>("")
    let memoText  = Variable<String?>("")
    let saveButtonTap = PublishSubject<Void>()
    
    let tapButton = PublishSubject<Void>()
    
    lazy var savingObservable: Observable<Result> = {
        
        return self.tapButton.asObserver().flatMapFirst { [unowned self] _  -> Observable<Result> in
           let memo = Memo()
           guard let id = self.id.value,
                 let title = self.memoTitle.value,
                 let text = self.memoText.value else {
               return Observable.just(.failure("failed..."))
                .share(replay: 1)
            }
            memo.id = id
            memo.memoTitle = title
            memo.memoText  = text
            
            self.savingMemoUseCase.invoke(memo: memo)
                    
            return Observable.just(.success("success!!"))
                .share(replay: 1)
            }
            .catchErrorJustReturn(.failure("failed...."))
            .share(replay: 1)
    }()

    init(memo: Memo) {
        id.value        = memo.id
        memoTitle.value = memo.memoTitle
        memoText.value  = memo.memoText
    }
}
