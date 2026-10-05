/**
 * Consent Management for iOS / Swift Applications
 * KVKK/GDPR/ISO 27001 Compliant
 * Uses UserDefaults for persistence
 * Supports: Turkish & English
 */

import Foundation
import SwiftUI
import Combine

// ============================================
// MODELS
// ============================================

public enum ConsentLanguage: String, CaseIterable, Codable {
    case en = "en"
    case tr = "tr"
    
    public var displayName: String {
        switch self {
        case .en: return "English"
        case .tr: return "Türkçe"
        }
    }
}

public enum ConsentCategory: String, CaseIterable, Codable {
    case necessary = "necessary"
    case functional = "functional"
    case analytics = "analytics"
    case marketing = "marketing"
}

public struct ConsentPreferences: Codable, Equatable {
    public var necessary: Bool = true
    public var functional: Bool = false
    public var analytics: Bool = false
    public var marketing: Bool = false
    public var version: String = "1.0"
    public var timestamp: Date = Date()
    public var language: ConsentLanguage = .en
    public var deviceId: String = ""
    
    public static let currentVersion = "1.0"
    
    public var hasConsented: Bool {
        return !necessary && (functional || analytics) // Has made a choice beyond necessary
    }
    
    public var isFirstVisit: Bool {
        return deviceId.isEmpty
    }
}

// ============================================
// TRANSLATIONS
// ============================================

public struct ConsentTranslations {
    public static let shared = ConsentTranslations()
    
    private let translations: [ConsentLanguage: [String: String]] = [
        .en: [
            "consentTitle": "Privacy & Data Consent",
            "consentDescription": "We respect your privacy. Choose which data processing you consent to. You can change this anytime in Settings.",
            "necessary": "Essential",
            "necessaryDesc": "Required for the app to function (auth, security, core features). Cannot be disabled.",
            "functional": "Preferences",
            "functionalDesc": "Remember your settings (language, theme, notifications).",
            "analytics": "Analytics",
            "analyticsDesc": "Anonymous usage stats to improve the app. No personal data.",
            "marketing": "Marketing",
            "marketingDesc": "We do not use marketing tracking.",
            "acceptAll": "Accept All",
            "rejectAll": "Reject Optional",
            "savePreferences": "Save Preferences",
            "settings": "Privacy Settings",
            "learnMore": "Learn More",
            "privacyPolicy": "Privacy Policy",
            "termsOfService": "Terms of Service",
            "kvkkInfo": "KVKK Compliant • GDPR Compliant • ISO 27001 Aligned",
            "dataController": "Data Controller: Aixoratechnology",
            "contactDPO": "Contact DPO: dpo@aixoratechnology.com",
            "resetConsent": "Reset Consent & Show Again"
        ],
        .tr: [
            "consentTitle": "Gizlilik ve Veri Rızası",
            "consentDescription": "Gizliliğinize saygı duyuyoruz. Onay vereceğiniz işlemleri seçin. Ayararlardan istediğiniz zaman değiştirebilirsiniz.",
            "necessary": "Temel",
            "necessaryDesc": "Uygulamanın çalışması için zorunlu (kimlik doğrulama, güvenlik, temel özellikler). Devre dışı bırakılamaz.",
            "functional": "Tercihler",
            "functionalDesc": "Ayarlarınızı hatırlar (dil, tema, bildirimler).",
            "analytics": "Analitik",
            "analyticsDesc": "Uygulamayı iyileştirmek için anonim kullanım istatistikleri. Kişisel veri toplanmaz.",
            "marketing": "Pazarlama",
            "marketingDesc": "Pazarlama takibi kullanmıyoruz.",
            "acceptAll": "Tümünü Kabul Et",
            "rejectAll": "İsteğe Bağlıları Reddet",
            "savePreferences": "Tercihleri Kaydet",
            "settings": "Gizlilik Ayarları",
            "learnMore": "Daha Fazla Bilgi",
            "privacyPolicy": "Gizlilik Politikası",
            "termsOfService": "Hizmet Şartları",
            "kvkkInfo": "KVKK Uyumlu • GDPR Uyumlu • ISO 27001 Uyumlu",
            "dataController": "Veri Sorumlusu: Aixoratechnology",
            "contactDPO": "VKS İletişim: dpo@aixoratechnology.com",
            "resetConsent": "Rızayı Sıfırla ve Tekrar Göster"
        ]
    ]
    
