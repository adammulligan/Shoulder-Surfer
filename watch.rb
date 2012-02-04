#!/usr/bin/env ruby

require 'fileutils'
require 'net/sftp'
require 'clamp'

class ShoulderSurfer < Clamp::Command
  option ["-d", "--shots_dir"], "d", "screenshots directory", :default => Dir.getwd
  option ["-r", "--remote"], "user@host", "Remote user and host"
  option ["-D", "--remote_dir"], "D", "Remote directory"

  def execute
    trans_dir = shots_dir+"/t"
    if !File.directory?(trans_dir)
      Dir.mkdir(trans_dir)      
    end

    remote_det = remote.split("@")
    remote_user = remote_det[0]
    remote_addr = remote_det[1]

    Dir.chdir(shots_dir)

    images = Dir.glob('*.{jpg,png,gif}', File::FNM_CASEFOLD)

    images.each do |file|
      file_loc = "#{trans_dir}/#{file}"

      begin 
        Net::SFTP.start(remote_addr, remote_user) do |sftp|
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
  end
end

ShoulderSurfer.run
