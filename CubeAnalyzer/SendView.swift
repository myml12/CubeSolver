import SwiftUI
import FirebaseDatabase

struct SendView: View {
    
    @Binding var colorString: String
    @Binding var tabselection: Int
    
    @State private var ansValue: String = ""             // Realtime Databaseから取得した値を保持
    @State private var ansValue2: String = ""
    @State private var responseText: String = ""         // HTTPレスポンスを保持
    @State private var sendFlag = false
    private let dbRef = Database.database().reference()  // Database参照
    
    let databaseRef = Database.database(url: "Your FirebaseRealtimeDatabase URL").reference()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button("分析結果リセット") {
                    colorString = ""
                    deleteAnsData()
                }
                .padding()
                    .font(.title3)
                    .foregroundColor(.red)
                
                Text("分析結果：")
                    .padding()
                    .font(.title2)
                TextEditor(text: $colorString)
                    .font(.title2)
                    .padding()
                
                Button("Send to server"){
                    sendData()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Text("解析結果：\(ansValue2)")
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding()
                Text("送信文字列：\(ansValue)")
                    .font(.title3)
                    .padding()
                
                // POSTリクエストを実行するボタン
                Button(action: {
                    sendFlag = true
                }) {
                    Text("Start Solving")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .alert(isPresented: $sendFlag) {
                    Alert(
                        title: Text("Start Solving"),
                        message: Text("POST to 172.20.10.8"),
                        primaryButton: .default(Text("OK")) {
                            postAnsValue()
                            deleteAnsData()
                        },
                        secondaryButton: .cancel(Text("キャンセル"))
                    )
                }
                
                // HTTPレスポンスを表示
                Text("サーバーレスポンス：\(responseText)")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Spacer()
                
            }
            .padding()
            .onAppear {
                observeAnsValue()
            }
        }
    }
    
    
    
    /// Firebase Realtime Databaseの "ans" キーを監視して、値が更新されたらansValueを更新
    private func observeAnsValue() {
        dbRef.child("ans").observe(.value) { snapshot in
            if let value = snapshot.value as? String {
                ansValue = value
            }
        }
        dbRef.child("ans2").observe(.value) { snapshot in
            if let value = snapshot.value as? String {
                ansValue2 = value
            }
        }
    }
    
    // ansの値を指定のURLにPOSTで送信し、レスポンスをresponseTextに保存
    private func postAnsValue() {
        guard let url = URL(string: "http://172.20.10.8/post") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = ansValue.data(using: .utf8)   // ansの値をPOSTの本文として設定
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    responseText = "エラー: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    responseText = responseString  // レスポンスを表示
                }
            } else {
                DispatchQueue.main.async {
                    responseText = "無効なレスポンス"
                }
            }
        }
        
        task.resume()
    }
    
    private func sendData() {
        databaseRef.child("cube").setValue(colorString) { error, _ in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Successfully updated status to \(colorString)")
            }
        }
    }
    
    private func deleteAnsData() {
        databaseRef.child("ans").setValue("") { error, _ in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Successfully updated status")
            }
        }
        databaseRef.child("ans2").setValue("") { error, _ in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Successfully updated status")
            }
        }
    }
}
