import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var keyboardView: UIView!
    private var inputTextView: UITextView!
    private var expandButton: UIButton!
    private var clearButton: UIButton!
    private var nextKeyboardButton: UIButton!
    private var textToExpand: String = ""
    private let shortcutManager = ShortcutManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tải phím tắt từ UserDefaults
        shortcutManager.loadShortcuts()
        
        setupKeyboardAppearance()
        createInputTextView()
        createExpandButton()
        createClearButton()
        createNextKeyboardButton()
        
        setupConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nextKeyboardButton.isHidden = !needsInputModeSwitchKey
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // Cập nhật trạng thái khi văn bản thay đổi
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // Cập nhật trạng thái khi văn bản đã thay đổi
    }
    
    private func setupKeyboardAppearance() {
        keyboardView = UIView(frame: view.frame)
        keyboardView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
    }
    
    private func createInputTextView() {
        inputTextView = UITextView()
        inputTextView.backgroundColor = UIColor.white
        inputTextView.layer.cornerRadius = 8
        inputTextView.font = UIFont.systemFont(ofSize: 16)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextView.delegate = self
        keyboardView.addSubview(inputTextView)
    }
    
    private func createExpandButton() {
        expandButton = UIButton(type: .system)
        expandButton.setTitle("Mở rộng", for: .normal)
        expandButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        expandButton.backgroundColor = UIColor.systemBlue
        expandButton.setTitleColor(.white, for: .normal)
        expandButton.layer.cornerRadius = 8
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        expandButton.addTarget(self, action: #selector(handleExpandButton), for: .touchUpInside)
        keyboardView.addSubview(expandButton)
    }
    
    private func createClearButton() {
        clearButton = UIButton(type: .system)
        clearButton.setTitle("Xoá", for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        clearButton.backgroundColor = UIColor.systemGray5
        clearButton.layer.cornerRadius = 8
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(handleClearButton), for: .touchUpInside)
        keyboardView.addSubview(clearButton)
    }
    
    private func createNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle("🌐", for: .normal)
        nextKeyboardButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        nextKeyboardButton.backgroundColor = UIColor.systemGray5
        nextKeyboardButton.layer.cornerRadius = 8
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        keyboardView.addSubview(nextKeyboardButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
            keyboardView.rightAnchor.constraint(equalTo: view.rightAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            inputTextView.topAnchor.constraint(equalTo: keyboardView.topAnchor, constant: 10),
            inputTextView.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: 10),
            inputTextView.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -10),
            inputTextView.heightAnchor.constraint(equalToConstant: 80),
            
            expandButton.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 10),
            expandButton.leftAnchor.constraint(equalTo: keyboardView.leftAnchor, constant: 10),
            expandButton.widthAnchor.constraint(equalTo: keyboardView.widthAnchor, multiplier: 0.5, constant: -15),
            expandButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 10),
            clearButton.rightAnchor.constraint(equalTo: keyboardView.rightAnchor, constant: -10),
            clearButton.widthAnchor.constraint(equalTo: keyboardView.widthAnchor, multiplier: 0.25, constant: -10),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            nextKeyboardButton.topAnchor.constraint(equalTo: inputTextView.bottomAnchor, constant: 10),
            nextKeyboardButton.leftAnchor.constraint(equalTo: expandButton.rightAnchor, constant: 5),
            nextKeyboardButton.rightAnchor.constraint(equalTo: clearButton.leftAnchor, constant: -5),
            nextKeyboardButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func handleExpandButton() {
        textToExpand = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let expansion = shortcutManager.findExpansion(for: textToExpand) {
            textDocumentProxy.insertText(expansion)
        } else {
            // Nếu không tìm thấy phím tắt, chèn văn bản gốc
            textDocumentProxy.insertText(textToExpand)
        }
        inputTextView.text = ""
    }
    
    @objc private func handleClearButton() {
        inputTextView.text = ""
    }
}

extension KeyboardViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Cập nhật textToExpand khi văn bản thay đổi
        textToExpand = textView.text
    }
} 