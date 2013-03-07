module Sunspot
  module Rails
    module SolrInstrumentation
      extend ActiveSupport::Concern

      included do
        alias_method_chain :execute, :as_instrumentation
      end


      def execute_with_as_instrumentation(client, request_context)
        data = {
          :method => request_context[:method].upcase
          :uri => request_context[:uri]
        }
        if request_context[:method] == :post and request_context[:data]
          data[:uri] << "&#{Rack::Utils.unescape(request_context[:data])}"
        end
        ActiveSupport::Notifications.instrument("request.rsolr", data) do
          execute_without_as_instrumentation(client, request_context)
        end
      end
    end
  end
end
