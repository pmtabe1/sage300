class Rack::Attack
  class Request < ::Rack::Request
    def remote_ip
      @remote_ip ||= (env['HTTP_X_FORWARDED_FOR'] || ip).to_s
    end
  end
end

# Throttle high volumes of requests by IP address
Rack::Attack.throttle('req/ip', limit: 20, period: 20.seconds) do |req|
  req.remote_ip unless req.path.starts_with?('/assets')
end

# Allowed despite matching any number of blocklists or throttles
Rack::Attack.safelist('allow from valid ips') do |req|
  VALID_IP_ADDRESSES.include? req.remote_ip
end

VALID_IP_ADDRESSES = 
  [
    'IP_ARRAY'
  ]

#Rack::Attack.throttle('req/ip', limit: 300, period: 2) do |req|
#  req.remote_ip if ['/assets', '/check'].any? {|path| req.path.starts_with? path }
#end

#Rack::Attack.blacklist('block very bad actors') do |req|
#  ['10.0.0.1', '192.168.1.30'].include? req.remote_ip
#end

#require 'resolv'
#Rack::Attack.blacklist('googlebots who are not googlebots') do |req|
#  if req.user_agent =~ /Googlebot/i
#
#    begin
#      name = Resolv.getname(req.remote_ip.to_s)
#      reversed_ip = Resolv.getaddress(name)
#
#      resolves_correctly = name.end_with?("googlebot.com") || name.end_with?("google.com")
#      reverse_resolves = reversed_ip == req.remote_ip.to_s
#
#      is_google = resolves_correctly && reverse_resolves
#
#
#      !is_google
#    rescue Resolv::ResolvError
#      true
#    end
#
#  end
#end
