module ApplicationHelper
  PROVIDER_BADGE_CLASSES = {
    "instagram" => "bg-pink-100 text-pink-700",
    "tiktok"    => "bg-gray-100 text-gray-700",
    "youtube"   => "bg-red-100 text-red-700"
  }.freeze

  def provider_badge_class(provider)
    PROVIDER_BADGE_CLASSES[provider.to_s] || "bg-gray-100 text-gray-700"
  end

  def svg_icon(name, class_name: "")
    path = Rails.root.join("app/assets/images/icons/#{name}.svg")
    return "" unless File.exist?(path)

    svg = File.read(path)
    svg.sub("<svg", %(<svg class="#{ERB::Util.html_escape(class_name)}")).html_safe
  end
end
