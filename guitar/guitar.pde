import ddf.minim.*;    //音源ファイル操作用ライブラリ
import ddf.minim.ugens.*;    //音源ファイル操作用ライブラリ
import controlP5.*;    //GUI作成用ライブラリ(クリックできるボタンなど)
import javax.swing.*;  //ファイル処理のライブラリ
import java.io.FileWriter;  //ファイル書き込み用ライブラリ
import java.io.IOException;  //例外処理用
import javax.swing.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.Toolkit;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import processing.serial.*; 

Serial myPort;    /*宣言*/

Minim minim;                  //minim変数
AudioPlayer music;            //プレイ中の音楽
AudioPlayer sound_select;     //選択音
AudioPlayer sound_enter;      //決定音
AudioPlayer show_music;       //選択中に流す曲
Music playing_music;          //プレイ中の曲
Sampler sampler;
AudioOutput audio_output;

boolean m_play = false;       //再生中か否か

PFont font;

ControlP5 Button;                        //GUI作成用ライブラリ宣言
color color_off = color(160, 160, 160);  //スイッチなどがフォーカスされていないときの色

/*画像*/
PImage image_note1;          //第一フレット
PImage image_note2;          //第二フレット
PImage image_note3;          //第三フレット
PImage image_note4;          //開放フレット
PImage image_long_note1;     //第一フレット
PImage image_long_note2;     //第二フレット
PImage image_long_note3;     //第三フレット
PImage image_long_note4;     //開放フレット
PImage image_back_note1;     //第一フレット
PImage image_back_note2;     //第二フレット
PImage image_back_note3;     //第三フレット
PImage image_back_ground;    //背景
PImage image_perfect;        //パーフェクト判定の画像
PImage image_great;          //グレイト判定の画像
PImage image_good;           //グッド判定の画像

/*設定情報*/
FileManager fm;
ArrayList<Music> List_music;   //フォルダ内にある曲のリスト
ArrayList<Note> List_play;    //現在プレイ中の曲情報
ArrayList<Note> List_tmp;     //リスト削除時の退避用
MODE mode;                    //現在のモード
float notes_speed;            //Notesの移動速度
int position;                 //現在の再生位置 
Note new_note;                //記録する新しいノーツ
int shift;                    //正解との誤差
int shift_long;               //正解との誤差(長押しノーツ用)
int select = 0;               //選択中のインデックス（番号）
boolean keep = false;         //長押し判断用
int save_pos = 0;             //最後に記録した位置
int save_combo;
int save_score;
int combo = 0;                //現在のコンボ数

boolean pause_now = false;   //PAUSE中か否か

PrintWriter record_file;      //作成したレコードファイル
PrintWriter rank_file;       //作成したランキングファイル

Button button_select_play;    //モード選択画面PLAYボタン
Button button_select_record;  //モード選択画面RECODEボタン

boolean fret1 = false;        //第１フレットの状態(aキー)
boolean fret2 = false;        //第２フレットの状態(sキー)
boolean fret3 = false;        //第３フレットの状態(dキー)
boolean pick = false;         //弦の状態(ENTERキー)
boolean pause = false;        //PAUSEボタン

int count = 0;                //カウントダウン用
int wait = 0;                 //待ち時間用
int step = 0;                 //状態遷移用

int score = 0;                //得点
int score_perfect = 1000;     //Perfect判定の得点
int score_great = 800;        //Great判定の得点
int score_good = 500;         //Good判定の得点
int rank = 0;                 //何位か
int view_rank = 0;            //何位かを表示するよう

/*それぞれのノーツが流れてくる位置*/
float f1_x;
float f2_x;
float f3_x;

float note_line = 100;        //判定ライン

void settings(){
  fullScreen(P2D);      //初期画面サイズ指定
}

