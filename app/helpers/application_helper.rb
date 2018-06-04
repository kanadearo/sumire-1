require "uri"

module ApplicationHelper
  def avatar_url(user)
    if user.image
      "https://graph.facebook.com/#{user.uid}/picture?type=large"
    end
  end

  def mymap_counts(mymap)
    mymap.favoriters.count
  end

  def text_url_to_link(text)
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    return text
  end
end
