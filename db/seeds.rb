# No shared demo password is published. Register your own account in the UI.
owner = User.find_or_create_by!(email: "collection@example.com") do |u|
  u.password = SecureRandom.base64(36)
end
[
  ["Замок Паланок", "Закарпатська", "Мукачево", "Один із символів Закарпаття. Замок на пагорбі відкриває краєвиди Мукачева та знайомить відвідувачів з історією краю."],
  ["Ужгородський замок", "Закарпатська", "Ужгород", "Історична фортеця в центрі Ужгорода. Місце для знайомства з культурою Закарпаття та прогулянок старим містом."],
  ["Луцький замок", "Волинська", "Луцьк", "Замок Любарта — відома пам’ятка Луцька. Його вежі та подвір’я зберігають атмосферу давнього міста."]
].each do |name, region, location, description|
  owner.castles.find_or_create_by!(name: name) { |c| c.region = region; c.location = location; c.description = description }
end
