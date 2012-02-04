#!/usr/bin/env ruby

require 'fileutils'
require 'net/sftp'

shots_dir = "#{ENV["HOME"]}/inbox/_screenshots"
trans_dir = shots_dir+"/t"

remote_dir = "<remote dir>"

Dir.chdir(shots_dir)

images = Dir.glob('*.jpg')

images.each do |file|
  file_loc = "#{trans_dir}/#{file}"

  begin 
    Net::SFTP.start('cyanoryx.com', 'adam') do |sftp|
      sftp.upload!(file, "#{remote_dir}/#{file}")
    end

    # Move files that have been transferred
    # In the future we'll probably just make an index and check for
    # new files?
    FileUtils.mv(file, "#{trans_dir}/#{file}")
  rescue Net::SFTP::Exception
    puts 'error'
  end
end
