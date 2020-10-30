# 筋トレカレンダー
## ・概要

<div align="left">
<img src="https://user-images.githubusercontent.com/71870271/97676685-56685880-1ad4-11eb-8df7-514adf87cda1.png" width="200px">  
  
<img src="https://user-images.githubusercontent.com/71870271/97676750-6ed87300-1ad4-11eb-951f-a67059493202.png" width="200px">  

<img src="https://user-images.githubusercontent.com/71870271/97680098-80704980-1ad9-11eb-84f4-a3d658e1a756.png" width="200px">  
</div>

#### 日々の筋トレをカレンダーで月ごとに確認できるiOSアプリケーション
##### 下記AppStoreのリンク「筋トレカレンダー」
https://apps.apple.com/jp/app/%E7%AD%8B%E3%83%88%E3%83%AC%E3%82%AB%E3%83%AC%E3%83%B3%E3%83%80%E3%83%BC/id1537543591
## ・アプリケーションの機能、技術一覧

#### ・カレンダーを表示する機能
・cocoapodsでFSCalendarを使用

#### ・カレンダーに日本の休日を反映させる機能
・cocoapodsでCalculateCalendarLogicを使い、日本の休日判定を行う

#### ・ボタンタップで日付の下にトレーニングの画像を表示する機能
・1日のトレーニングの上限を３つに決め、そこから７つのトレーニングを選択するので全６３通りのトレーニングの組み合わせがあり、それらの組み合わせの画像をAssetsに入れておき、その日付で保存されているデータの値で条件分岐させ、対応する画像を返す。

#### ・それぞれの日付のメニューを確認できる機能
・部位ごとの細かいメニューは、テーブルビューで確認できるようになっている。
・日付をタップすることで、それぞれのメニュー内容が確認できる。

#### ・月のトレーニングの割合を確認できる機能
・cocoapodsでChartsを使用し、月ごとのトレーニングをグラフで表示している。
・７つの部位からなる円グラフになっている。

#### ・それぞれの画面遷移機能
・メインである、ホーム画面とメニュー確認画面は、切り替えの頻度が高いと考えTabBarで切り替えをし、グラフ画面とカレンダー名変更画面の２種類はボタンでの画面遷移にしている。
・トレーニングの詳細を選択する画面は、部位のボタンをタップするとmodalで遷移する。

#### ・日別にトレーニングを保存するDB機能
・DBはuserdefaultsを使用している。
・データの型がString型が多く、以前に開発していたアプリの名残もあったので使用した。


#### ・全端末に合うレイアウト機能
・配置は全てコードレイアウトでレイアウトした。
・しかし、こんがらがってしまう事があったので、Storyboardで簡単に配置をしている。
・開発上コードレイアウトとStoryboardが混ざる事はよくない気がするので、改善していきたい。




