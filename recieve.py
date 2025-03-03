import requests
import kociemba
import time
import json

# Firebaseの設定
DATABASE_URL = "https://compocollab-6fd75-default-rtdb.asia-southeast1.firebasedatabase.app/"

# 180度回転の変換表
def convert_moves(moves: str) -> str:
    rotate_180 = {
        'U2': 'V', 'R2': 'S', 'F2': 'G', 'L2': 'M', 'B2': 'C', 'D2': 'E'
    }
    
    result = []

    # スペースで区切られたそれぞれの操作を処理
    move_list = moves.split()
    
    for move in move_list:
        # 180度回転ならば変換
        if move in rotate_180:
            result.append(rotate_180[move])
        # 逆回転は小文字に変換
        elif "'" in move:
            result.append(move[0].lower())
        # 通常の回転はそのまま追加
        else:
            result.append(move[0])
    
    # リストを結合して文字列として返す
    return ''.join(result)

# ルービックキューブの状態を解く関数
def solve_cube(cube_state):
    try:
        print("solve関数に送るデータ:", cube_state)
        
        # 文字列の長さをチェック
        if len(cube_state) != 54:
            raise ValueError("キューブの状態は54文字でなければなりません。現在の長さ: {}".format(len(cube_state)))

        # 各色の数をカウント
        color_count = {color: cube_state.count(color) for color in 'URFDLB'}
        for color, count in color_count.items():
            if count != 9:
                raise ValueError(f"色'{color}'は9回出現する必要があります。現在の数: {count}")

        # kociembaライブラリで解を計算
        solution = kociemba.solve(cube_state)
        return solution
    except Exception as e:
        print("解決エラー:", e)
        return "error"

# cubeキーのデータを取得する関数
def get_cube_data():
    response = requests.get(f"{DATABASE_URL}/cube.json")
    if response.status_code == 200:
        # JSONから文字列を取得
        cube_data = json.loads(response.text)
        return cube_data  # 辞書として返す
    else:
        print("データの取得に失敗:", response.status_code, response.text)
        return None

# ansキーに解をアップデートする関数
def update_answer(solution):
    response = requests.put(f"{DATABASE_URL}/ans.json", json=solution)
    if response.status_code == 200:
        print("解を'ans'に保存:", solution)
    else:
        print("解のアップデートに失敗:", response.status_code, response.text)

# ansキーに解をアップデートする関数
def update_answer2(solution):
    response = requests.put(f"{DATABASE_URL}/ans2.json", json=solution)
    if response.status_code == 200:
        print("解を'ans2'に保存:", solution)
    else:
        print("解のアップデートに失敗:", response.status_code, response.text)

# データの変更を監視して処理を行うメインループ
def main_loop():
    previous_data = None
    while True:
        cube_data = get_cube_data()
        if cube_data and cube_data != previous_data:  # データが更新された場合のみ処理
            print("更新されたデータ:", cube_data)
            solution = solve_cube(cube_data)  # cube_dataが文字列であることを確認
            if solution != "error":  # 解決に成功した場合のみ
                update_answer2(solution)  # ans2に保存
                converted_solution = convert_moves(solution)  # 解法を変換
                update_answer(converted_solution)  # ansに保存
            previous_data = cube_data
        time.sleep(2)  # 2秒ごとにデータをチェック

if __name__ == "__main__":
    main_loop()
