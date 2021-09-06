# -*- mode: ruby -*-
# vi: set ft=ruby :

class Registry
  def to_s
    puts <<-CHOICES
    Choose a Container Registry Server:
    1) Docker (docker.io)
    2) GitHub (ghcr.io)
    3) Quay   (quay.io)
    4) Other registry
    5) Skip
    0) Quit
    CHOICES
    print "Enter selection [0-5]: "
    choice = STDIN.gets.chomp

    case choice
    when "0"
      quit_selection
    when "1"
      registry_docker
    when "2"
      registry_github
    when "3"
      registry_quay
    when "4"
      registry_other
    when "5"
      skip_selection
    else
      try_again
    end
  end

  def try_again
    puts "\nInvalid input.\n\n"
    to_s
  end

  def quit_selection
    puts "\nBye!\nDon't forget to destroy the Guest VM..."
    exit
  end

  def skip_selection
    puts "Selection skipped...\n"
    @@reg_name = nil.to_s
  end

  def registry_docker
    puts "Selected registry: Docker"
    @@reg_name = "https://index.docker.io/v1/"
  end

  def registry_github
    puts "Selected registry: GitHub"
    @@reg_name = "ghcr.io"
  end

  def registry_quay
    puts "Selected registry: Quay"
    @@reg_name = "quay.io"
  end

  def registry_other
    print "Please specify a valid Docker registry: "
    @@reg_name = STDIN.gets.chomp
  end

  def server
    @@reg_name
  end
end

class Username
  def to_s
    r = Registry.new
    server = r.server
    if server != nil.to_s
      puts "\nVirtual machine needs your credentials for the container registry #{server}"
      print "Username: "
      user = STDIN.gets.chomp
    else
      user = nil.to_s
    end
  end
end

class Password
  def to_s
    r = Registry.new
    server = r.server
    if server != nil.to_s
      begin
        system 'stty -echo'
        print "Password: "
        pass = URI.escape(STDIN.gets.chomp)
      ensure
        system 'stty echo'
      end
      pass
    else
      pass = nil.to_s
    end
  end
end
