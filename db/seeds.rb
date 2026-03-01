creators_data = [
  { name: "Aria Chen",    email: "aria@example.com" },
  { name: "Marcus Reid",  email: "marcus@example.com" },
  { name: "Sofia Ruiz",   email: "sofia@example.com" },
  { name: "Devon Park",   email: "devon@example.com" },
  { name: "Lena Hobart",  email: "lena@example.com" }
]

creators = creators_data.map do |attrs|
  Creator.find_or_create_by!(email: attrs[:email]) { |c| c.name = attrs[:name] }
end

contents_data = [
  { creator: creators[0], title: "Morning skincare routine",   url: "https://www.instagram.com/p/abc123", provider: :instagram },
  { creator: creators[0], title: "GRWM for a date night",      url: "https://www.tiktok.com/@aria/video/1", provider: :tiktok },
  { creator: creators[0], title: "Full glam tutorial",         url: "https://www.youtube.com/watch?v=aaa111", provider: :youtube },
  { creator: creators[0], title: "5-minute makeup",            url: "https://www.instagram.com/p/def456", provider: :instagram },

  { creator: creators[1], title: "Gym workout of the day",     url: "https://www.instagram.com/p/ghi789", provider: :instagram },
  { creator: creators[1], title: "30-day fitness challenge",   url: "https://www.youtube.com/watch?v=bbb222", provider: :youtube },
  { creator: creators[1], title: "Protein meal prep",          url: "https://www.tiktok.com/@marcus/video/2", provider: :tiktok },
  { creator: creators[1], title: "Home leg day",               url: "https://www.instagram.com/p/jkl012", provider: :instagram },
  { creator: creators[1], title: "Upper body blast",           url: "https://www.youtube.com/watch?v=ccc333", provider: :youtube },

  { creator: creators[2], title: "Street style lookbook",      url: "https://www.instagram.com/p/mno345", provider: :instagram },
  { creator: creators[2], title: "Thrift haul transformation", url: "https://www.tiktok.com/@sofia/video/3", provider: :tiktok },
  { creator: creators[2], title: "Summer outfit ideas",        url: "https://www.youtube.com/watch?v=ddd444", provider: :youtube },
  { creator: creators[2], title: "Capsule wardrobe guide",     url: "https://www.tiktok.com/@sofia/video/4", provider: :tiktok },

  { creator: creators[3], title: "Travel vlog: Tokyo day 1",   url: "https://www.youtube.com/watch?v=eee555", provider: :youtube },
  { creator: creators[3], title: "Hidden cafes in Seoul",      url: "https://www.instagram.com/p/pqr678", provider: :instagram },
  { creator: creators[3], title: "Budget travel tips",         url: "https://www.tiktok.com/@devon/video/5", provider: :tiktok },
  { creator: creators[3], title: "Packing light for Europe",   url: "https://www.youtube.com/watch?v=fff666", provider: :youtube },

  { creator: creators[4], title: "Healthy lunch ideas",        url: "https://www.instagram.com/p/stu901", provider: :instagram },
  { creator: creators[4], title: "Avocado toast variations",   url: "https://www.tiktok.com/@lena/video/6", provider: :tiktok },
  { creator: creators[4], title: "Meal prep for the week",     url: "https://www.youtube.com/watch?v=ggg777", provider: :youtube },
  { creator: creators[4], title: "5 high-protein breakfasts",  url: "https://www.instagram.com/p/vwx234", provider: :instagram },
]

contents_data.each do |attrs|
  Content.find_or_create_by!(social_media_url: attrs[:url]) do |c|
    c.creator = attrs[:creator]
    c.title = attrs[:title]
    c.social_media_provider = attrs[:provider]
  end
end

puts "Seeded #{Creator.count} creators and #{Content.count} content records."