    public func t(_ key: String, language: ConsentLanguage) -> String {
        return translations[language]?[key] ?? translations[.en]?[key] ?? key
    }
}

// ============================================
// CONSENT MANAGER (Singleton)
// ============================================

public final class ConsentManager: ObservableObject {
    public static let shared = ConsentManager()
    
    // Published properties for SwiftUI binding
    @Published public private(set) var preferences: ConsentPreferences
    @Published public private(set) var showConsentModal: Bool = false
    @Published public private(set) var isInitialized: Bool = false
    
    private let storageKey = "kvkk_consent_preferences"
    private let languageKey = "kvkk_consent_language"
    private let deviceIdKey = "kvkk_device_id"
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Load initial preferences
        self.preferences = Self.loadPreferences()
        self.isInitialized = true
        
        // Show modal if first visit
        if preferences.isFirstVisit {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showConsentModal = true
            }
        }
    }
    
    // MARK: - Public Methods
    
    public func acceptAll() {
        var newPrefs = preferences
        newPrefs.functional = true
        newPrefs.analytics = true
        newPrefs.marketing = false
        newPrefs.timestamp = Date()
        newPrefs.deviceId = generateDeviceId()
        saveAndNotify(newPrefs)
        showConsentModal = false
    }
    
    public func rejectAll() {
        var newPrefs = preferences
        newPrefs.functional = false
        newPrefs.analytics = false
        newPrefs.marketing = false
        newPrefs.timestamp = Date()
        newPrefs.deviceId = generateDeviceId()
        saveAndNotify(newPrefs)
        showConsentModal = false
    }
    
    public func updateCategory(_ category: ConsentCategory, value: Bool) {
        guard category != .necessary && category != .marketing else { return }
        
        var newPrefs = preferences
        switch category {
        case .functional: newPrefs.functional = value
        case .analytics: newPrefs.analytics = value
        default: return
        }
        newPrefs.timestamp = Date()
        newPrefs.deviceId = generateDeviceId()
        saveAndNotify(newPrefs)
    }
    
    public func resetConsent() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.removeObject(forKey: languageKey)
        UserDefaults.standard.removeObject(forKey: deviceIdKey)
        preferences = ConsentPreferences()
        showConsentModal = true
    }
    
    public func setLanguage(_ language: ConsentLanguage) {
        var newPrefs = preferences
        newPrefs.language = language
        saveAndNotify(newPrefs)
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
    }
    
    public func setShowConsentModal(_ show: Bool) {
        showConsentModal = show
    }
    
    // MARK: - Helpers
    
    private func generateDeviceId() -> String {
        if let existing = UserDefaults.standard.string(forKey: deviceIdKey) {
            return existing
        }
        let newId = "device_\(UUID().uuidString.prefix(8))_\(Int(Date().timeIntervalSince1970))"
        UserDefaults.standard.set(newId, forKey: deviceIdKey)
        return newId
    }
    
    private func saveAndNotify(_ newPrefs: ConsentPreferences) {
        preferences = newPrefs
        savePreferences(newPrefs)
        // Notify any listeners
        NotificationCenter.default.post(name: .consentChanged, object: newPrefs)
    }
    
    private static func loadPreferences() -> ConsentPreferences {
        guard let data = UserDefaults.standard.data(forKey: "kvkk_consent_preferences"),
              let prefs = try? JSONDecoder().decode(ConsentPreferences.self, from: data),
              prefs.version == ConsentPreferences.currentVersion else {
            return ConsentPreferences()
        }
        return prefs
    }
    
    private func savePreferences(_ prefs: ConsentPreferences) {
        if let data = try? JSONEncoder().encode(prefs) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    // MARK: - Consent Checks
    
    public var hasFunctionalConsent: Bool {
        return preferences.functional
    }
    
    public var hasAnalyticsConsent: Bool {
        return preferences.analytics
    }
    
    public var currentLanguage: ConsentLanguage {
        return preferences.language
    }
}

// ============================================
// NOTIFICATION NAMES
// ============================================

extension Notification.Name {
    public static let consentChanged = Notification.Name("kvkk_consent_changed")
}

// ============================================
// SWIFTVIEW - CONSENT MODAL
// ============================================

public struct ConsentModalView: View {
    @ObservedObject private var consentManager = ConsentManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    public init() {}
    
