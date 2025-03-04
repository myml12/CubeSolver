# CubeSolver
Arduino等を用いてルービッキューブを物理的に解くマシンを製作したときに作成したプログラム

### CubeAnalyzer（Swift/C++）
キューブの各面を順に撮影し、OpenCVを用いて色を解析し得られた配色情報をPythonライブラリ"kociemba"で利用できる形式でFirebase Realtime Databaseに送信し、解法を受信しローカルサーバーにPOSTするiOSネイティブアプリケーション

### recieve.py（Python）
Firebase Realtime Databeseの変更を感知し、Pythonライブラリ"kociemba"で解を計算しふたたびdbを更新するPythonコード

### send_by_Serial.ino (Arduino/C++)
ESP32をサーバー化し、POSTされた文字列をシリアル通信でそのまま横流しするコード
Arduino mega2560では無線通信ができないためこの方式をとった。

### cube.ino（Arduino/C++）
Arduino mega2560に書き込んだコード
シリアル通信で文字列を受信し、ステッピングモーター（ST-42BYG020）を制御している。なおモータードライバーはNJW4350Dを使用した。
