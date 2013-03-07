module Sunspot
  module Rails
    module SolrInstrumentation
      extend ActiveSupport::Concern

      included do
        alias_method_chain :build_request, :as_instrumentation
      end


      def build_request_with_as_instrumentation(path, opts)
        parameters = (opts[:params] || {})
        parameters.merge!(opts[:data]) if opts[:data].is_a? Hash
        payload = {:path => path, :parameters => parameters}
        ActiveSupport::Notifications.instrument("request.rsolr", payload) do
          build_request_without_as_instrumentation(path, opts)
        end
      end
    end
  end
end
