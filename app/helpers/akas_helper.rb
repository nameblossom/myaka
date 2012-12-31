module AkasHelper

  def default_profile
    profile = <<END
<!DOCTYPE HTML>
<html>
<head>
<!-- the displayname variable stores your friendly name -->
<title>{{ displayname }}</title>
<style>
  body { font-family: sans-serif; }
  .big { font-size: 1.2em; }
</style>
<!-- certain important <link> and <meta> tags are available in the headertags variable.
     be sure to use the triple-brace form since you don't want the tags to be escaped. -->
{{{ headertags }}}
</head>
<body>
<p style='margin-top: 10em; text-align: center'>
  This <a href='http://nameblossom.org/akas/'>aka</a> belongs to
  <span class='big'>{{ displayname }}</span>.
  <!-- all of your profile links are available in the profilelinks variable -->
  {{#profilelinks}}
    <a href='{{ url }}'>{{ title }}</a>.
  {{/profilelinks}}
</p>
</body>
</html>
END
    return profile
  end

  def render_profile(aka, profile_source=nil)
    profile_source = profile_source || aka.profile.profile_source || default_profile

    displayname = aka.display_or_subdomain_name
    profilelinks = aka.profile_links.map { |link| { url: link.href, title: link.title } }
    headertags = "<link rel='openid2.provider openid.server' href='https://#{Myaka::Application.config.myaka_domain}/openid' />"
    unless aka.tent_server.blank?
      headertags += "<link rel='https://tent.io/rels/profile' href='#{ aka.tent_server.sub(/\/$/,'') }/profile'/>"
    end
    
    begin
      return Mustache.render(profile_source, displayname: displayname, headertags: headertags, profilelinks: profilelinks)
    rescue
      return Mustache.render(default_profile) + '<p><b>There was an error rendering the template.</b></p>'
    end
  end

  def get_subdomain openid
    return openid.sub(/https?\:\/\//,'').sub(/\.#{Regexp.quote(Myaka::Application.config.aka_domain)}\.?\/?$/,'')
  end

end
