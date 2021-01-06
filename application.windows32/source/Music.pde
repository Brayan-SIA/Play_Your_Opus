class Music
{
  String name;
  int notes_count = 0;  //ノーツ数
  int max_score = 0;    //最高点
  int play_count = 0;   //プレイ回数
  int avg_score = 0;    //平均点  
  int level = 1;        //難易度1~10
  int rank1_score = 0;  //1位の得点
  int rank2_score = 0;  //2位の得点
  int rank3_score = 0;  //3位の得点
  
  void checkRank(int new_score){
    if(new_score > rank1_score){                 
      rank3_score = rank2_score;
      rank2_score = rank1_score;
      rank1_score = new_score;
    }
    else if(new_score < rank1_score && new_score > rank2_score){
      rank3_score = rank2_score;
      rank2_score = new_score;
    }
    else if(new_score < rank2_score && new_score > rank3_score){
      rank3_score = new_score;
    }
  }
}
