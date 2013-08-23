module MCollective
  module Agent
    # An agent to manage the Puppet configuration file 

    class Configfile<RPC::Agent

      require 'puppet/util/ini_file'
      require 'puppet'

      def startup_hook
      end

      action "status" do
        separator = '='
        file_path = request[:file]
        @ini_file ||= ::Puppet::Util::IniFile.new(file_path, separator)
        section = request[:section] || ""
        reply["value"] = @ini_file.get_value(section, request[:setting]) || "unset"
      end

      action "edit" do
        separator = '='
        file_path = request[:file]
        @ini_file ||= ::Puppet::Util::IniFile.new(file_path, separator)
        section = request[:section] || ""
        value = @ini_file.get_value(section, request[:setting])
        if value == nil or value != request[:value]
          begin
            @ini_file.set_value(section, request[:setting], request[:value])
            @ini_file.save
            reply["status"] = 'success'
          rescue => e
            reply["status"] = "failure #{e.message}"
          end
        else
          reply["status"] = 'no change'
        end
      end

      private

    end
  end
end

# vi:tabstop=2:expandtab:ai:filetype=ruby
