require 'sinatra/base'
 
module Sinatra
  module JavaScripts
      def js *scripts
        @js ||= []
        @js = scripts
      end
 
      def javascripts(*args)
        js = []
        js << settings.javascripts if settings.respond_to?('javascripts')
        js << args
        js << @js if @js
        js.flatten.uniq.map do |script| 
          "<script src=\"#{path_to_js script}\" type=\"text/javascript\"></script>"
        end.join
      end
 
      def path_to_js script
        case script
          when :jquery then 'http://code.jquery.com/jquery-2.1.0.min.js'
          else "javascript/" + script.to_s + '.js'
        end
      end
  end
 
  module StyleSheets
    def css *files
      @css ||= []
      @css = files
    end
 
    def styles(*args)
      css = []
      css << settings.css if settings.respond_to?('css')
      css << args
      css << @css if @css
      css.flatten.uniq.map do |stylesheet| 
        "<link href=\"/#{path_to_css stylesheet}\" rel=\"stylesheet\" type=\"text/css\" />"
      end.join
    end

    def path_to_css stylesheet
      "css/" + stylesheet.to_s + '.css'
    end
  end
 
  helpers JavaScripts, StyleSheets
end