//
//  Debugging.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation

public func print(debug: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
    #if DEBUG
    var filename: NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    print("DEBUGGING_PRINT 파일: \(filename), 라인: \(line), 함수: \(function) :: \(debug)")
    #endif
}
