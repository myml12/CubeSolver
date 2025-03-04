#include <WiFi.h>
#include <WebServer.h>

HardwareSerial mySerial(1);  // Serial1を使用

// Wi-Fi設定
const char* ssid = "YOUR SSID";        // WiFiのSSID
const char* password = "YOUR PASSWORD"; // WiFiのパスワード

// 固定IPの設定
IPAddress local_IP(172, 20, 10, 8);     // 固定IPアドレスを172.20.10.8に設定
IPAddress gateway(172, 20, 10, 1);      // ゲートウェイアドレス
IPAddress subnet(255, 255, 255, 0);     // サブネットマスク
IPAddress primaryDNS(8, 8, 8, 8);       // プライマリDNS（Google DNS）
IPAddress secondaryDNS(8, 8, 4, 4);     // セカンダリDNS（Google DNS）

// Webサーバーのインスタンス
WebServer server(80); // ポート80を使う

// POSTデータを受け取り処理する
void handlePostData() {
  if (server.hasArg("plain")) {
    String postData = server.arg("plain");  // POSTされたデータを取得
    // StringをC文字列に変換してSerial1に送信
    mySerial.write(postData.c_str());  // 文字列を送信

    // クライアントに成功レスポンスを送信
    server.send(200, "text/plain", "Data received.");
  } else {
    server.send(400, "text/plain", "No data received"); // エラーの場合
  }
}

void setup() {
  // シリアルモニタを開始
  Serial.begin(9600);
  mySerial.begin(9600, SERIAL_8N1, 32, 33);  // RX: GPIO32, TX: GPIO33

  // 固定IPをWi-Fiに設定
  if (!WiFi.config(local_IP, gateway, subnet, primaryDNS, secondaryDNS)) {
    Serial.println("STA Failed to configure");
  }

  // Wi-Fiに接続
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi!");

  // 接続されたIPアドレスを出力
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  // POSTデータを受け取るエンドポイントを設定
  server.on("/post", HTTP_POST, handlePostData);  // POSTリクエストを処理

  // サーバーを開始
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient(); // クライアントからのリクエストを処理
}
