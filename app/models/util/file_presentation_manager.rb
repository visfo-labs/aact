require 'action_view'
require 'open-uri'
include ActionView::Helpers::NumberHelper
module Util
  class FilePresentationManager

    def self.monthly_snapshot_files
      files_in('static_db_copies','monthly')
    end

    def self.daily_snapshot_files
      files_in('static_db_copies','daily')
    end

    def self.monthly_flat_files
      files_in('exported_files','monthly')
    end

    def self.daily_flat_files
      files_in('exported_files','daily')
    end

    def self.admin_schema_diagram
      "/static/documentation/aact_admin_schema.png"
    end

    def self.schema_diagram
      "/static/documentation/aact_schema.png"
    end

    def self.data_dictionary
      "/static/documentation/aact_data_definitions.xlsx"
    end

    def self.table_dictionary
      "/static/documentation/aact_tables.xlsx"
    end

    def self.files_in(dir, type)
      new.files_in(dir, type)
    end

    def files_in(sub_dir, type)
      # type ('monthly' or 'daily') identify the subdirectory to use to get the files.
      entries=[]
      dir="/static/#{sub_dir}/#{type}"
      file_names=Dir.entries(dir) - ['.','..']
      file_names.each {|file_name|
        begin
          file_url="#{dir}/#{file_name}"
          size=File.open(file_url).size
          date_string=file_name.split('_').first
          date_created=(date_string.size==8 ? Date.parse(date_string).strftime("%m/%d/%Y") : nil)
          entries << {:name=>file_name,:date_created=>date_created,:size=>number_to_human_size(size), :url=>file_url}
        rescue => e
          # just skip if unexpected file encountered
          puts e
        end
      }
      entries.sort_by {|entry| entry[:name]}.reverse!
    end

  end
end
