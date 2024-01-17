require "my_gem/version"

module MyGem
  class Error < StandardError; end
  # Your code goes here...
  require 'set'

  def read_file(file_path)
    File.read(file_path)
  end

  def classify_genre(file_content, genre_keywords)
    genre_scores = Hash.new(0)

    genre_keywords.each do |genre, keywords|
      keywords.each do |keyword|
        genre_scores[genre] += 1 if file_content.include?(keyword)
      end
    end

    genre_scores.max_by { |_, score| score }&.first || "未分類"
  end

  def group_files_by_genre(directory, genre_keywords)
    grouped_files = Hash.new { |hash, key| hash[key] = [] }

    Dir.glob("#{directory}/*.txt").each do |file_path|
      content = read_file(file_path)
      genre = classify_genre(content, genre_keywords)
      grouped_files[genre] << file_path
    end

    grouped_files
  end

  # コマンドライン引数からディレクトリパスを取得
  directory = ARGV[0]
  unless directory && Dir.exist?(directory)
    puts "ディレクトリが存在しないか、指定されていません。"
    exit
  end

  # ジャンルとキーワードのマッピング
  genre_keywords = {
  "ホラー" => ["ホラー", "恐怖", "怖い"],
  "ディズニー" => ["ディズニー", "ミッキー", "ミニー", "プリンセス"],
    # 他のジャンルとキーワードを追加可能
  }

  grouped_files = group_files_by_genre(directory, genre_keywords)

  # 結果の出力
  grouped_files.each do |genre, files|
    puts "#{genre} ジャンル:"
    files.each { |file| puts " - #{file}" }
    puts "\n"

end
