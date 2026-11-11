# 開催日を過ぎた回のカードを公式サイト（index.html）から外す。
#
#   ruby tools/remove-past-events.rb              # 今日の日付で実行
#   ruby tools/remove-past-events.rb 2026-11-17   # 日付を指定（試すとき）
#   ruby tools/remove-past-events.rb 2026-11-17 --root DIR   # 別の場所のコピーで試す
#
# 終了コード: 0 = 外した / 10 = 外すものがない / 20 = 安全のため何もしなかった
#
# - 開催日（schedule__date の日付）が今日より前のカードを、JSON-LDのEventとあわせて削除する
# - 申込みボタンの id="apply-button" は、残ったうち最初の申込みボタンに付け直す（1つだけ）
# - AGENTS.md の該当行の「LP掲載・申込みボタン設置済み」を「開催済み。日付にLPから外した」に書き換える
# - 全部のカードが過去になる場合は、開催予定が空になるので何もしない
# - git の操作（コミット・push）はしない
require "date"
require "json"

args = ARGV.dup
root = "."
if (i = args.index("--root"))
  root = args[i + 1]
  args.slice!(i, 2)
end
today = args[0] ? Date.parse(args[0]) : Date.today

html_path = File.join(root, "index.html")
agents_path = File.join(root, "AGENTS.md")
lines = File.readlines(html_path, encoding: "UTF-8")

sec = lines.index { |l| l.include?('id="schedule"') }
abort_with = lambda { |msg| puts "中止: #{msg}"; exit 20 }
abort_with.call("開催予定セクション（id=\"schedule\"）が見つからない") unless sec

# カードを集める
cards = []
i = sec
while i < lines.size
  if (m = lines[i].match(/\A(\s*)<div class="schedule__card[^"]*">\s*\z/))
    indent = m[1]
    j = (i + 1...lines.size).find { |k| lines[k] == "#{indent}</div>\n" }
    abort_with.call("カードの終わりが見つからない（#{i + 1}行目）") unless j
    block = lines[i..j].join
    dm = block.match(/schedule__date[^>]*>\s*(\d{4})年(\d{1,2})月(\d{1,2})日/)
    abort_with.call("カードの日付が読めない（#{i + 1}行目）") unless dm
    title = block[/<h3>([^<]+)<\/h3>/, 1]
    ids = block.scan(/doorkeeper\.jp\/events\/(\d+)/).flatten.uniq
    cards << { from: i, to: j, date: Date.new(dm[1].to_i, dm[2].to_i, dm[3].to_i), title: title, ids: ids }
    i = j + 1
  elsif lines[i].include?('class="schedule__map"')
    break
  else
    i += 1
  end
end
abort_with.call("カードが1枚もない") if cards.empty?

past = cards.select { |c| c[:date] < today }
puts "基準日: #{today}"
cards.each { |c| puts "  #{c[:date] < today ? '外す' : '残す'}  #{c[:title]}（#{c[:date]}）" }
if past.empty?
  puts "外すカードはありません。"
  exit 10
end
if past.size == cards.size
  abort_with.call("すべての回が開催済みです。外すと開催予定が空になるため、次の日程を掲載してから外してください")
end

# カードを削除（後ろから）
past.sort_by { |c| -c[:from] }.each { |c| lines.slice!(c[:from]..c[:to]) }
html = lines.join

# JSON-LD から過去のEventを削除
re = /(<script type="application\/ld\+json">\n)(.*?)(\n\s*<\/script>)/m
m = html.match(re)
abort_with.call("JSON-LDが見つからない") unless m
obj = JSON.parse(m[2])
before = obj["@graph"].size
obj["@graph"].reject! { |x| x["@type"] == "Event" && Date.parse(x["startDate"][0, 10]) < today }
removed_ld = before - obj["@graph"].size
pretty = JSON.pretty_generate(obj).lines.map { |l| "      " + l }.join.chomp
html = html.sub(re) { m[1] + pretty + m[3] }

# id="apply-button" を付け直す
html = html.gsub(' id="apply-button"', "")
html = html.sub('<a class="button button--primary js-apply-button"', '<a class="button button--primary js-apply-button" id="apply-button"')

# 確認
errs = []
errs << "<div と </div> の数が合わない" if html.scan(/<div[\s>]/).size != html.scan(/<\/div>/).size
past.flat_map { |c| c[:ids] }.each { |id| errs << "外した回のURL（events/#{id}）が残っている" if html.include?("events/#{id}") }
apply = html.scan(/<a[^>]*class="[^"]*js-apply-button[^"]*"/).size
ids = html.scan(/id="apply-button"/).size
errs << "id=\"apply-button\" が #{ids} 個ある" if (apply > 0 && ids != 1) || (apply == 0 && ids != 0)
begin
  JSON.parse(html.match(re)[2])
rescue JSON::ParserError => e
  errs << "JSON-LDが壊れた: #{e.message}"
end
abort_with.call("確認で問題が見つかったため書き込みません: " + errs.join(" / ")) unless errs.empty?

File.write(html_path, html)
puts "index.html: カード#{past.size}枚・JSON-LDのEvent#{removed_ld}件を外しました（申込みボタン#{apply}個、id=apply-buttonは1つ）"

# AGENTS.md を更新
if File.exist?(agents_path)
  ag = File.read(agents_path, encoding: "UTF-8")
  past.flat_map { |c| c[:ids] }.each do |id|
    ag = ag.lines.map { |l|
      l.include?("events/#{id}`") ? l.sub("LP掲載・申込みボタン設置済み", "開催済み。#{today}にLPから外した") : l
    }.join
  end
  File.write(agents_path, ag)
  puts "AGENTS.md: 該当回を開催済みに更新しました"
end
exit 0
