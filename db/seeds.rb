# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.find_or_create_by!(email: 'admin@recipe.com') do |admin|
  admin.password = 'admin_pass'
end

User.find_or_create_by!(email: "user1@sample") do |user|
  user.name = "パンダ"
  user.password = "user1_pass"
end

User.find_or_create_by!(email: "user2@sample") do |user|
  user.name = "ライオン"
  user.password = "user2_pass"
end

User.find_or_create_by!(email: "user3@sample") do |user|
  user.name = "キリン"
  user.password = "user3_pass"
end

User.find_or_create_by!(email: "user4@sample") do |user|
  user.name = "カピバラ"
  user.password = "user4_pass"
end

User.find_or_create_by!(email: "user5@sample") do |user|
  user.name = "タスマニアデビル"
  user.password = "user5_pass"
end

User.find_or_create_by!(email: "user6@sample") do |user|
  user.name = "シマウマ"
  user.password = "user6_pass"
end

User.find_or_create_by!(email: "user7@sample") do |user|
  user.name = "カバ"
  user.password = "user7_pass"
end

User.find_or_create_by!(email: "user8@sample") do |user|
  user.name = "ウサギ"
  user.password = "user8_pass"
end

User.find_or_create_by!(email: "user9@sample") do |user|
  user.name = "ネコ"
  user.password = "user9_pass"
end

User.find_or_create_by!(email: "user10@sample") do |user|
  user.name = "プレーリードッグ"
  user.password = "user10_pass"
end

User.find_or_create_by!(email: "user11@sample") do |user|
  user.name = "スローロリス"
  user.password = "user11_pass"
end

User.find_or_create_by!(email: "user12@sample") do |user|
  user.name = "トラ"
  user.password = "user12_pass"
end

User.find_or_create_by!(email: "user13@sample") do |user|
  user.name = "コンドル"
  user.password = "user13_pass"
end

User.find_or_create_by!(email: "user14@sample") do |user|
  user.name = "ヒツジ"
  user.password = "user14_pass"
end

User.find_or_create_by!(email: "user15@sample") do |user|
  user.name = "オオカミ"
  user.password = "user15_pass"
end

Recipe.find_or_create_by!(title: "カレーライス") do |recipe|
  recipe.user_id = 1
  recipe.genre_id = 4
  recipe.catch_copy = "定番のカレー"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/カレー.jpg"), filename:"カレー.jpg")
end

Recipe.find_or_create_by!(title: "肉じゃが") do |recipe|
  recipe.user_id = 1
  recipe.genre_id = 1
  recipe.catch_copy = "ジャガイモのほくほく感が自慢の一品"
  recipe.difficulty = "4"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/肉じゃが.jpg"), filename:"肉じゃが.jpg")
end

Recipe.find_or_create_by!(title: "オムライス") do |recipe|
  recipe.user_id = 1
  recipe.genre_id = 2
  recipe.catch_copy = "卵とチキンライスの最強コンボ、\r\n子供も大喜びです"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/オムライス.jpg"), filename:"オムライス.jpg")
end

Recipe.find_or_create_by!(title: "極厚パンケーキ") do |recipe|
  recipe.user_id = 1
  recipe.genre_id = 2
  recipe.catch_copy = "食べ応え十分！中はふわふわです"
  recipe.difficulty = "2"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/パンケーキ.jpg"), filename:"パンケーキ.jpg")
end

Recipe.find_or_create_by!(title: "金目鯛の煮つけ") do |recipe|
  recipe.user_id = 4
  recipe.genre_id = 1
  recipe.catch_copy = "ご家庭で老舗の味を再現"
  recipe.difficulty = "5"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/金目鯛.jpg"), filename:"金目鯛.jpg")
end

Recipe.find_or_create_by!(title: "鶏のから揚げ") do |recipe|
  recipe.user_id = 4
  recipe.genre_id = 1
  recipe.catch_copy = "お弁当のおかずの定番"
  recipe.difficulty = "2"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/唐揚げ.jpg"), filename:"唐揚げ.jpg")
end

Recipe.find_or_create_by!(title: "四川風麻婆豆腐") do |recipe|
  recipe.user_id = 4
  recipe.genre_id = 3
  recipe.catch_copy = "八角などのスパイスが効いた本格レシピ"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/麻婆豆腐.jpg"), filename:"麻婆豆腐.jpg")
end

Recipe.find_or_create_by!(title: "簡単！パラパラ炒飯") do |recipe|
  recipe.user_id = 4
  recipe.genre_id = 3
  recipe.catch_copy = "10分でできる簡単レシピ"
  recipe.difficulty = "1"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/チャーハン.jpg"), filename:"チャーハン.jpg")
end

Recipe.find_or_create_by!(title: "本格！四川風エビチリ") do |recipe|
  recipe.user_id = 1
  recipe.genre_id = 3
  recipe.catch_copy = "本場、四川風の味付けです"
  recipe.difficulty = "4"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/エビチリ.jpg"), filename:"エビチリ.jpg")