    public var body: some View {
        if consentManager.showConsentModal {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // Don't dismiss on background tap - require explicit action
                    }
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 12) {
                        HStack {
                            Text(consentManager.t("consentTitle"))
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Language selector
                            HStack(spacing: 8) {
                                ForEach(ConsentLanguage.allCases) { lang in
                                    Button(action: { consentManager.setLanguage(lang) }) {
                                        Text(lang.rawValue.uppercased())
                                            .font(.caption.bold())
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                consentManager.currentLanguage == lang
                                                ? Color.white
                                                : Color.white.opacity(0.2)
                                            )
                                            .foregroundColor(
                                                consentManager.currentLanguage == lang
                                                ? .blue
                                                : .white
                                            )
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                        
                        Text(consentManager.t("consentDescription"))
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(24)
                    .background(
                        LinearGradient(
                            colors: [.blue, .indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 16) {
                            ConsentCategoryRow(
                                category: .necessary,
                                title: consentManager.t("necessary"),
                                description: consentManager.t("necessaryDesc"),
                                isEnabled: true,
                                isDisabled: true,
                                onChange: { _ in }
                            )
                            
                            Divider().padding(.horizontal)
                            
                            ConsentCategoryRow(
                                category: .functional,
                                title: consentManager.t("functional"),
                                description: consentManager.t("functionalDesc"),
                                isEnabled: consentManager.preferences.functional,
                                isDisabled: false,
                                onChange: { consentManager.updateCategory(.functional, value: $0) }
                            )
                            
                            ConsentCategoryRow(
                                category: .analytics,
                                title: consentManager.t("analytics"),
                                description: consentManager.t("analyticsDesc"),
                                isEnabled: consentManager.preferences.analytics,
                                isDisabled: false,
                                onChange: { consentManager.updateCategory(.analytics, value: $0) }
                            )
                            
                            ConsentCategoryRow(
                                category: .marketing,
                                title: consentManager.t("marketing"),
                                description: consentManager.t("marketingDesc"),
                                isEnabled: false,
                                isDisabled: true,
                                onChange: { _ in }
                            )
                        }
                        .padding(24)
                    }
                    .frame(maxHeight: 400)
                    
                    // Links
                    VStack(alignment: .leading, spacing: 8) {
                        Text(consentManager.t("learnMore"))
                            .font(.subheadline.bold())
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 16) {
                            LinkButton(title: consentManager.t("privacyPolicy")) { /* Open URL */ }
                            LinkButton(title: consentManager.t("termsOfService")) { /* Open URL */ }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: { consentManager.rejectAll() }) {
                            Text(consentManager.t("rejectAll"))
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        
                        Button(action: { consentManager.acceptAll() }) {
                            Text(consentManager.t("acceptAll"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Info
                    VStack(spacing: 4) {
                        Text(consentManager.t("kvkkInfo"))
                        Text(consentManager.t("dataController"))
                        Text(consentManager.t("contactDPO"))
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 24)
                }
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .padding(.horizontal, 16)
                .shadow(radius: 20)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: consentManager.showConsentModal)
        }
    }
    
    private func t(_ key: String) -> String {
        ConsentTranslations.shared.t(key, language: consentManager.currentLanguage)
    }
}

// ============================================
// CONSENT CATEGORY ROW
// ============================================

private struct ConsentCategoryRow: View {
    let category: ConsentCategory
    let title: String
    let description: String
    let isEnabled: Bool
    let isDisabled: Bool
    let onChange: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if category == .necessary {
                        Text("Required")
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.15))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    } else if category == .marketing {
                        Text("Not Used")
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.15))
                            .foregroundColor(.gray)
                            .cornerRadius(8)
                    }
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { isEnabled },
                set: { newValue in
                    if !isDisabled {
                        onChange(newValue)
                    }
                }
            ))
            .disabled(isDisabled)
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// ============================================
// LINK BUTTON
// ============================================

private struct LinkButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }
}

// ============================================
// PRIVACY SETTINGS VIEW
// ============================================

public struct PrivacySettingsView: View {
    @ObservedObject private var consentManager = ConsentManager.shared
    @Environment(\.colorScheme) var colorScheme
    
    public init() {}
    
