#import "opencv2/opencv.hpp"
#import "OpenCVCube.h"

@implementation OpenCVCube

// 色分類基準
+ (char)classifyColor:(cv::Scalar)color {
    double r = color[2];
    double g = color[1];
    double b = color[0];
    
    // 面名称
    // 定義する色のリスト (BGR)
    std::vector<std::pair<cv::Scalar, char>> predefinedColors = {
        {cv::Scalar(25, 40, 255), 'R'},  // 赤 Right
        {cv::Scalar(50, 235, 0), 'F'},  // 緑 Front
        {cv::Scalar(240, 145, 0), 'B'},  // 青 Back
        {cv::Scalar(0, 240, 170), 'D'}, // 黄 Down
        {cv::Scalar(30, 72, 255), 'L'}, // 橙 Left
        {cv::Scalar(230, 230, 230), 'U'}  // 白 Up
    };

    // 最も近い色を見つける
    char closestColor = 'U';
    double minDistance = std::numeric_limits<double>::max();  // 初期値として無限大

    for (const auto& predefinedColor : predefinedColors) {
        cv::Scalar predefinedBGR = predefinedColor.first;
        char colorChar = predefinedColor.second;

        // ユークリッド距離を計算
        double distance = sqrt(pow(predefinedBGR[0] - b, 2) +
                               pow(predefinedBGR[1] - g, 2) +
                               pow(predefinedBGR[2] - r, 2));

        // 最も近い色を更新
        if (distance < minDistance) {
            minDistance = distance;
            closestColor = colorChar;
        }
    }

    return closestColor;  // 最も近い色を返す
}

+ (NSString *)detectColorsInImage:(UIImage *)image {
    cv::Mat mat;
    
    // UIImageをcv::Matに変換
    mat = [self UIImageToCVMat:image];
    if (mat.empty()) {
        NSLog(@"Failed to convert UIImage to cv::Mat");
        return @"";
    }
    
    // 画像サイズを取得
    int width = mat.cols;
    int height = mat.rows;
    
    int gridSize = 3;  // グリッドサイズ（3x3）
    int cellWidth = width / gridSize;
    int cellHeight = height / gridSize;
    
    std::string detectedColors = "";

    for (int i = 0; i < gridSize; i++) {
        for (int j = 0; j < gridSize; j++) {
            
            //センターキューブは固定色なので"S"としておく
            if (i == 1 && j == 1) {
                detectedColors += "S";
                continue;
            }
            
            int cellX = j * cellWidth + cellWidth / 4;
            int cellY = i * cellHeight + cellHeight / 4;
            int centerX = cellX + cellWidth / 4; // セルの中心X座標
            int centerY = cellY + cellHeight / 4; // セルの中心Y座標

            // 半径50ピクセルの円の範囲を定義
            cv::Rect boundingBox(centerX - 50, centerY - 50, 100, 100);
            
            // バウンディングボックスの範囲が画像の範囲内に収まるようにクリッピング
            boundingBox &= cv::Rect(0, 0, mat.cols, mat.rows);

            // バウンディングボックス内の平均色を取得
            cv::Mat cellMat = mat(boundingBox);
            cv::Scalar avgColor = cv::mean(cellMat);
            char colorChar = [self classifyColor:avgColor];
            detectedColors += colorChar;

            // コンソールにピクセル情報を出力
            NSLog(@"Cell [%d, %d]: Center (%d, %d) - Average Color: R(%f) G(%f) B(%f) => Detected Color: %c",
                  i, j, centerX, centerY, avgColor[2], avgColor[1], avgColor[0], colorChar);
        }
    }

    
    return [NSString stringWithUTF8String:detectedColors.c_str()];
}


//Mat形式に変換
+ (cv::Mat)UIImageToCVMat:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    if (!imageRef) {
        NSLog(@"Failed to get CGImage from UIImage");
        return cv::Mat();
    }

    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) {
        NSLog(@"Invalid image dimensions: %zux%zu", width, height);
        return cv::Mat();
    }

    cv::Mat mat = cv::Mat((int)height, (int)width, CV_8UC4);
    
    // Bitmap contextを作成する際、CGColorSpaceを明示的に指定
    CGContextRef context = CGBitmapContextCreate(mat.data,
                                                 mat.cols,
                                                 mat.rows,
                                                 8,                     // 8 bits per component
                                                 mat.step[0],           // bytes per row
                                                 CGColorSpaceCreateDeviceRGB(),
                                                 kCGImageAlphaPremultipliedLast); // ビット演算を使わない

    if (!context) {
        NSLog(@"Failed to create bitmap context");
        return cv::Mat();
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, mat.cols, mat.rows), imageRef);
    CGContextRelease(context);
    
    cv::cvtColor(mat, mat, cv::COLOR_RGBA2BGR);
    
    return mat;
}

@end