end

Recipe.find_or_create_by!(title: "カレーライス") do |recipe|
  recipe.user_id = 1
  recipe.genre_id = 1
  recipe.catch_copy = "花のような見た目のおしゃれなだし巻き"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/だし巻き卵.jpg"), filename:"だし巻き卵.jpg")
end

Recipe.find_or_create_by!(title: "濃厚！カルボナーラ") do |recipe|
  recipe.user_id = 3
  recipe.genre_id = 2
  recipe.catch_copy = "卵黄の濃厚なソースが決め手"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/カルボナーラ.jpg"), filename:"カルボナーラ.jpg")
end

Recipe.find_or_create_by!(title: "チーズとトマトのパスタ") do |recipe|
  recipe.user_id = 3
  recipe.genre_id = 2
  recipe.catch_copy = "チーズとトマトが絶妙にマッチ！"
  recipe.difficulty = "2"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/チーズトマトパスタ.jpg"), filename:"チーズトマトパスタ.jpg")
end

Recipe.find_or_create_by!(title: "ナポリタン") do |recipe|
  recipe.user_id = 3
  recipe.genre_id = 2
  recipe.catch_copy = "子供に大人気の定番スパゲッティ"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/ナポリタン.jpg"), filename:"ナポリタン.jpg")
end

Recipe.find_or_create_by!(title: "ジューシーハンバーグ") do |recipe|
  recipe.user_id = 5
  recipe.genre_id = 2
  recipe.catch_copy = "みんな大好きハンバーグ"
  recipe.difficulty = "4"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/ハンバーグ.jpg"), filename:"ハンバーグ.jpg")
end

Recipe.find_or_create_by!(title: "簡単ペペロンチーノ") do |recipe|
  recipe.user_id = 5
  recipe.genre_id = 2
  recipe.catch_copy = "ニンニクとオリーブオイルの絶妙なハーモニー"
  recipe.difficulty = "2"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/ペペロンチーノ.jpg"), filename:"ペペロンチーノ.jpg")
end

Recipe.find_or_create_by!(title: "極上ミートソース") do |recipe|
  recipe.user_id = 6
  recipe.genre_id = 2
  recipe.catch_copy = "肉と野菜の旨みが豊かなミートソースです"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/ミートソース.jpg"), filename:"ミートソース.jpg")
end

Recipe.find_or_create_by!(title: "ローストチキン") do |recipe|
  recipe.user_id = 4
  recipe.genre_id = 2
  recipe.catch_copy = "特別な日におススメの一品"
  recipe.difficulty = "4"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/ローストチキン.jpg"), filename:"ローストチキン.jpg")
end

Recipe.find_or_create_by!(title: "伊勢海老のパスタ") do |recipe|
  recipe.user_id = 5
  recipe.genre_id = 2
  recipe.catch_copy = "伊勢海老のがソースに豊かな風味とコクを与えます"
  recipe.difficulty = "5"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/伊勢海老パスタ.jpg"), filename:"伊勢海老パスタ.jpg")
end

Recipe.find_or_create_by!(title: "肉汁あふれる小籠包") do |recipe|
  recipe.user_id = 6
  recipe.genre_id = 3
  recipe.catch_copy = "滴る肉汁がたまらない逸品です"
  recipe.difficulty = "2"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/小籠包.jpg"), filename:"小籠包.jpg")
end

Recipe.find_or_create_by!(title: "ハムチーズサンド") do |recipe|
  recipe.user_id = 3
  recipe.genre_id = 2
  recipe.catch_copy = "軽食の定番サンドウィッチ"
  recipe.difficulty = "1"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/ハムチーズサンド.jpg"), filename:"ハムチーズサンド.jpg")
end

Recipe.find_or_create_by!(title: "カツサンド") do |recipe|
  recipe.user_id = 3
  recipe.genre_id = 2
  recipe.catch_copy = "ボリューム満点のカツサンド"
  recipe.difficulty = "3"
  recipe.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/カツサンド.jpg"), filename:"カツサンド.jpg")
end

RecipeMaterial.find_or_create_by!(name: "じゃがいも") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "4個"
end

RecipeMaterial.find_or_create_by!(name: "ニンジン") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "2本"
end

RecipeMaterial.find_or_create_by!(name: "玉ねぎ") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "2個"
end

RecipeMaterial.find_or_create_by!(name: "牛肉") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "200g"
end

RecipeMaterial.find_or_create_by!(name: "絹さや") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "適量"
end

RecipeMaterial.find_or_create_by!(name: "顆粒だし") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "1袋"
end

RecipeMaterial.find_or_create_by!(name: "醤油") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "大さじ3"
end

RecipeMaterial.find_or_create_by!(name: "みりん") do |recipe_material|
  recipe_material.recipe_id = 2
  recipe_material.quantity = "少々"
end