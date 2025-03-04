#define rep(i,n) for(int i = 0 ; i < n ; i++ )

// ピンの定義
const int dirPin = 30;
const int stepPin = 31;
const int dirPin2 = 4; 
const int stepPin2 = 2;
const int dirPin3 = 8; 
const int stepPin3 = 6;
const int dirPin4 = 12; 
const int stepPin4 = 10;
const int dirPin5 = 38; 
const int stepPin5 = 39;
const int dirPin6 = 34; 
const int stepPin6 = 35;

const int delayTime = 1000;

const int stepsPerRevolution = 200;  // モーターの1回転あたりのステップ数


void setup() {
  Serial.begin(9600);
  pinMode(dirPin, OUTPUT);
  pinMode(stepPin, OUTPUT);
  pinMode(dirPin2, OUTPUT);
  pinMode(stepPin2, OUTPUT);
  pinMode(dirPin3, OUTPUT);
  pinMode(stepPin3, OUTPUT);
  pinMode(dirPin4, OUTPUT);
  pinMode(stepPin4, OUTPUT);
  pinMode(dirPin5, OUTPUT);
  pinMode(stepPin5, OUTPUT);
  pinMode(dirPin6, OUTPUT);
  pinMode(stepPin6, OUTPUT);
  Serial.println("Ready.");
}

void loop() {

  // シリアルデータが来た場合の処理
  if (Serial.available() > 0) {
    char input = Serial.read();
    
    if (input == 'r') {
      // 正方向に90度回転
      Serial.println("Rotating 90 degrees clockwise.");
      digitalWrite(dirPin, HIGH);
      rep(i,stepsPerRevolution/4) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'R') {
      // 逆方向に90度回転
      Serial.println("Rotating 90 degrees counterclockwise.");
      digitalWrite(dirPin, LOW);
      rep(i,stepsPerRevolution/4) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'l') {
      // Lステッパー: 正方向に90度回転
      Serial.println("Rotating 90 degrees clockwise (L).");
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(dirPin2, HIGH);
        digitalWrite(stepPin2, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin2, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'L') {
      // Lステッパー: 逆方向に90度回転
      Serial.println("Rotating 90 degrees counterclockwise (L).");
      digitalWrite(dirPin2, LOW);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin2, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin2, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'f') {
      // Fステッパー: 正方向に90度回転
      Serial.println("Rotating 90 degrees clockwise (F).");
      digitalWrite(dirPin3, HIGH);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin3, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin3, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'F') {
      // Fステッパー: 逆方向に90度回転
      Serial.println("Rotating 90 degrees counterclockwise (F).");
      digitalWrite(dirPin3, LOW);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin3, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin3, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'u') {
      // Uステッパー: 正方向に90度回転
      Serial.println("Rotating 90 degrees clockwise (U).");
      digitalWrite(dirPin4, HIGH);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin4, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin4, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'U') {
      // Uステッパー: 逆方向に90度回転
      Serial.println("Rotating 90 degrees counterclockwise (U).");
      digitalWrite(dirPin4, LOW);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin4, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin4, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'b') {
      // Bステッパー: 正方向に90度回転
      Serial.println("Rotating 90 degrees clockwise (B).");
      digitalWrite(dirPin5, HIGH);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin5, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin5, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'B') {
      // Bステッパー: 逆方向に90度回転
      Serial.println("Rotating 90 degrees counterclockwise (B).");
      digitalWrite(dirPin5, LOW);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin5, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin5, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'd') {
      // Dステッパー: 正方向に90度回転
      Serial.println("Rotating 90 degrees clockwise (D).");
      digitalWrite(dirPin6, HIGH);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin6, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin6, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'D') {
      // Dステッパー: 逆方向に90度回転
      Serial.println("Rotating 90 degrees counterclockwise (D).");
      digitalWrite(dirPin6, LOW);
      rep(i, stepsPerRevolution / 4) {
        digitalWrite(stepPin6, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin6, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'S') {
      // Sステッパー: 180度回転
      Serial.println("Rotating 180 degrees clockwise (S).");
      digitalWrite(dirPin, HIGH);
      rep(i, stepsPerRevolution / 2) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'M') {
      // Mステッパー: 180度回転
      Serial.println("Rotating 180 degrees clockwise (M).");
      digitalWrite(dirPin2, HIGH);
      rep(i, stepsPerRevolution / 2) {
        digitalWrite(stepPin2, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin2, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'G') {
      // Gステッパー: 180度回転
      Serial.println("Rotating 180 degrees clockwise (G).");
      digitalWrite(dirPin3, HIGH);
      rep(i, stepsPerRevolution / 2) {
        digitalWrite(stepPin3, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin3, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'V') {
      // Vステッパー: 180度回転
      Serial.println("Rotating 180 degrees clockwise (V).");
      digitalWrite(dirPin4, HIGH);
      rep(i, stepsPerRevolution / 2) {
        digitalWrite(stepPin4, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin4, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'C') {
      // Cステッパー: 180度回転
      Serial.println("Rotating 180 degrees clockwise (C).");
      digitalWrite(dirPin5, HIGH);
      rep(i, stepsPerRevolution / 2) {
        digitalWrite(stepPin5, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin5, LOW);
        delayMicroseconds(delayTime);
      }
    } else if (input == 'E') {
      // Eステッパー: 180度回転
      Serial.println("Rotating 180 degrees clockwise (E).");
      digitalWrite(dirPin6, HIGH);
      rep(i, stepsPerRevolution / 2) {
        digitalWrite(stepPin6, HIGH);
        delayMicroseconds(delayTime);
        digitalWrite(stepPin6, LOW);
        delayMicroseconds(delayTime);
      }
    } else {
      Serial.println("Invalid input.");
    }
  }
}
