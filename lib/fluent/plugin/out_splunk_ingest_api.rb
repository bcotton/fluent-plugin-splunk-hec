require 'fluent/plugin/out_splunk_hec'
require 'openid_connect'
require 'rack/oauth2'
require 'multi_json'

module Fluent::Plugin
  class SplunkIngestApiOutput < SplunkHecOutput
    Fluent::Plugin.register_output('splunk_ingest_api', self)

    def prepare_event_payload(tag, time, record)
      log.error "**************************************************************************************"
      log.error "prepare_event_payload in child"
      log.error "**************************************************************************************"

      payload = super(record, tag, time)

      payload.delete(:index)
      payload.delete(:time)
      payload[:attributes] = payload.delete(:fields)
      payload[:body] = payload.delete(:event)
      payload[:timestamp] = (time.to_f * 1000).to_i

      payload
    end

    def new_connection
      client = OpenIDConnect::Client.new(
          token_endpoint: '/system/identity/v1/token',
          identifier: '0oa35r6aff03CLuBY2p7',
          secret: '',
          redirect_uri: 'http://localhost:8080/',
          host: 'api.staging.splunkbeta.com',
          scheme: 'https'
      )

      client.access_token!(client_auth_method: 'other')
    end

    def write(chunk)
      body = chunk.read
      log.error "**************************************************************************************"
      log.error "writing our way"
      log.error body
      log.error "**************************************************************************************"
      response = @hec_conn.post('https://api.staging.splunkbeta.com/pwnyfood/ingest/v1beta2/events', body: body)
      process_response(response)
    end
  end
end