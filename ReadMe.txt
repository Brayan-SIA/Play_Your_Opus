==========================================================
	Play_Your_Opus 
	ギターモチーフの音楽ゲーム
==========================================================

- 開発環境------------------------------------------------
	・Processing 3.5.3
	　-ライブラリ「Minim」
	　-ライブラリ「ControlP5」
	・Arduino 1.8.9

- 説明 ---------------------------------------------------

　①起動
	32bit - "application.windows32\Play_Your_Opus.exe"をダブルクリック
	62bit - "application.windows64\Play_Your_Opus.exe"をダブルクリック

　②曲追加
	32bit - "application.windows32\data\music"にmp3ファイルを追加
	64bit - "application.windows64\data\music"にmp3ファイルを追加

　②モード選択
	・PLAY｜RECORD選択　クリックで選択してください。

		＠PLAYモード　
		　作成した譜面を遊ぶ

		＠RECORDモード
		　曲に合わせてプレイし、譜面を作成

　③PLAY [A,S,Dキー Enter スペース]
	☆モード選択
		GAMEを選択してください。

	☆譜面選択
		作成した譜面からプレイするものを選ぶ。[A,Dで移動、Enterで選択]
		※先に譜面を作成する必要があります

	☆プレイ
		流れてくるノーツに対し、A,S,Dキーの位置が対応する物をホールドし
		重なるタイミングでEnterキーを入力する
		「赤」　　ー Aキー
		「ピンク」ー Sキー
		「紫」　　ー Dキー
		「グレー」ー ホールドなし
		※スペースキーでPAUSEが可能

	☆終了
		プレイの結果は記録され、難易度とランキングが変化します。
		終了したい場合はEscキーを入力
		
　④RECORD　[A,S,Dキー Enter　スペース]
	☆曲選択
		追加した曲の中から譜面作成するものを選ぶ。[A,Dで移動、Enterで選択]
		※data\musicにmp3ファイルを追加する必要があります。

	☆レコード
		ノーツは流れてこないので、プレイと同様に操作する。
		入力に応じて、ノーツが作成される。
		スペースキーでPAUSEが可能

	☆PAUSE中
		現時点までで途中保存が可能
		最後に保存した地点まで戻ることも可能
		※終了した場合は途中保存は削除されます。
		　最後までレコードしてください

	☆終了
		曲が終了したら、notes、rankファイルが作成され、
		譜面が完成します。完成した譜面はPLAYから遊べます。
		終了したい場合はEscキーを入力

　⑤譜面の共有
	共有したい場合は、その曲の以下3ファイルを共有してください。
	・○○.mp3　-　曲のデータ
	・notes\○○.csv　-　譜面情報
	・○○.rank -　プレイ履歴の情報
	受け取ったファイルはそれぞれmusic, notes, rankフォルダの中に入れてください
		
