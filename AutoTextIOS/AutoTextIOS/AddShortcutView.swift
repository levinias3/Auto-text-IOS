import SwiftUI

struct AddShortcutView: View {
    @EnvironmentObject var shortcutManager: ShortcutManager
    @Binding var isPresented: Bool
    
    @State private var trigger = ""
    @State private var expansion = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Từ khoá")) {
                    TextField("Ví dụ: Hl@", text: $trigger)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Nội dung mở rộng")) {
                    TextEditor(text: $expansion)
                        .frame(minHeight: 100)
                        .disableAutocorrection(true)
                        .overlay(
                            Group {
                                if expansion.isEmpty {
                                    Text("Ví dụ: Hello")
                                        .foregroundColor(Color(.placeholderText))
                                        .padding(.leading, 5)
                                        .padding(.top, 8)
                                        .allowsHitTesting(false)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                }
                            }
                        )
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: addShortcut) {
                            Text("Thêm phím tắt")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Thêm phím tắt mới")
            .navigationBarItems(
                leading: Button("Huỷ") {
                    isPresented = false
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
    
    private func addShortcut() {
        if !validateInput() {
            showAlert = true
            return
        }
        
        shortcutManager.addShortcut(trigger: trigger.trimmingCharacters(in: .whitespacesAndNewlines), 
                                   expansion: expansion)
        isPresented = false
    }
    
    private func validateInput() -> Bool {
        let trimmedTrigger = trigger.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTrigger.isEmpty {
            alertMessage = "Từ khoá không được để trống."
            return false
        }
        
        if expansion.isEmpty {
            alertMessage = "Nội dung mở rộng không được để trống."
            return false
        }
        
        // Kiểm tra xem trigger đã tồn tại chưa
        if shortcutManager.shortcuts.contains(where: { $0.trigger == trimmedTrigger }) {
            alertMessage = "Từ khoá này đã tồn tại. Vui lòng chọn từ khoá khác."
            return false
        }
        
        return true
    }
} 