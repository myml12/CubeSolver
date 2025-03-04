import SwiftUI
import FirebaseDatabase

struct ConfirmView: View {
    
    let databaseRef = Database.database(url: "Your Firebase RealtimeDatabase URL").reference()

    @State private var sendFlag = false
    @Binding var colorString: String
    @Binding var finishFlag: Bool
    
    var body: some View {
        VStack {
            Text("生成された文字列：\(colorString)")
                .padding()
                .font(.title2)
            
            if sendFlag {
                Text("送信完了")
                    .padding()
                    .font(.title2)
                    .foregroundColor(.blue)
                
            } else {
                Button("送信"){
                    sendData()
                }
                .padding()
                .font(.title2)
            }
            
            Button("最初から"){
                finishFlag = false
                sendFlag = false
            }
            .padding()
            .font(.title2)
            .foregroundColor(.red)
        }
        .padding()
    }
    
    private func sendData() {
        databaseRef.child("cube").setValue(colorString) { error, _ in
            if let error = error {
                print("Error updating status: \(error.localizedDescription)")
            } else {
                print("Successfully updated status to \(colorString)")
                self.sendFlag = true
            }
        }
    }
}

