public class FileManager
{

  /*スコアの書き込み*/
  public void saveScore(String name, int score)
  {
    try {
      File score_file = new File(dataPath("rank") + "\\" + name + ".rank");
      if (score_file.exists() && score_file.isFile() && score_file.canWrite()) {
        FileWriter file_writer = new FileWriter(score_file, true);

        file_writer.write(score+"\n");
        playing_music.play_count++;

        file_writer.close();
      }
    }
    catch(IOException e) {
      System.out.println(e);
    }
  }

  /*ランキングの取得*/
  public void getRank(String name, int score) 
  {
    rank = 1;
    String read_file[] = loadStrings("rank\\" + name + ".rank");    //ファイルを読み込む
    for (int j = 1; j < read_file.length; j++) {      //各行を参照
      int data = Integer.parseInt(read_file[j]);
      if (data > score) rank++;                        //スコアが今回より高かったら順位を下げる
    }
  }

  /*レコードファイルの読み込み*/
  public ArrayList<Note> loadRecord(String name)
  {
    String read_file[] = loadStrings("notes\\" +  name +".csv");    //CSVファイルを読み込む

    ArrayList<Note> List_Notes = new ArrayList<Note>();

    for (int i = 0; i < read_file.length; i++) {      //各行を参照
      String [] columm = split(read_file[i], ',');    //カンマ区切りで配列に格納

      new_note = new Note();                              //新しいノーツを用意

      /*各要素の読み込み*/
      new_note.time = Integer.parseInt(columm[0]);
      new_note.time_finish = Integer.parseInt(columm[1]);
      if (Integer.parseInt(columm[2]) == 1) new_note.f_1 = true;
      else new_note.f_1 = false;
      if (Integer.parseInt(columm[3]) == 1) new_note.f_2 = true;
      else new_note.f_2 = false;
      if (Integer.parseInt(columm[4]) == 1) new_note.f_3 = true;
      else new_note.f_3 = false;

      List_Notes.add(new_note);
    }
    
    return List_Notes;
  }

  /*レコードファイルの出力*/
  public void saveRecord(String name, ArrayList<Note> List_Notes, int combo)
  {
    record_file = createWriter("data\\notes\\" + name + ".csv");

    for (Note n : List_Notes) {
      record_file.print(n.time);
      record_file.print(",");
      record_file.print(n.time_finish);
      record_file.print(",");

      if (n.f_1) {
        record_file.print(1);
      } else {
        record_file.print(0);
      }
      record_file.print(",");

      if (n.f_2) {
        record_file.print(1);
      } else {
        record_file.print(0);
      }
      record_file.print(",");

      if (n.f_3) {
        record_file.println(1);
      } else {
        record_file.println(0);
      }
    }

    record_file.flush();
    record_file.close();

    rank_file = createWriter("data\\rank\\" + name + ".rank");
    rank_file.println(combo);
    //rank_file.println(score);
    rank_file.flush();
    rank_file.close();
  }

  /*フォルダ内の曲を読み込む関数*/
  public ArrayList<Music> loadMusic(MODE mode)
  {
    File dir;
    File[] files;
    ArrayList<Music> List_music = new ArrayList<Music>();
    switch(mode) {
      case SELECT_PLAY:
        dir = new File(dataPath("rank"));
        files = dir.listFiles();        //フォルダ内のファイルを配列に入れる
        if (files.length == 0) {
          mode = MODE.SELECT_MODE;
          showButtons();
          break;
        }
        for (int i = 0; i < files.length; i++) {     //ファイル数分ループする
          if (files[i].getPath().endsWith(".rank")) {    //.rankでおわるファイルだったら
            Music music = new Music();
            music.name = files[i].getName().substring(0, files[i].getName().lastIndexOf('.'));
            String read_file[] = loadStrings(dataPath("rank") + "\\" + music.name + ".rank");    //ファイルを読み込む
            music.notes_count = Integer.parseInt(read_file[0]);        //ノーツ数を読み込む
            long sum_score = 0;                                //合計得点（平均計算用）
            for (int j = 1; j < read_file.length; j++) {      //各行を参照
              int data = Integer.parseInt(read_file[j]);
              sum_score+=data;                              //得点を加算
              music.play_count++;                           //プレイ回数をカウント
              music.checkRank(data);                        //ランキングを更新
            }
            int combo = 0;
            music.max_score = 0;
            for (int j = 0; j < music.notes_count; j++) {
              combo++;
              music.max_score+=(score_perfect*(float)(10 + combo/50)/10);
            }
            if (music.play_count > 0) {
              music.avg_score = (int)sum_score / music.play_count;  //平均点を求める
              if (music.avg_score > music.max_score*9/10) music.level = 1;
              else if (music.avg_score < music.max_score/2)music.level = 10 - (int)(((float)(music.avg_score-music.max_score/2) / (float)(music.max_score))*10);
              else music.level = 10 - (int)(((float)(music.avg_score) / (float)(music.max_score))*10);
            }
            List_music.add(music);                    //曲リストに加える
          }
        }
        break;
      case SELECT_RECORD:
        dir = new File(dataPath("music"));
        files = dir.listFiles();        //フォルダ内のファイルを配列に入れる
        if (files.length == 0) {
          mode = MODE.SELECT_MODE;
          showButtons();
          break;
        }
        for (int i = 0; i < files.length; i++) {     //ファイル数分ループする
          if (files[i].getPath().endsWith(".mp3")) {    //.mp3でおわるファイルだったら
            Music music = new Music();
            music.name = files[i].getName().substring(0, files[i].getName().lastIndexOf('.'));
            List_music.add(music);                    //曲リストに加える
          }
        }
        break;
    }
    return List_music;
  }
}
