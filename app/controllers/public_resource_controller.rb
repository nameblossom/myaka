class PublicResourceController < ActionController::Base
  include AkasHelper

  def show
    response.headers['Access-Control-Allow-Origin'] = '*'    
    subdomain = nil
    if request.headers['Host'] != Myaka::Application.config.backend_domain
      subdomain = request.headers['Host'].sub(/\.#{Regexp.escape(Myaka::Application.config.aka_domain)}\Z/,'')
    else
      subdomain = params[:subdomain]
    end
    aka = Aka.find_by_subdomain subdomain
    raise ActionController::RoutingError.new("Not found (no aka #{subdomain})") unless aka
    resource = aka.public_resources.find_by_path ('/'+(params[:path] || ''))
    raise ActionController::RoutingError.new("Not found (no path #{params[:path]})") unless resource
    response.headers['ETag'] = resource.etag
    if resource.headers
      resource.headers.split("\n").each do |line|
        response.headers[line.slice(0,line.index(':'))] = line.slice(line.index(':')+1,line.length)
      end
    end
    send_data resource.content, type: resource.content_type, disposition: :inline
  end

end