    public var body: some View {
        Form {
            Section(header: Text(consentManager.t("settings"))) {
                // Language
                Picker(consentManager.currentLanguage == .en ? "Language" : "Dil", selection: Binding(
                    get: { consentManager.currentLanguage },
                    set: { consentManager.setLanguage($0) }
                )) {
                    ForEach(ConsentLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Consent Categories")) {
                ConsentCategoryRow(
                    category: .necessary,
                    title: consentManager.t("necessary"),
                    description: consentManager.t("necessaryDesc"),
                    isEnabled: true,
                    isDisabled: true,
                    onChange: { _ in }
                )
                
                ConsentCategoryRow(
                    category: .functional,
                    title: consentManager.t("functional"),
                    description: consentManager.t("functionalDesc"),
                    isEnabled: consentManager.preferences.functional,
                    isDisabled: false,
                    onChange: { consentManager.updateCategory(.functional, value: $0) }
                )
                
                ConsentCategoryRow(
                    category: .analytics,
                    title: consentManager.t("analytics"),
                    description: consentManager.t("analyticsDesc"),
                    isEnabled: consentManager.preferences.analytics,
                    isDisabled: false,
                    onChange: { consentManager.updateCategory(.analytics, value: $0) }
                )
                
                ConsentCategoryRow(
                    category: .marketing,
                    title: consentManager.t("marketing"),
                    description: consentManager.t("marketingDesc"),
                    isEnabled: false,
                    isDisabled: true,
                    onChange: { _ in }
                )
            }
            
            Section {
                Button(role: .destructive) {
                    consentManager.resetConsent()
                } label: {
                    Text(consentManager.t("resetConsent"))
                }
            }
            
            Section(header: Text("Your Rights")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("KVKK Art. 11 / GDPR Art. 15-22")
                        .font(.caption.bold())
                        .foregroundColor(.secondary)
                    
                    ForEach(rightsTexts, id: \.self) { right in
                        Text("• \(right)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "mailto:privacy@aixoratechnology.com")!) {
                        Text("Contact DPO: privacy@aixoratechnology.com")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(consentManager.t("settings"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var rightsTexts: [String] {
        let lang = consentManager.currentLanguage
        return [
            ConsentTranslations.shared.t("accessRectifyDelete", language: lang) ?? (lang == .en ? "Access, rectify, delete your data" : "Verilerinize erişim, düzeltme, silme"),
            ConsentTranslations.shared.t("restrictObject", language: lang) ?? (lang == .en ? "Restrict or object to processing" : "İşlemi kısıtlama veya itiraz etme"),
            ConsentTranslations.shared.t("dataPortability", language: lang) ?? (lang == .en ? "Data portability" : "Veri taşınabilirliği"),
            ConsentTranslations.shared.t("withdrawConsent", language: lang) ?? (lang == .en ? "Withdraw consent anytime" : "Rızayı her an geri çekme"),
            ConsentTranslations.shared.t("lodgeComplaint", language: lang) ?? (lang == .en ? "Lodge complaint with KVKK/DPA" : "KVKK/AB kurumuna şikayet"),
        ]
    }
}

// ============================================
// USAGE IN APP
// ============================================

/*
// In your App entry point:
import SwiftUI

@main
struct KaizenApp: App {
    @StateObject private var consentManager = ConsentManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                ConsentModalView()
            }
            .environmentObject(consentManager)
        }
    }
}

// In any view needing consent checks:
struct SomeView: View {
    @EnvironmentObject var consentManager: ConsentManager
    
    var body: some View {
        if consentManager.hasAnalyticsConsent {
            // Show analytics-enabled features
        }
        
        if consentManager.hasFunctionalConsent {
            // Apply user preferences
        }
    }
}
*/

// ============================================
// ANALYTICS INTEGRATION
// ============================================

public func initializeAnalyticsIfConsented() {
    let consentManager = ConsentManager.shared
    
    if consentManager.hasAnalyticsConsent {
        // Initialize your analytics (Firebase, Mixpanel, etc.)
        // Example:
        // FirebaseApp.configure()
        // Analytics.setAnalyticsCollectionEnabled(true)
        print("[Consent] Analytics initialized (consent granted)")
    } else {
        // Disable analytics
        // Analytics.setAnalyticsCollectionEnabled(false)
        print("[Consent] Analytics blocked (no consent)")
    }
}

public func applyFunctionalPreferencesIfConsented() {
    let consentManager = ConsentManager.shared
    
    if consentManager.hasFunctionalConsent {
        // Apply saved theme, language, notification settings
        print("[Consent] Functional preferences applied")
    }
}