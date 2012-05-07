require 'uri'
require 'digest/sha1'

def enc(string)
  return string.gsub(/%20/,'+').gsub(/[+\/@]/,'+' => '%2B', '/' => '%2F', '@' => '%4O')
end

def get_auth_sig(url, app_secret)
  params = {}
  URI.parse(url).query.split('&').each do |part|
    if name = part.split('=')[0] and val = part.split('=')[1]
      params[name] = val
    else
      params[name] = ''
    end
  end

  canonical = ''
  params.sort.each do |key,val|
    canonical += key + '=' + enc(val.encode('utf-8')) + '&'
  end

  #this removes the trailing &
  canonical = canonical[0,canonical.size-1]

  string_to_sign = enc(canonical) + app_secret
  return Digest::SHA1.hexdigest(string_to_sign)
end