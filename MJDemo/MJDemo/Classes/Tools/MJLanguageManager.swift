//
//  MJLanguageManager.swift
//  AnyTrek
//
//  Created by 郭明健 on 2023/2/21.
//

import Foundation

// MARK: - localizedString

public enum LocaleType: String, Codable, CaseIterable {
    /// 英文
    case English = "en"
    /// 简体中文
    case SimplifiedChinese = "zh-Hans"
    /// 繁体中文
    case TraditionalChinese = "zh-Hant"
    /// 墨西哥（西班牙语）
    case Spanish = "es-US"
    
    /// 获取语言类型字符串
    func getLocaleTypeString() -> String {
        switch self {
        case .English:
            return "en"
        case .SimplifiedChinese:
            return "zh-Hans"
        case .TraditionalChinese:
            return "zh-Hant"
        case .Spanish:
            return "es-US"
        }
    }
}

/// 根据当前语言，获取字符key对应的value
public func localizedString(_ key: String,
                            localeParam: LocaleType? = nil) -> String {
    var locale: LocaleType = MJLanguageManager.shared.currentLanguage
    //
    if let localeParam = localeParam {
        locale = localeParam
    }
    
    // find copy on Host app
    let hostAppBundlePath = Bundle.main.path(forResource: locale.rawValue, ofType: "lproj")
    if let path = hostAppBundlePath, let bundle = Bundle(path: path) {
        let string = bundle.localizedString(forKey: key, value: key, table: "localizable")
        if !string.lowercased().contains(key) {
            return string
        }
    }
    
    return key
}

// MARK: - LanguageManager
public let kLanguageKey = "kCurrentLanguageKey"

class MJLanguageManager: NSObject {
    static let shared = MJLanguageManager()
    public let defaultLanguage: LocaleType = .English
    public var currentLanguage: LocaleType!
    
    /// 初始化App语言
    func initAppLanguage() {
        let language = getCurrentLanguage()
        setLanguage(language: language)
    }
    
    /// 获取当前App语言，如果未设置，则设置语手机系统一致的语言。
    /// - Returns: String
    func getCurrentLanguage() -> LocaleType {
        let language: String? = UserDefaults.standard.value(forKey: kLanguageKey) as? String
        if let language: String = language, language.count > 0 {
            let type = LocaleType(rawValue: language) ?? defaultLanguage
            return type
        } else {
            let systemLanguage = getSystemLanguage()
            return systemLanguage
        }
    }
    
    /// 设置App语言
    /// - Parameter language: String
    func setLanguage(language: LocaleType) {
        MJLanguageManager.shared.currentLanguage = language
        UserDefaults.standard.setValue(language.rawValue, forKey: kLanguageKey)
        UserDefaults.standard.synchronize()
    }
    
    /// 获取系统语言
    /// - Returns: 当前系统语言
    func getSystemLanguage() -> LocaleType {
        var locale: LocaleType = defaultLanguage
        
        // 根据App当前的语言显示对应的copyString
        let languageString: String = NSLocale.preferredLanguages.first ?? defaultLanguage.getLocaleTypeString()
        if languageString.hasPrefix("en") {
            locale = .English
        } else if languageString.hasPrefix("zh-Hans") {
            locale = .SimplifiedChinese
        } else if languageString.hasPrefix("zh-Hant") {
            locale = .TraditionalChinese
        } else if languageString.hasPrefix("es-") {
            // es-US
            locale = .Spanish
        }
        
        return locale
    }
    
    /// 是否为中文
    /// - Returns: Bool
    func isChinese() -> Bool {
        var result: Bool = false
        if currentLanguage == .SimplifiedChinese || currentLanguage == .TraditionalChinese {
            result = true
        }
        return result
    }
}

extension MJLanguageManager {
    /// 获取App支持多语言列表
    static func getSupportLanguage(fileName: String = "SupportLanguages",
                                   fileType: String = "plist") -> [String] {
        let path: String = Bundle.main.path(forResource: fileName, ofType: fileType) ?? ""
        let pathUrl: URL = URL(fileURLWithPath: path)
        let supportList: [String] = NSArray(contentsOf: pathUrl) as! [String]
        var languageList: [String] = []
        for (_, item) in supportList.enumerated() {
            languageList.append(localizedString(item))
        }
        return languageList
    }
}
