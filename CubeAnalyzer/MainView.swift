import SwiftUI
import PhotosUI

struct MainView: View {
    
    //最終的に送信する文字列
    @Binding var colorString: String
    @Binding var tabselection: Int
    
    @State private var image: UIImage? = nil
    @State private var showingCamera: Bool = false
    @State private var showingPhotoPicker: Bool = false
    @State private var detectedData: String = ""
    //撮影フェーズ
    @State private var phase: [String] = [ "U", "R", "F", "D", "L", "B" ]
    @State private var phasenum: Int = 0
    @State private var finishFlag = false
    @State private var capFlag = false
    
    // フォトライブラリから選択したアイテムを保持するための変数
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            
            Button("DEMO") {
                //デモモードでサンプル画像を代入する
                image = UIImage(named: "sample")
            }
            .padding()
            .font(.title2)
            
            Text("電研2024 Cube Analyzer")
                .font(.title2)
                .padding()
            
            if let uiImage = image {
                Text("\(phase[phasenum])面撮影結果")
                    .font(.title2)
                    .padding()
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .clipped() // はみ出した部分をクリッピング
                
            } else {
                VStack{
                    Text("\(phase[phasenum])面を撮影してください")
                        .padding()
                        .font(.title2)
                    
                    ZStack {
                        // カメラプレビューを表示
                        CameraPreview(image: $image)
                            .frame(width: 340, height: 340) // 正方形のカメラプレビュー
                        
                        // グリッドをオーバーレイ
                        GridOverlay()
                            .frame(width: 330, height: 330)
                        
                    }
                    .frame(width: 300, height: 300)
                    .background(Color.black) // カメラがない場合の背景
                    
                    if image == nil {
                        // 撮影ボタンをZStackでオーバーレイ
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    capturePhoto() // 撮影アクションを追加
                                }) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 70, height: 70)
                                        .overlay(Text("OK").foregroundColor(.white))
                                }
                            }
                            .padding(.trailing, 30) // 画面右端に配置
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            
            if image != nil {
                Text("解析データ: \(detectedData)")
                    .padding()
                    .font(.title2)
                
                    .padding()
                    .onAppear() {
                        //画像をリサイズ
                        image = resizeImage(image: image ?? UIImage())
                        //表示する際に色を解析
                        if let selectedImage = image {
                            detectedData = OpenCVCube.detectColors(in: selectedImage)
                            detectedData = detectedData.replacingOccurrences(of: "S", with: phase[phasenum])
                            
                            if !capFlag {
                                colorString += detectedData
                                capFlag = true
                            }
                            
                        }
                    }
                
                if phasenum < 5 {
                    Button("次の面を撮影する"){
                        phasenum += 1
                        image = nil
                        capFlag = false
                    }
                    .font(.title3)
                    .padding()
                } else {
                    Button("撮影完了"){
                        image = nil
                        detectedData = ""
                        phasenum = 0
                        image = nil
                        tabselection = 1
                        capFlag = false
                    }
                    .font(.title3)
                    .padding()
                }
                
                Button("再撮影") {
                    colorString = String(colorString.dropLast(9))
                    image = nil
                    capFlag = false
                }
                .padding()
                .foregroundColor(.red)
            }
            
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage? {
        let targetSize = CGSize(width: 300, height: 300)
        
        // 元の画像のアスペクト比を計算
        let originalSize = image.size
        let originalAspect = originalSize.width / originalSize.height
        let targetAspect = targetSize.width / targetSize.height
        
        var drawRect: CGRect
        
        // アスペクト比に基づいて描画領域を決定
        if originalAspect > targetAspect {
            // 元の画像が横長の場合
            let scale = targetSize.height / originalSize.height
            let scaledWidth = originalSize.width * scale
            drawRect = CGRect(x: (targetSize.width - scaledWidth) / 2, y: 0, width: scaledWidth, height: targetSize.height)
        } else {
            // 元の画像が縦長または正方形の場合
            let scale = targetSize.width / originalSize.width
            let scaledHeight = originalSize.height * scale
            drawRect = CGRect(x: 0, y: (targetSize.height - scaledHeight) / 2, width: targetSize.width, height: scaledHeight)
        }
        
        // 指定したサイズで画像を描画
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { context in
            image.draw(in: drawRect)
        }
        
        return resizedImage
    }
    
    // ContentView内のcapturePhoto()アクション
    func capturePhoto() {
        // カメラプレビュー内のカメラ撮影アクションを呼び出す
        NotificationCenter.default.post(name: NSNotification.Name("CapturePhoto"), object: nil)
    }
    
}

struct GridOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let cellWidth = width / 3
            let cellHeight = height / 3
            
            Path { path in
                // 縦のグリッド線を描画
                for i in 0..<4 {
                    let xPos = cellWidth * CGFloat(i)
                    path.move(to: CGPoint(x: xPos, y: 0))
                    path.addLine(to: CGPoint(x: xPos, y: height))
                }
                
                // 横のグリッド線を描画
                for i in 0..<4 {
                    let yPos = cellHeight * CGFloat(i)
                    path.move(to: CGPoint(x: 0, y: yPos))
                    path.addLine(to: CGPoint(x: width, y: yPos))
                }
            }
            .stroke(Color.red, lineWidth: 2)
        }
    }
}
