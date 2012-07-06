require "rtrace/version"
require 'socket'
require 'rubygems'
require 'geocoder'
require 'timeout'


byebye = proc {
  puts "\x8\x8"+"Canceled. "
  exit(0)
}

trap('INT', byebye)

module Rtrace


  class << self
  end

  def self.trace(options)
    @options = options
    port = 33434

    @send_socket = Socket.new(:INET, :DGRAM)
    @dest_addr   = Socket.sockaddr_in(port, options[:host])
    @dest_ip     = IPSocket::getaddress(options[:host])
    puts "Traceroute for \"#{options[:host]}\" ( #{@dest_ip} ) ..."
    puts

    begin
      @recv_socket = Socket.new( Socket::PF_INET, Socket::SOCK_RAW, Socket::IPPROTO_ICMP)
    rescue Errno::EPERM => e
      puts "Sorry, you need to be root. Raw packets and all. Let me know if there's a better way."
      exit(1)
    end
    @recv_addr = Socket.sockaddr_in(port, "")
    @recv_socket.bind(@recv_addr)

    self.run_loop
  end

  def self.run_loop
    ttl = @options[:first_ttl]
    while true do
      break if ttl>@options[:max_ttl]
      @send_socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [ttl].pack('i'))
      t1 = Time.now
      @send_socket.send("", 0, @dest_addr)

      data = []
      begin
        timeout(@options[:timeout]) do
          data = @recv_socket.recvfrom( 512 )[1]
        end
      rescue Timeout::Error
        puts ttl.to_s.ljust(5)+"*"
        ttl += 1
        next
      end

      time = ((Time.now - t1)*1000).round 1
      time = time.to_s+" ms"
      ip   = data.ip_address
      loc  = Geocoder.search(ip).first

      if loc.city.empty?
        place = ""
      else
        place = "#{loc.city}, #{loc.state}"
      end

      begin
        name = Socket.getaddrinfo(ip, 0, Socket::AF_UNSPEC, Socket::SOCK_STREAM, nil, Socket::AI_CANONNAME, true)[0][2]
      rescue
        name = ""
      end

      s_ttl = ttl.to_s.ljust(5)
      name  = name.ljust(45)
      s_ip  = ip.ljust(20)
      time  = time.ljust(15)
      place = place.ljust(25)

      puts s_ttl+name+s_ip+time+place

      ttl += 1
      break if @dest_ip==ip
    end
    
  end
end
