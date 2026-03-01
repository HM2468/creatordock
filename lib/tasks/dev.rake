# lib/tasks/dev.rake
#
# Usage:
#   rake dev:seed_contents[CREATOR_ID]
#
# Example:
#   bundle exec rake "dev:seed_contents[1]"
#
# Only runs in development or test environment.
#
# IMPORTANT:
# Do NOT raise/abort at file load time, because Rails loads all rake task files
# in production during build (e.g., assets:precompile). Instead, only define
# these tasks in dev/test.

if Rails.env.development? || Rails.env.test?
  require "faker"

  namespace :dev do
    desc "Seed 100 fake content records for a creator. Usage: rake dev:seed_contents[CREATOR_ID]"
    task :seed_contents, [:creator_id] => :environment do |_, args|
      creator_id = args[:creator_id]
      abort "Usage: rake dev:seed_contents[CREATOR_ID]" if creator_id.blank?

      creator = Creator.find_by(id: creator_id)
      abort "Creator with id=#{creator_id} not found" unless creator

      providers = Content.social_media_providers.keys
      provider_hosts = {
        "instagram" => "https://www.instagram.com/p",
        "tiktok"    => "https://www.tiktok.com/@user/video",
        "youtube"   => "https://www.youtube.com/watch?v"
      }

      records = 100.times.map do
        provider = providers.sample
        slug = Faker::Internet.slug

        {
          creator_id: creator.id,
          title: Faker::Lorem.sentence(word_count: 5).chomp("."),
          social_media_url: "#{provider_hosts[provider]}/#{slug}",
          social_media_provider: Content.social_media_providers[provider],
          created_at: Faker::Time.between(from: 6.months.ago, to: Time.current),
          updated_at: Time.current
        }
      end

      Content.insert_all!(records)
      Creator.reset_counters(creator.id, :contents)
      puts "Created 100 content records for creator '#{creator.name}' (id=#{creator.id})"
    end
  end
end