void setup()
{ 
  //myPort = new Serial(this, "COM8", 9600); //シリアル通信設定 ※Arduinoと同じにする
  
  textAlign(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  
  frameRate(60);

  notes_speed = height/frameRate;

  font = createFont("font\\PixelMplus12-Bold.ttf", 48);  //基本となるフォントを用意
  
  minim = new Minim(this);                        //minimの初期化
  sound_select = minim.loadFile("sound\\select.wav");    //効果音ファイルを読み込む 
  sound_select.rewind();                          //再生位置を先頭へ戻す
  minim = new Minim(this);                        //minimの初期化
  sound_enter = minim.loadFile("sound\\enter.wav");      //効果音ファイルを読み込む 
  sound_enter.rewind();                           //再生位置を先頭へ戻す

  image_note1 = loadImage("image\\note1.png");  //ノーツの画像を読み込む
  image_note2 = loadImage("image\\note2.png");  //ノーツの画像を読み込む
  image_note3 = loadImage("image\\note3.png");  //ノーツの画像を読み込む
  image_note4 = loadImage("image\\note4.png");  //ノーツの画像を読み込む
  image_long_note1 = loadImage("image\\long_note1.png");  //ノーツの画像を読み込む
  image_long_note2 = loadImage("image\\long_note2.png");  //ノーツの画像を読み込む
  image_long_note3 = loadImage("image\\long_note3.png");  //ノーツの画像を読み込む
  image_long_note4 = loadImage("image\\long_note4.png");  //ノーツの画像を読み込む
  image_back_note1 = loadImage("image\\back_note1.png");  //ノーツの画像を読み込む
  image_back_note2 = loadImage("image\\back_note2.png");  //ノーツの画像を読み込む
  image_back_note3 = loadImage("image\\back_note3.png");  //ノーツの画像を読み込む
  image_back_ground = loadImage("image\\back_ground.png");  //背景の画像を読み込む
  image_perfect = loadImage("image\\perfect.png");  //判定画像を読み込む
  image_great = loadImage("image\\great.png");  //判定画像を読み込む
  image_good = loadImage("image\\good.png");  //判定画像を読み込む

  fm = new FileManager();
  List_music = new ArrayList<Music>();    //曲のリストを用意
  List_play = new ArrayList<Note>();     //プレイ中のNotesのリストを用意
  List_tmp = new ArrayList<Note>();      //退避用のリストを用意

  mode = MODE.SELECT_MODE;               //モードをモード選択状態に初期化
  
  textAlign(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  textFont(font);

  /*ボタンの用意*/
  Button = new ControlP5(this);
  button_select_play = createButton("buttonPlay", "PLAY", 0, 0, width/2, height, color_off, color(255, 127, 127), color(255), color(255, 191, 127), 200);            //選択画面でのPLAYボタン
  button_select_record = createButton("buttonRecord", "RECORD", width/2, 0, width/2, height, color_off, color(127, 191, 255), color(255), color(255, 191, 127), 200);  //選択画面でのPLAYボタン
}

void draw()
{ 
  //get_input();
  
  drawPlayWindow();
}

/*入力*/
void get_input()
{
  String get_data = myPort.readStringUntil('\n');  //改行文字まで読み込む(1行よむ)
  
  if(get_data != null){                            //何かあったら
      get_data = trim(get_data);                     //改行文字を削る
      int[] data = int(split(get_data, ','));        //カンマ区切りで取り出す
      if(data.length >= 4){
      if(data[0] == 1) fret1 = true; 
      else fret1 = false;
      if(data[1] == 1) fret2 = true; 
      else fret2 = false;
      if(data[2] == 1) fret3 = true; 
      else fret3 = false;
      if(data[3] == 1) pick = true; 
      else pick = false;
      }
  }
}

/*プレイ画面描写用*/
public void drawPlayWindow()
{
  boolean move;
     
  background(0);                  //画面のクリア
  
  image(image_back_ground, width/2, height/2, width, height);

  if(count > 0){      //カウントダウンが必要だったら
    textSize(width/7);
    fill(220);
    text(count/60+1, width/2, height/2);
    count--;
    pause_now = true;
  }
  else{
    switch(mode) {                  //状態を確認
      case SELECT_MODE:               /*モード選択画面*/
        showButtons();
        break;
        
      case SELECT_PLAY:               /*曲選択画面*/
        move = false;          //操作があったかどうかの変数
        if (fret1 && select > 0) {     //一番最初を選択していない状態で第一フレットが押されたら
          select--;                      //選択中のインデックスを一つ上に
          sound_select.play(0);           //効果音を再生
          if(show_music != null)show_music.close();
          show_music = minim.loadFile("music\\" + List_music.get(select).name + ".mp3");      //効果音ファイルを読み込む 
          show_music.setGain(-10);        //音量を設定
          show_music.rewind();                           //再生位置を先頭へ戻す
          show_music.play();
          move = true;                   //操作があった状態へ
        }
        else if(fret1 && select == 0){
          select = List_music.size() - 1;
          sound_select.play(0);           //効果音を再生
          if(show_music != null)show_music.close();
          show_music = minim.loadFile("music\\" + List_music.get(select).name + ".mp3");      //効果音ファイルを読み込む 
          show_music.setGain(-10);        //音量を設定
          show_music.rewind();                           //再生位置を先頭へ戻す
          show_music.play();
          move = true;                   //操作があった状態へ
        }
        if (fret3 && select < List_music.size() - 1) {  //一番最後を選択していない状態で第三フレットがおされたら
          select++;                      //選択中のインデックスを一つ下へ
          sound_select.play(0);           //効果音を再生
          if(show_music != null)show_music.close();
          show_music = minim.loadFile("music\\" + List_music.get(select).name + ".mp3");      //効果音ファイルを読み込む 
          show_music.rewind();            //再生位置を先頭へ戻す
          show_music.setGain(-10);        //音量を設定
          show_music.play();
          move = true;                   //操作があった状態へ
        }
        else if(fret3 && select == List_music.size()-1){
          select = 0;
          sound_select.play(0);           //効果音を再生
          if(show_music != null)show_music.close();
          show_music = minim.loadFile("music\\" + List_music.get(select).name + ".mp3");      //効果音ファイルを読み込む 
          show_music.rewind();            //再生位置を先頭へ戻す
          show_music.setGain(-10);        //音量を設定
          show_music.play();
          move = true;                   //操作があった状態へ        
        }
        if (List_music.size() > 0) {     //曲のリストに一つ以上曲が入っていたら
          displaySelect();                 //選択画面を表示        

          if (pick) {                      //弦が押されたら
            sound_enter.play(0);              //効果音を再生
            if(show_music != null) show_music.close();
            selectMusic();                   //曲選択
            List_play = fm.loadRecord(playing_music.name);                    //ノーツを読み込む
            move = true;                     //操作があった状態へ
          }
        }
        if (move) delay(300);  //操作があったら150msまつ(連続入力防止)
        break;
        
      case PAUSE_PLAY:              /*プレイ中のPAUSE画面*/
        move = false;          //操作があったかどうかの変数
        if (fret1 && select > 0) {     //一番最初を選択していない状態で第一フレットが押されたら
          select--;                      //選択中のインデックスを一つ上に
          sound_select.play(0);           //効果音を再生
          move = true;                   //操作があった状態へ
        }
        if (fret3 && select < 3) {  //一番最後を選択していない状態で第三フレットがおされたら
          select++;                      //選択中のインデックスを一つ下へ
          sound_select.play(0);           //効果音を再生
          move = true;                   //操作があった状態へ
        }
      
        displaySelect();  //メニューを表示
      
        if (pick) {                      //弦が押されたら
          sound_enter.play(0);              //効果音を再生
          switch(select){                  //選択項目を確認
            case 0:                         /*再開*/
              mode = MODE.PLAY;             //プレイ中に戻す
              count = 180;                  //カウントダウン
              break;
            case 1:                       /*現時点まで記録*/
              save_pos = music.position();  //最後位置に記録
              mode = MODE.PLAY;             //プレイ中に戻す
              count = 180;                  //カウントダウン
              break;
            case 2:                       /*最後の記録からやり直し*/
              music.cue(save_pos);          //再生位置を最後の記録地点へ
              for(Note n : List_play){      //入力されたノーツを確認
                if(n.time <= save_pos){       //ノーツが最後の記録地点以前だったら
                  List_tmp.add(n);              //ノーツを退避
                }
              }
              List_play.clear();            //ノーツをクリア
              List_play = List_tmp;         //退避したノーツを格納
              List_tmp = new ArrayList<Note>();
              List_tmp.clear();             //ノーツをクリア
              mode = MODE.PLAY;             //プレイ中に戻す
              count = 180;                  //カウントダウン
              break;
            case 3:                       /*曲選択へ戻る*/
              reset();                      //初期化
              mode = MODE.SELECT_PLAY;      //モード選択へ戻る
              break;
          }
          delay(500);
          move = true;                   //操作があった状態へ
        }
     
        if (move) delay(300);  //操作があったら150msまつ(連続入力防止)
        break;
        
      case PLAY:                      /*プレイ中*/
        if(music.isPlaying() == false && pause_now){  //再生されていなかったら
          music.play();                                 //再生する
          pause_now = false;
        }
        /*UIの表示*/
        if(fret1) image(image_back_note1, f1_x, height - (height/10), width/5, height/5);
        if(fret2) image(image_back_note2, f2_x, height - (height/10), width/5, height/5);
        if(fret3) image(image_back_note3, f3_x, height - (height/10), width/5, height/5);

        fill(200);
        rect(width/2, height-note_line, width, 10);
        fill(150);
        rect(f1_x, height/2, 5,height);
        rect(f2_x, height/2, 5,height);
        rect(f3_x, height/2, 5,height);
        fill(200);
        textSize(width/15);
        text(score, width/4, height/6);
        text(combo + "combo!", width*2/3, height/6);
        if(music.isPlaying() == false && position == 0){  //再生されていなかったら
          music.play();                                     //再生する
        }
        position = music.position();    //現在の再生位置を取得
        for (Note note : List_play) {     //ノーツの分だけループ
          if(note.time > position + 50000/notes_speed && note.time_finish > position + 50000/notes_speed) break;  //結構先だったらすきっぷ
          else if(note.time > position - 50000/notes_speed || note.time_finish > position - 50000/notes_speed){          //結構前じゃなければ
            note.movePlay();                //出現と移動            
            if (note.is || note.is_finish || note.end_finish == false) {  //画面内だったら
              note.displayPlay();              //ノーツの表示
              if(pick == true && keep == false){  //押し始めだったら
                keep = true;                        //長押し状態に
                if(note.f_1 == fret1 && note.f_2 == fret2 && note.f_3 == fret3){  //フレット状態がすべてあっていたら
                  if(shift < 50){      //パーフェクト判定
                    score+=(score_perfect*(float)(10 + combo/50)/10);
                    note.eva = 1;
                    note.eva_count = 50;
                    note.is = false;
                    note.end = true;
                  }
                  else if(shift < 100){  //グレート判定
                    score+=(score_great*(float)(10 + combo/50)/10);
                    note.eva = 2;
                    note.eva_count = 50;
                    note.is = false;
                    note.end = true;
                  }
                  else if(shift < 150){  //グッド判定
                    score+=(score_good*(float)(10 + combo/50)/10);
                    note.eva = 3;
                    note.eva_count = 50;
                    note.is = false;
                    note.end = true;
                  }
                  combo++;
                  //break;
                }
              }
              else if(pick == true && keep == true){    //長押し中だったら
                if(note.time_finish > 0 && note.end == true && note.end_finish != true){  //長押しノーツだったら
                  if(shift_long > 200){                                                     //終わりが近くなかったら
                    if(note.f_1 != fret1 || note.f_2 != fret2 || note.f_3 != fret3){          //フレット状態がどれか間違っていたら
                      note.is_finish = false;  //ノーツを消す
                      note.end_finish = true;
                      combo = 0;
                    }
                  }
                }
              }
              else if(pick == false && keep == true){   //離したら
                keep = false;                             //長押し状態を解除
                if(note.time_finish > 0){                   //長押しノーツだったら
                  if(note.f_1 == fret1 && note.f_2 == fret2 && note.f_3 == fret3){  //フレット状態がすべてあっていたら
                    if(shift_long < 50){
                      score+=(score_perfect*(float)(10 + combo/50)/10);
                      note.eva = 1;
                      note.eva_count = 50;
                      note.eva_pos = note_line;
                      note.is_finish = false;
                      note.end_finish = true;
                    }
                    else if(shift_long < 100){
                      score+=(score_great*(float)(10 + combo/50)/10);
                      note.eva = 2;
                      note.eva_count = 50;
                      note.eva_pos = note_line;
                      note.is_finish = false;
                      note.end_finish = true;
                    }
                    else if(shift_long < 150){
                      score+=(score_good*(float)(10 + combo/50)/10);
                      note.eva = 3;
                      note.eva_count = 50;
                      note.eva_pos = note_line;
                      note.is_finish = false;
                      note.end_finish = true;
                    }
                    combo++;
                    //break;
                  }  
                }
              } 
            }
            if(note.eva_count > 0){    //判定テキストが表示状態だったら
              note.displayEva();
            }
          }
        }
        if(music.isPlaying() == false && pause_now == false){  //再生が終わっていたら
          fm.saveScore(playing_music.name, score);                     //プレイを記録
          fm.getRank(playing_music.name, score);                       //ランキングを取得
          mode = MODE.RESULT_PLAY;         //プレイ結果へ移行
          select = 0;                      //選択を初期化
          step = 0;                        //状態を初期化
          wait = 100;                     //待ち時間を設定
          view_rank = playing_music.play_count;
        }
        break;
        
      case RESULT_PLAY:            /*プレイ結果*/
        move = false;          //操作があったかどうかの変数
        switch(step){
          case 3:
            textSize(width/7);
            text(view_rank + " / " + playing_music.play_count, width*2/3, height*2/3);
            if(view_rank > rank) view_rank--;
          case 2:
            textSize(width/10);
            text("RANK:", width/4, height*2/3);
            if(step == 2 && wait == 0){
              step++;
            }
          case 1:  //得点表示
            textSize(width/9);
            text(score, width*2/3, height/3);
            if(step == 1 && wait == 0){
              step++;
              wait = 100;
            }
          case 0:
            textSize(width/10);
            text("SCORE:", width/4, height/3);
            if(step == 0 && wait == 0){
              step++;
              wait = 100;
            }
            break;
        }
        if(wait > 0) wait--;
        if(pick){
          step++;
          move = true;
          if(step > 3){
            mode = MODE.SELECT_PLAY;
            reset();
            delay(500);
          }
        }
        if (move) delay(300);  //操作があったら150msまつ(連続入力防止)
        break;
  
      case SELECT_RECORD:            /*レコード曲選択*/
        move = false;          //操作があったかどうかの変数
        if (fret1 && select > 0) {     //一番最初を選択していない状態で第一フレットが押されたら
          select--;                      //選択中のインデックスを一つ上に
          sound_select.play(0);           //効果音を再生
          move = true;                   //操作があった状態へ
        }
        else if (fret1 && select == 0) {     //一番最初を選択状態で第一フレットが押されたら
          select = List_music.size() - 1;    //選択中のインデックスを一番下に
          sound_select.play(0);           //効果音を再生
          move = true;                   //操作があった状態へ
        }
        if (fret3 && select < List_music.size() - 1) {  //一番最後を選択していない状態で第三フレットがおされたら
          select++;                      //選択中のインデックスを一つ下へ
          sound_select.play(0);           //効果音を再生
          move = true;                   //操作があった状態へ
        }
        else if (fret3 && select == 0) {  //一番最後を選択状態で第三フレットがおされたら
          select=0;                      //選択中のインデックスを一番上に
          sound_select.play(0);           //効果音を再生
          move = true;                   //操作があった状態へ
        }
        if (List_music.size() > 0) {     //曲のリストに一つ以上曲が入っていたら
          displaySelect();                 //選択画面を表示        

          if (pick) {                      //弦が押されたら
            sound_enter.play(0);              //効果音再生
            selectMusic();                   //曲選択
            sampler = new Sampler("music\\" + List_music.get(select).name + ".mp3", 4, minim);
            audio_output = minim.getLineOut();
            sampler.rate.setLastValue(0.5);
            sampler.patch(audio_output);
            move = true;                     //操作があった状態へ
          }
        }
        if (move)delay(300);  //操作があったら150msまつ(連続入力防止)
        break;
      
      case PAUSE_RECORD:              /*レコード中のPAUSE画面*/
        move = false;          //操作があったかどうかの変数
        if (fret1 && select > 0) {     //一番最初を選択していない状態で第一フレットが押されたら
          select--;                      //選択中のインデックスを一つ上に
          sound_select.play(0);          //効果音を再生
          move = true;                   //操作があった状態へ
        }
        if (fret3 && select < 3) {  //一番最後を選択していない状態で第三フレットがおされたら
          select++;                      //選択中のインデックスを一つ下へ
          sound_select.play(0);          //効果音を再生
          move = true;                   //操作があった状態へ
        }
      
        displaySelect();  //メニューを表示
      
        if (pick) {                      //弦が押されたら
          sound_enter.play(0);           //効果音を再生
          switch(select){  //選択項目を確認
            case 0:                       /*再開*/
              mode = MODE.RECORD;           //レコード中に戻す
              count = 180;                  //カウントダウン
              break;
            case 1:                       /*現時点まで記録*/
              save_pos = music.position();  //最後位置に記録
              save_combo = combo;
              save_score = score;
              mode = MODE.RECORD;           //レコード中に戻す
              fm.saveRecord(playing_music.name, List_play, combo);
              count = 180;                  //カウントダウン
              break;
            case 2:                       /*最後の記録からやり直し*/
              music.cue(save_pos - 1000);   //再生位置を最後の記録地点へ
              combo = save_combo;
              score = save_score;
              for(Note n : List_play){      //入力されたノーツを確認
                if(n.time <= save_pos){       //ノーツが最後の記録地点以前だったら
                  List_tmp.add(n);              //ノーツを退避
                }
              }
              List_play.clear();            //ノーツをクリア
              List_play = List_tmp;         //退避したノーツを格納
              List_tmp = new ArrayList<Note>();
              List_tmp.clear();             //ノーツをクリア
              mode = MODE.RECORD;           //レコード中に戻す
              count = 180;                  //カウントダウン
              break;
            case 3:                       /*曲選択へ戻る*/
              reset();                      //初期化
              mode = MODE.SELECT_RECORD;    //レコード曲選択へ戻る
              break;
          }
          move = true;                   //操作があった状態へ
        }
     
        if (move) delay(300);  //操作があったら150msまつ(連続入力防止)
        break;
      
      case RECORD:                    /*レコード中*/
        if(music.isPlaying() == false && pause_now){  //再生されていなかったら
          music.play();                               //再生する
          pause_now = false;
        }
        /*入力*/
        if(pause == true){          //PAUSEキーが押されたら
          music.pause();              //曲を一時停止
          select = 0;
          mode = MODE.PAUSE_RECORD;   //PAUSEモードに
          break;
        }
        if(pick == true && keep == false){  //押し始めだったら
          position = music.position();        //現在の再生位置を取得
          keep = true;                        //長押し状態に
          new_note = new Note();         //新しいノーツを用意
          if(fret1){                          //第一フレットが押されていたら
            new_note.f_1 = true;                //ノーツに記録
          }
          if(fret2){                          //第二フレットが押されていたら
            new_note.f_2 = true;               //ノーツに記録
          }
          if(fret3){                          //第三フレットが押されていたら
            new_note.f_3 = true;                //ノーツに記録
          }
          new_note.time = position;           //時間に再生位置を記録
          new_note.time_finish = 0;
          List_play.add(new_note);
          new_note.is = true;
          combo++;
          score+=(score_perfect*(float)(10 + combo/50)/10);
        }
        else if(pick == true && keep == true){    //長押し中だったら
          position = music.position();        //現在の再生位置を取得
          if(position - new_note.time > 300 && new_note.time_finish == 0){ //長押し一定時間したら
            new_note.time_finish = 300;                //長押しノーツに変更
          }
        }
        else if(pick == false && keep == true){   //離したら
          position = music.position();        //現在の再生位置を取得
          keep = false;                                     //長押し状態を解除
          if(position - new_note.time > 300){
            new_note.time_finish = position;
            new_note.is_finish = true;
            combo++;
            score+=(score_perfect*(float)(10 + combo/10)/10);
          }
        }
        
        /*表示*/
        for(Note note : List_play){
          if (note.is || note.is_finish || note.end_finish == false) {  //画面内だったら
            note.displayRecord();
            note.moveRecord();
          }
        }
        textSize(width/30);
        text("ノーツ数：" + combo, width*4/5, height/3);
        text("最高スコア：" + score, width*4/5, height/2);
        
      
        if(music.isPlaying() == false && pause_now == false){  //再生が終わっていたら
          mode = MODE.RESULT_RECORD;       //レコード結果へ移行
          select = 0;                      //選択を初期化
        }
        break;
        
      case RESULT_RECORD:          /*レコード結果*/
        move = false;                //操作があったかどうかの変数
        if (fret1 && select > 0) {     //一番最初を選択していない状態で第一フレットが押されたら
          select--;                      //選択中のインデックスを一つ上に
          sound_select.play(0);          //効果音を再生
          move = true;                   //操作があった状態へ
        }
        if (fret3 && select < 1) {  //一番最後を選択していない状態で第三フレットがおされたら
          select++;                      //選択中のインデックスを一つ下へ
          sound_select.play(0);          //効果音を再生
          move = true;                   //操作があった状態へ
        }
      
        displaySelect();  //メニューを表示
        
        if (pick) {                  //弦が押されたら
          sound_enter.play(0);         //効果音を再生
          switch(select){              //選択項目を確認
            case 0:                      //保存して戻る
              fm.saveRecord(playing_music.name, List_play, combo);                //レコードファイルを保存
              reset();                     //初期化
              mode = MODE.SELECT_RECORD;   //レコード曲選択へ戻る
              break;
            case 1:                      //保存せずに戻る
              reset();                     //初期化
              mode = MODE.SELECT_RECORD;   //レコード曲選択へ戻る
              break;
          }  
          move = true;                   //操作があった状態へ
        }
        if (move) delay(300);  //操作があったら150msまつ(連続入力防止)
        break;
    }
  }
  
}


/*初期化（曲選択へ戻る準備）*/
void reset()
{
  //変数の初期化など
  position = 0;
  select = 0;
  save_pos = 0;
  List_play.clear();
  List_music.clear();
  List_music = fm.loadMusic(mode);
  score = 0;
  combo = 0;
}

//void movieEvent( Movie m ) { 
  //カレント位置の画像を取得
//  m.read();
//}

void displaySelect()
{
  switch(mode){
    case SELECT_PLAY:
      /*選択中の曲のテキスト*/
      textSize(width/20);                    //選択中のテキストサイズを設定
      fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
      text(List_music.get(select).name, width/2, height*3/8);
      /*選択中の曲情報*/
      textSize(width/15);
      if(List_music.get(select).level >= 10) fill(color(255,45,150));
      else if(List_music.get(select).level >= 5) fill(color(255,191,127));
      else fill(color(153, 204, 255));
      text("★ " + List_music.get(select).level, width/2, height/5);
      fill(255);
      textSize(width/25);
      text("最高得点：" + List_music.get(select).max_score, width/4, height*4/7);
      text("ノーツ数：" + List_music.get(select).notes_count, width/4, height*5/7);
      text("プレイ数：" + List_music.get(select).play_count, width/4, height*6/7);
      text("1st:" + List_music.get(select).rank1_score, width*3/4, height*4/7);
      text("2nd:" + List_music.get(select).rank2_score, width*3/4, height*5/7);
      text("3rd:" + List_music.get(select).rank3_score, width*3/4, height*6/7);
      /*それ以外の曲のテキスト*/
      fill(200);                        //テキストの色を設定
      textSize(width/50);                     //テキストサイズを設定
      if (select - 1 >= 0) {            //選択中から一つ上の曲が存在したら表示
        text(List_music.get(select-1).name, width/4, height/5);
      }
      if (select + 1 < List_music.size()) { //選択中から一つ下の曲が存在したら表示
        text(List_music.get(select+1).name, width*3/4, height/5);
      }
      textSize(width/70);                     //テキストサイズを設定
      if (select - 2 >= 0) {            //選択中から二つ上の曲が存在したら表示
        text(List_music.get(select-2).name, width/5, height/10);
      }
      if (select + 2 < List_music.size()) { //選択中から二つ下の曲が存在したら表示
        text(List_music.get(select+2).name, width/5*4, height/10);
      }
      break;
      
    case SELECT_RECORD:
      textAlign(CENTER);               //テキストの基準点を中心に
      /*選択中の曲のテキスト*/
      textSize(width/30);                    //選択中のテキストサイズを設定
      fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
      text(List_music.get(select).name, width/2, height/2);
      /*それ以外の曲のテキスト*/
      textSize(width/60);                     //テキストサイズを設定
      fill(200);                        //テキストの色を設定
      if (select - 1 >= 0) {            //選択中から一つ上の曲が存在したら表示
        text(List_music.get(select-1).name, width/2, height/6*2);
      }
      if (select - 2 >= 0) {            //選択中から二つ上の曲が存在したら表示
        text(List_music.get(select-2).name, width/2, height/6);
      }
      if (select + 1 < List_music.size()) { //選択中から一つ下の曲が存在したら表示
        text(List_music.get(select+1).name, width/2, height/6*4);
      }
      if (select + 2 < List_music.size()) { //選択中から二つ下の曲が存在したら表示
        text(List_music.get(select+2).name, width/2, height/6*5);
      }
      break;
      
    case PAUSE_PLAY:
      break;
      
    case PAUSE_RECORD:
      textAlign(CENTER);               //テキストの基準点を中心に
      textSize(width/30);                     //テキストサイズを設定
      fill(200);                        //テキストの色を設定
      switch(select){                     //選択中の項目を確認
        case 0:
          textSize(width/25);                    //選択中のテキストサイズを設定
          fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
          text("再開", width/2, height/5);
          textSize(width/30);                     //テキストサイズを設定
          fill(200);                        //テキストの色を設定
          text("現時点まで記録", width/2, height/5*2);
          text("最後の記録からやり直し", width/2, height/5*3);
          text("曲選択へ戻る", width/2, height/5*4);
          break;
        case 1:
          text("再開", width/2, height/5);
          textSize(width/25);                    //選択中のテキストサイズを設定
          fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
          text("現時点まで記録", width/2, height/5*2);
          textSize(width/30);                     //テキストサイズを設定
          fill(200);                        //テキストの色を設定
          text("最後の記録からやり直し", width/2, height/5*3);
          text("曲選択へ戻る", width/2, height/5*4);
          break;
        case 2:
          text("再開", width/2, height/5);
          text("現時点まで記録", width/2, height/5*2);
          textSize(width/25);                    //選択中のテキストサイズを設定
          fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
          text("最後の記録からやり直し", width/2, height/5*3);
          textSize(width/30);                     //テキストサイズを設定
          fill(200);                        //テキストの色を設定
          text("曲選択へ戻る", width/2, height/5*4);
          break;
        case 3:
          text("再開", width/2, height/5);
          text("現時点まで記録", width/2, height/5*2);
          text("最後の記録からやり直し", width/2, height/5*3);
          textSize(width/25);                    //選択中のテキストサイズを設定
          fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
          text("曲選択へ戻る", width/2, height/5*4);
          textSize(width/30);                     //テキストサイズを設定
          fill(200);                        //テキストの色を設定
          break;
      }
      break;
    case RESULT_RECORD:
      textAlign(CENTER);               //テキストの基準点を中心に
      textSize(width/30);                     //テキストサイズを設定
      fill(200);                        //テキストの色を設定
      switch(select){                     //選択中の項目を確認
        case 0:
          textSize(width/25);                    //選択中のテキストサイズを設定
          fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
          text("保存して戻る", width/2, height/3);
          textSize(width/30);                     //テキストサイズを設定
          fill(200);                        //テキストの色を設定
          text("保存せずに戻る", width/2, height/3*2);
          break;
        case 1:
          text("保存して戻る", width/2, height/3);
          textSize(width/25);                    //選択中のテキストサイズを設定
          fill(color(255, 191, 127));       //選択中のテキストの色を設定、表示
          text("保存せずに戻る", width/2, height/3*2);
          textSize(width/30);                     //テキストサイズを設定
          fill(200);                        //テキストの色を設定
          break;
      }
      break;
  }
}

/*曲を選択・再生する関数*/
void selectMusic()
{
  switch(mode) {                                //モードを確認
    case SELECT_PLAY:                               /*プレイ曲選択状態*/
      mode = MODE.PLAY;                               //モードをプレイ中に
      playing_music = List_music.get(select);         //music_nameを設定
      minim = new Minim(this);                        //minimの初期化
      music = minim.loadFile("music\\" + playing_music.name + ".mp3");    //音楽ファイルを読み込む 
      music.rewind();                                 //再生位置を先頭へ戻す
      position = 0;                                   //現在位置の初期化
      count = 180;                                    //カウントダウン
      break;
    case SELECT_RECORD:                             /*レコード曲選択状態*/
      mode = MODE.RECORD;                             //モードをレコード中に
      playing_music = List_music.get(select); //music_nameを設定
      minim = new Minim(this);                        //minimの初期化
      music = minim.loadFile("music\\" + playing_music.name + ".mp3");    //音楽ファイルを読み込む 
      music.rewind();                                 //再生位置を先頭へ戻す
      position = 0;                                   //現在位置の初期化
      count = 180;                                    //カウントダウン
      break;
  }
}

/*画面サイズを変更する関数*/
void changeWindowSize(int w, int h) {
  frame.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
  settings();
}

/*ボタンを定義する関数*/
Button createButton(String name, String lab, float x, float y, int s_x, int s_y, color bg_c, color fg_c, color lab_c, color ac_c, int f_size)
{
  Button button = Button.addButton(name)  //ボタンを追加
    .setLabel(lab)                          //ボタン内のテキストを設定
    .setPosition(x, y)                      //位置を指定
    .setSize(s_x, s_y)                      //サイズを指定
    .setColorBackground(bg_c)               //通常状態の色を設定
    .setColorForeground(fg_c)               //マウスを乗せたときの色を設定
    .setColorCaptionLabel(lab_c)            //文字の色を設定
    .setColorActive(ac_c)                   //押したときの色を設定
    .setFont(createFont("font\\PixelMplus12-Bold.ttf", f_size));  //フォントを設定
  return button;
}

/*キーが押されたときの関数*/
void keyPressed()
{
  if (key == 'a') fret1 = true;  //aが押されていたら第一フレットをtrueに
  if (key == 's') fret2 = true;  //sが押されていたら第二フレットをtrueに
  if (key == 'd') fret3 = true;  //dが押されていたら第三フレットをtrueに
  if (key == ENTER) pick = true; //ENTERが押されていたら弦をtrueに
  if (key == ' ') pause = true;  //スペースが押されていたらPAUSEをtrueに
}
/*キーが離されたときの関数*/
void keyReleased()
{
  if (key == 'a') fret1 = false;  //aが離されたら第一フレットをfalseに
  if (key == 's') fret2 = false;  //sが離されたら第二フレットをfalseに
  if (key == 'd') fret3 = false;  //dが離されたら第三フレットをfalseに
  if (key == ENTER) pick = false; //ENTERが離されたら弦をfalseに
  if (key == ' ') pause = false;  //スペースが押されていたらPAUSEをtrueに
}

void showButtons()
{
  button_select_play.show();                                    //モード選択PLAYボタンを表示
  button_select_record.show();                                  //モード選択RECORDボタンを表示
}

void hideButtons()
{
  button_select_play.hide();                                    //モード選択PLAYボタンを隠す
  button_select_record.hide();                                  //モード選択RECORDボタンを隠す
}

/*モード選択PLAYボタンが押されたときの関数*/
void buttonPlay()
{
  sound_enter.play(0);           //効果音を再生
  mode = MODE.SELECT_PLAY;                                     //モードをスタイル選択に
  hideButtons();
  surface.setLocation(0, 0);                                    //画面の位置を左上に持っていく
  List_music = fm.loadMusic(mode);
  f1_x = width/4;
  f2_x = width/4*2;
  f3_x = width/4*3;
}
/*モード選択RECORDボタンが押されたときの関数*/
void buttonRecord()
{
  sound_enter.play(0);           //効果音を再生
  mode = MODE.SELECT_RECORD;                                    //モードをレコード曲選択に
  hideButtons();
  surface.setLocation(0, 0);                                    //画面の位置を左上に持っていく
  List_music = fm.loadMusic(mode);
  f1_x = width/6;
  f2_x = width/6*2;
  f3_x = width/6*3;
}
