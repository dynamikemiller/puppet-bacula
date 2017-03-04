module Puppet::Parser::Functions
  newfunction(:address_family, type: :rvalue) do |args|
    address_string = args[0]

    require 'ipaddr'

    begin
      addr = IPAddr.new(address_string)
    rescue
      return false
    end

    return 'INET' if addr.ipv4?
    return 'INET6' if addr.ipv6?
    return false
  end
end
