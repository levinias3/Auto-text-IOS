import Foundation
import Combine

class ShortcutManager: ObservableObject {
    @Published var shortcuts: [Shortcut] = []
    
    private let shortcutsKey = "shortcuts"
    private let userDefaults = UserDefaults(suiteName: "group.com.example.AutoTextIOS")
    
    init() {
        loadShortcuts()
    }
    
    func loadShortcuts() {
        if let data = userDefaults?.data(forKey: shortcutsKey) {
            do {
                let decodedShortcuts = try JSONDecoder().decode([Shortcut].self, from: data)
                DispatchQueue.main.async {
                    self.shortcuts = decodedShortcuts
                }
            } catch {
                print("Không thể giải mã dữ liệu phím tắt: \(error)")
            }
        }
    }
    
    func saveShortcuts() {
        do {
            let encodedData = try JSONEncoder().encode(shortcuts)
            userDefaults?.set(encodedData, forKey: shortcutsKey)
        } catch {
            print("Không thể lưu phím tắt: \(error)")
        }
    }
    
    func addShortcut(trigger: String, expansion: String) {
        let newShortcut = Shortcut(trigger: trigger, expansion: expansion)
        shortcuts.append(newShortcut)
        saveShortcuts()
    }
    
    func updateShortcut(shortcut: Shortcut, newTrigger: String, newExpansion: String) {
        if let index = shortcuts.firstIndex(where: { $0.id == shortcut.id }) {
            shortcuts[index].trigger = newTrigger
            shortcuts[index].expansion = newExpansion
            saveShortcuts()
        }
    }
    
    func deleteShortcut(at offsets: IndexSet) {
        shortcuts.remove(atOffsets: offsets)
        saveShortcuts()
    }
    
    func deleteShortcut(shortcut: Shortcut) {
        if let index = shortcuts.firstIndex(where: { $0.id == shortcut.id }) {
            shortcuts.remove(at: index)
            saveShortcuts()
        }
    }
    
    func findExpansion(for trigger: String) -> String? {
        return shortcuts.first(where: { $0.trigger == trigger })?.expansion
    }
} 