#!/usr/bin/env ruby

require 'fileutils'
require 'net/sftp'
require 'clamp'

class ShoulderSurfer < Clamp::Command
  option "--quiet", :flag, "Quite mode - no output"
  
  parameter "LOCAL_DIR", "Local screenshots directory"
  parameter "REMOTE", "Remote host and location - user@host:directory"

  def remote=(remote)
    @remote_user, @remote_host = (@remote_host, @remote_dir = remote.split(":")).first.split("@")
  end

  def execute
    trans_dir = local_dir+"/t"
    if !File.directory?(trans_dir)
      Dir.mkdir(trans_dir)      
    end

    Dir.chdir(local_dir)

    images = Dir.glob('*.{jpg,png,gif}', File::FNM_CASEFOLD)

    images.each do |file|
      file_loc = "#{trans_dir}/#{file}"

      begin 
        Net::SFTP.start(@remote_host, @remote_user) do |sftp|
          print "Starting transfer - #{file}..." if not quiet?
          sftp.upload!(file, "#{@remote_dir}/#{file}")
        end
        puts 'Done' if not quiet?

        # Move files that have been transferred
        # In the future we'll probably just make an index and check for
        # new files?
        FileUtils.mv(file, "#{trans_dir}/#{file}")
      rescue Net::SFTP::Exception
        puts 'Could not connect to remote host'
      end
    end
  end
end

ShoulderSurfer.run
