import SwiftUI

struct CubeView: View {
    
    @Binding var colorString: String
    @Binding var tabselection: Int
    
    // 色の定義（U:白, F:緑, R:赤, D:黄, L:オレンジ, B:青）
    let colors: [Character: Color] = [
        "U": .white,
        "F": .green,
        "R": .red,
        "D": .yellow,
        "L": .orange,
        "B": .blue,
    ]
    let defaultColor: Color = .gray  // デフォルト色（不完全なデータの場合）
    
    var body: some View {
        
        VStack {
            Text("Color Check")
                .padding()
                .font(.title2)
            
            Text("分析結果：\(colorString)")
                .padding()
                .font(.title3)
            
            GeometryReader { geometry in
                let cellSize = min(geometry.size.width, geometry.size.height) / 14  // 各セルのサイズを動的に計算
                
                VStack(spacing: cellSize / 4) {
                    
                    // 上面（U面） - F面に合わせる
                    HStack {
                        CubeFaceView2(cellSize: cellSize)
                        CubeFaceView(face: "U", offset: 0, cubeString: colorString, colors: colors, defaultColor: defaultColor, cellSize: cellSize) // U面のオフセットを調整
                        CubeFaceView2(cellSize: cellSize)
                        CubeFaceView2(cellSize: cellSize)
                    }
                    
                    HStack(spacing: cellSize / 4) {
                        // 左面、前面、右面、背面を1行に並べる
                        CubeFaceView(face: "L", offset: 36, cubeString: colorString, colors: colors, defaultColor: defaultColor, cellSize: cellSize)
                        CubeFaceView(face: "F", offset: 18, cubeString: colorString, colors: colors, defaultColor: defaultColor, cellSize: cellSize) // F面のオフセットを0に
                        CubeFaceView(face: "R", offset: 9, cubeString: colorString, colors: colors, defaultColor: defaultColor, cellSize: cellSize)
                        CubeFaceView(face: "B", offset: 45, cubeString: colorString, colors: colors, defaultColor: defaultColor, cellSize: cellSize)
                    }
                    
                    // 下面（D面） - F面に合わせる
                    HStack {
                        CubeFaceView2(cellSize: cellSize)
                        CubeFaceView(face: "D", offset: 27, cubeString: colorString, colors: colors, defaultColor: defaultColor, cellSize: cellSize) // D面のオフセットを調整
                        CubeFaceView2(cellSize: cellSize)
                        CubeFaceView2(cellSize: cellSize)
                    }
                    
                    Button("撮影") {
                        tabselection = 0
                    }
                    .padding()
                    .font(.title2)
                    
                }
                
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .padding()
    }
}

// 各面の描画ビュー
struct CubeFaceView: View {
    let face: Character
    let offset: Int
    let cubeString: String
    let colors: [Character: Color]
    let defaultColor: Color
    let cellSize: CGFloat  // セルサイズを引数として受け取る
    
    var body: some View {
        VStack(spacing: cellSize / 4) {
            ForEach(0..<3) { row in
                HStack(spacing: cellSize / 4) {
                    ForEach(0..<3) { col in
                        let index = offset + row * 3 + col
                        let color = colorForIndex(index: index)
                        ColorView(color: color, cellSize: cellSize)
                    }
                }
            }
        }
    }
    
    // 指定インデックスの色を取得
    func colorForIndex(index: Int) -> Color {
        if index < cubeString.count {
            let colorChar = cubeString[cubeString.index(cubeString.startIndex, offsetBy: index)]
            return colors[colorChar] ?? defaultColor
        } else {
            return defaultColor  // 不完全な文字列の場合、デフォルト色
        }
    }
}

struct CubeFaceView2: View {
    let cellSize: CGFloat  // セルサイズを引数として受け取る
    
    var body: some View {
        VStack(spacing: cellSize / 4) {
            ForEach(0..<3) { row in
                HStack(spacing: cellSize / 4) {
                    ForEach(0..<3) { col in
                        ColorView(color: .black, cellSize: cellSize)
                    }
                }
            }
        }
    }
}

// 色付き四角形を描画するためのカスタムビュー
struct ColorView: View {
    let color: Color
    let cellSize: CGFloat  // セルサイズを引数として受け取る
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: cellSize, height: cellSize)
            .border(Color.black)  // 枠線を追加
    }
}
