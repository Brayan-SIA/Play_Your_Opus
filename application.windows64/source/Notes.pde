class Note            /*ノーツのクラス*/
{
  boolean is = false;          //画面内かどうか
  boolean end = false;         //過ぎたかどうか
  boolean is_finish = false;   //長押しの画面内かどうか
  boolean end_finish = false;  //長押しの過ぎたかどうか
  int time;                    //押すタイミング
  int time_finish = 0;         //長押しの場合の終了位置 (0じゃなければ長押しノーツ)
  boolean f_1 = false;         //第一フレットの状態
  boolean f_2 = false;         //第二フレットの状態
  boolean f_3 = false;         //第三フレットの状態
  int pos=0;                   //画面上の位置
  int pos_finish = 0;          //長押しの画面の位置
  int eva = 0;                 //判定のテキスト
  float eva_pos = note_line;   //判定テキストの位置
  int eva_count = 0;           //判定テキストの存在時間
  
  /*プレイ中の移動と出現*/
  void movePlay()
  {
    /*出現*/
    shift = time - position;
    shift = (int)abs((float)shift);
    if(height-note_line >=  notes_speed*(shift/(1000/frameRate)) && end == false && is == false){
      is = true;
      pos = (int)(height - note_line - notes_speed*(shift/(1000/frameRate)));
    }
    /*移動*/
    if(is){              //画面内だったら
      pos+=notes_speed;    //ノーツを移動
      if(pos > height){    //画面最下を過ぎていたら(見逃し)
        is = false;          //通常ノーツを非表示に
        end = true;
        is_finish = false;   //長押しノーツも非表示
        end_finish = true;
        combo = 0;
        eva = 0;
        eva_count = 50;
      }
    }
    
    /*長押しノーツ*/
    if(time_finish > 0){  //長押しノーツだったら
      /*出現 長押し*/
      shift_long = time_finish - position;
      shift_long = (int)abs((float)shift_long);
      if(height-note_line >=  notes_speed*(shift_long/(1000/frameRate)) && end_finish == false && is_finish == false){
        is_finish = true;
        pos_finish = (int)(height - note_line - notes_speed*(shift_long/(1000/frameRate)));
      }
      /*移動　長押し*/
      if(is_finish){
        pos_finish+=notes_speed;
        if(pos_finish > height){
          is_finish = false;
          end_finish = true;
        }
      }
    }
    else{
      is_finish = false;
      end_finish = true;
      shift_long = 1000000;
    }
  }
  
  /*レコード中の移動*/
  void moveRecord()
  {
    if(is){
      pos+=notes_speed;
      if(pos > height){
        is = false;
      }
    }
    if(is_finish){
      pos_finish+=notes_speed;
      if(pos_finish > height){
        is_finish = false;
        end_finish = true;
      }
    }
  }
  
  /*ノーツの表示*/
  void displayPlay()
  {
    /*長押しノーツの長押し部分の表示*/
    if(time_finish > 0){
      tint(255,150);  //半透明に                
      if(end == true && end_finish != true){  //長押し中だったら
        if(f_1 || f_2 || f_3){
          if(f_1){
            image(image_long_note1, f1_x, pos_finish+(height-note_line-pos_finish)/2, width/5, height-note_line-pos_finish);
          }
          if(f_2){
            image(image_long_note2, f2_x, pos_finish+(height-note_line-pos_finish)/2, width/5, height-note_line-pos_finish);
          }
          if(f_3){
            image(image_long_note3, f3_x, pos_finish+(height-note_line-pos_finish)/2, width/5, height-note_line-pos_finish);
          }
        }
        else{
          image(image_long_note4, f2_x, pos_finish+(height-note_line-pos_finish)/2, width*4/5, height-note_line-pos_finish);
        }
      }
      else{  //流れてるだけの場合
        if(f_1 || f_2 || f_3){
          if(f_1){
            image(image_long_note1, f1_x, pos_finish+(pos-pos_finish)/2, width/5, pos-pos_finish);
          }
          if(f_2){
            image(image_long_note2, f2_x, pos_finish+(pos-pos_finish)/2, width/5, pos-pos_finish);
          }
          if(f_3){
            image(image_long_note3, f3_x, pos_finish+(pos-pos_finish)/2, width/5, pos-pos_finish);
          }
        }
        else{
          image(image_long_note4, f2_x, pos_finish+(pos-pos_finish)/2, width*4/5, pos-pos_finish);
        } 
      }
    }
    /*通常ノーツの表示*/
    tint(255,255);
    if(is){
      if(f_1 || f_2 || f_3){
        if(f_1){
          image(image_note1, f1_x, pos, width/5, height/100);
        }
        if(f_2){
          image(image_note2, f2_x, pos, width/5, height/100);
        }
        if(f_3){
          image(image_note3, f3_x, pos, width/5, height/100);
        }
      }
      else{
        image(image_note4, f2_x, pos, width*4/5, height/100);
      }
    }
    /*長押しノーツ終了部分の表示*/
    if(is_finish){
      if(f_1 || f_2 || f_3){
        if(f_1){
          image(image_note1, f1_x, pos_finish, width/5, height/100);
        }
        if(f_2){
          image(image_note2, f2_x, pos_finish, width/5, height/100);
        }
        if(f_3){
          image(image_note3, f3_x, pos_finish, width/5, height/100);
        }
      }
      else{
        image(image_note4, f2_x, pos_finish, width*4/5, height/100);
      } 
    }
  }
 
  
  /*評価テキストの表示*/
  void displayEva()
  {
    int effect_size = (50-eva_count)*width/200;
    /*判定テキストの表示*/
    switch(eva){
      case 0:
        if(eva_count > 25) fill(150,(50-eva_count)*5);  //だんだん濃くする
        else fill(150, eva_count * 10);  //だんだん薄くする
        textSize(width/45);
        if(f_1) text("MISS", f1_x, height-eva_pos);
        if(f_2) text("MISS", f2_x, height-eva_pos);
        if(f_3) text("MISS", f3_x, height-eva_pos);
        if(!f_1 && !f_2 && !f_3) text("MISS", f2_x, height-eva_pos);
        break;
      case 1:
        if(eva_count > 25) fill(color(255,45,150),(50-eva_count)*5);  //だんだん濃くする
        else fill(color(255,45,150), eva_count * 10);  //だんだん薄くする
        textSize(width/35);
        if(f_1){
          text("PERFECT!!", f1_x, height-eva_pos);
          image(image_perfect, f1_x, height - note_line, effect_size, effect_size);
        }
        if(f_2) {
          text("PERFECT!!", f2_x, height-eva_pos);
          image(image_perfect, f2_x, height - note_line, effect_size, effect_size);
        }
        if(f_3){
          text("PERFECT!!", f3_x, height-eva_pos);
          image(image_perfect, f3_x, height - note_line, effect_size, effect_size);
        }
        if(!f_1 && !f_2 && !f_3){
          text("PERFECT!!", f2_x, height-eva_pos);
          image(image_perfect, f2_x, height - note_line, effect_size*2, effect_size*2);
        }
        break;
      case 2:
        if(eva_count > 25) fill(color(255,191,127),(50-eva_count)*5);  //だんだん濃くする
        else fill(color(255,191,127), eva_count * 10);  //だんだん薄くする
        textSize(width/40);
        if(f_1){
          text("GREAT!", f1_x, height-eva_pos);
          image(image_great, f1_x, height - note_line, effect_size, effect_size);
        }
        if(f_2) {
          text("GREAT!", f2_x, height-eva_pos);
          image(image_great, f2_x, height - note_line, effect_size, effect_size);
        }
        if(f_3){
          text("GREAT!", f3_x, height-eva_pos);
          image(image_great, f3_x, height - note_line, effect_size, effect_size);
        }
        if(!f_1 && !f_2 && !f_3){
          text("GREAT!", f2_x, height-eva_pos);
          image(image_great, f2_x, height - note_line, effect_size*2, effect_size*2);
        }
        break;
      case 3:
        if(eva_count > 25) fill(255,(50-eva_count)*5);  //だんだん濃くする
        else fill(255, eva_count * 10);  //だんだん薄くする
        textSize(width/40);
        if(f_1){
          text("GOOD", f1_x, height-eva_pos);
          image(image_good, f1_x, height - note_line, effect_size, effect_size);
        }
        if(f_2) {
          text("GOOD", f2_x, height-eva_pos);
          image(image_good, f2_x, height - note_line, effect_size, effect_size);
        }
        if(f_3){
          text("GOOD", f3_x, height-eva_pos);
          image(image_good, f3_x, height - note_line, effect_size, effect_size);
        }
        if(!f_1 && !f_2 && !f_3){
          text("GOOD", f2_x, height-eva_pos);
          image(image_good, f2_x, height - note_line, effect_size*2, effect_size*2);
        }
        break;   
    }
    eva_pos+=width/400;
    fill(255,255);
    eva_count--;
  }
  
  
  /*ノーツの表示*/
  void displayRecord()
  {
    
    /*長押しノーツの長押し部分の表示*/
    if(time_finish > 0){
      tint(255,150);
      if(f_1 || f_2 || f_3){
        if(f_1){
          image(image_long_note1, f1_x, pos_finish+(pos-pos_finish)/2, width/7, pos-pos_finish);
        }
        if(f_2){
          image(image_long_note2, f2_x, pos_finish+(pos-pos_finish)/2, width/7, pos-pos_finish);
        }
        if(f_3){
          image(image_long_note3, f3_x, pos_finish+(pos-pos_finish)/2, width/7, pos-pos_finish);
        }
      }
      else{
        image(image_long_note4, f2_x, pos_finish+(pos-pos_finish)/2, width*4/7, pos-pos_finish);
      } 
      tint(255,150);
    }
    /*通常ノーツの表示*/
    if(is){
      if(f_1 || f_2 || f_3){
        if(f_1){
          image(image_note1, f1_x, pos, width/7, height/100);
        }
        if(f_2){
          image(image_note2, f2_x, pos, width/7, height/100);
        }
        if(f_3){
          image(image_note3, f3_x, pos, width/7, height/100);
        }
      }
      else{
        image(image_note4, f2_x, pos, width*4/7, height/100);
      }
    }
    /*長押しノーツ終了部分の表示*/
    if(is_finish){
      if(f_1 || f_2 || f_3){
        if(f_1){
          image(image_note1, f1_x, pos_finish, width/7, height/100);
        }
        if(f_2){
          image(image_note2, f2_x, pos_finish, width/7, height/100);
        }
        if(f_3){
          image(image_note3, f3_x, pos_finish, width/7, height/100);
        }
      }
      else{
        image(image_note4, f2_x, pos_finish, width*4/7, height/100);
      } 
    }
  }
}
