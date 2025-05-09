import SwiftUI

struct ShortcutListView: View {
    @EnvironmentObject var shortcutManager: ShortcutManager
    @State private var editingShortcut: Shortcut?
    @State private var isShowingEdit = false
    
    var body: some View {
        List {
            ForEach(shortcutManager.shortcuts) { shortcut in
                ShortcutRow(shortcut: shortcut)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        editingShortcut = shortcut
                        isShowingEdit = true
                    }
            }
            .onDelete(perform: deleteShortcuts)
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $isShowingEdit, onDismiss: {
            editingShortcut = nil
        }) {
            if let shortcut = editingShortcut {
                EditShortcutView(shortcut: shortcut, isPresented: $isShowingEdit)
            }
        }
    }
    
    private func deleteShortcuts(at offsets: IndexSet) {
        shortcutManager.deleteShortcut(at: offsets)
    }
}

struct ShortcutRow: View {
    let shortcut: Shortcut
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(shortcut.trigger)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(shortcut.expansion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 4)
    }
}

struct EditShortcutView: View {
    let shortcut: Shortcut
    @Binding var isPresented: Bool
    @EnvironmentObject var shortcutManager: ShortcutManager
    
    @State private var trigger: String
    @State private var expansion: String
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    init(shortcut: Shortcut, isPresented: Binding<Bool>) {
        self.shortcut = shortcut
        self._isPresented = isPresented
        self._trigger = State(initialValue: shortcut.trigger)
        self._expansion = State(initialValue: shortcut.expansion)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Từ khoá")) {
                    TextField("Nhập từ khoá", text: $trigger)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Nội dung mở rộng")) {
                    TextEditor(text: $expansion)
                        .frame(minHeight: 100)
                        .disableAutocorrection(true)
                }
                
                Section {
                    Button(action: {
                        shortcutManager.deleteShortcut(shortcut: shortcut)
                        isPresented = false
                    }) {
                        HStack {
                            Spacer()
                            Text("Xoá phím tắt")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Chỉnh sửa phím tắt")
            .navigationBarItems(
                leading: Button("Huỷ") {
                    isPresented = false
                },
                trailing: Button("Lưu") {
                    if validateInput() {
                        shortcutManager.updateShortcut(shortcut: shortcut, newTrigger: trigger, newExpansion: expansion)
                        isPresented = false
                    } else {
                        showAlert = true
                    }
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Lỗi"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func validateInput() -> Bool {
        if trigger.isEmpty {
            alertMessage = "Từ khoá không được để trống."
            return false
        }
        
        if expansion.isEmpty {
            alertMessage = "Nội dung mở rộng không được để trống."
            return false
        }
        
        // Kiểm tra xem trigger đã tồn tại chưa (ngoại trừ shortcut hiện tại)
        let existingShortcuts = shortcutManager.shortcuts.filter { $0.id != shortcut.id }
        if existingShortcuts.contains(where: { $0.trigger == trigger }) {
            alertMessage = "Từ khoá này đã tồn tại. Vui lòng chọn từ khoá khác."
            return false
        }
        
        return true
    }
} 