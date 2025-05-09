import SwiftUI

struct ContentView: View {
    @EnvironmentObject var shortcutManager: ShortcutManager
    @State private var isShowingAddShortcut = false
    @State private var isShowingInstructions = false
    
    var body: some View {
        NavigationView {
            VStack {
                if shortcutManager.shortcuts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "keyboard")
                            .font(.system(size: 70))
                            .foregroundColor(.blue)
                        
                        Text("Chưa có phím tắt nào")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Thêm phím tắt mới để bắt đầu")
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            isShowingAddShortcut = true
                        }) {
                            Text("Tạo phím tắt đầu tiên")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.top, 10)
                        
                        Button(action: {
                            isShowingInstructions = true
                        }) {
                            Text("Xem hướng dẫn sử dụng")
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                                .padding(.top, 20)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ShortcutListView()
                }
            }
            .navigationTitle("AutoText")
            .navigationBarItems(
                trailing: Button(action: {
                    isShowingAddShortcut = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isShowingAddShortcut) {
                AddShortcutView(isPresented: $isShowingAddShortcut)
            }
            .sheet(isPresented: $isShowingInstructions) {
                InstructionsView(isPresented: $isShowingInstructions)
            }
        }
    }
}

struct InstructionsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    instructionSection(
                        icon: "1.circle.fill",
                        title: "Tạo phím tắt",
                        description: "Nhấn nút + để tạo phím tắt mới với từ khoá và văn bản mở rộng"
                    )
                    
                    instructionSection(
                        icon: "2.circle.fill",
                        title: "Cài đặt bàn phím",
                        description: "Mở Cài đặt > Bàn phím > Bàn phím > Thêm bàn phím mới > AutoText và bật 'Cho phép truy cập đầy đủ'"
                    )
                    
                    instructionSection(
                        icon: "3.circle.fill",
                        title: "Sử dụng",
                        description: "Trong bất kỳ ứng dụng nào, chuyển sang bàn phím AutoText, nhập từ khoá phím tắt và nhấn nút mở rộng"
                    )
                    
                    instructionSection(
                        icon: "4.circle.fill",
                        title: "Quản lý phím tắt",
                        description: "Quay lại ứng dụng để chỉnh sửa, xoá hoặc thêm phím tắt mới"
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Hướng dẫn sử dụng")
            .navigationBarItems(
                trailing: Button("Đóng") {
                    isPresented = false
                }
            )
        }
    }
    
    private func instructionSection(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ShortcutManager())
    }
} 