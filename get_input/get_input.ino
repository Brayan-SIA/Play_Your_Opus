#define FRET1 7
#define FRET2 6
#define FRET3 5
#define PICK  3
#define FRET1_LED 11
#define FRET2_LED 10
#define FRET3_LED 9

void setup() {
  Serial.begin(9600);
  pinMode(FRET1, INPUT);
  pinMode(FRET2, INPUT);
  pinMode(FRET3, INPUT);
  pinMode(PICK, INPUT);
  pinMode(12,OUTPUT);
  pinMode(FRET1_LED,OUTPUT);
  pinMode(FRET2_LED,OUTPUT);
  pinMode(FRET3_LED,OUTPUT);
}

int before = 0;

void loop() {
  digitalWrite(12, HIGH);
  
  int fret1=0, fret2=0, fret3=0, pick=0;
  
  for(int i = 0; i < 40; i++){
    fret1+=digitalRead(FRET1);
    fret2+=digitalRead(FRET2);
    fret3+=digitalRead(FRET3);
    pick+=digitalRead(PICK);
  }
  if(fret1 >= 30) fret1 = 1;
  else fret1 = 0;
  if(fret2 >= 30) fret2 = 1;
  else fret2 = 0;
  if(fret3 >= 30) fret3 = 1;
  else fret3 = 0;
  if(pick >= 30) pick = 1;
  else pick = 0;

  int now = fret1 * 1000 + fret2 * 100 + fret3 * 10 + pick;
  if(before != now){
    digitalWrite(FRET1_LED, fret1);
    digitalWrite(FRET2_LED, fret2);
    digitalWrite(FRET3_LED, fret3);

    Serial.print(fret1);
    Serial.print(",");
    Serial.print(fret2);
    Serial.print(",");
    Serial.print(fret3);
    Serial.print(",");
    Serial.print(pick);
    Serial.print("\n");
  }
  before = now;
  delay(50);
}
