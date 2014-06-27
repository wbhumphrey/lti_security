module LtiSecurityEngine
  class LtiLaunchesController < ApplicationController

    def create
      unless params[:launch_params] && security_contract = SecurityContract.where(key: params[:launch_params][:oauth_consumer_key]).first
        return render json: {error: 'Invalid consumer key'}, status: 400
      end

      tp = IMS::LTI::ToolProvider.new(security_contract.key, security_contract.shared_secret, params[:launch_params])
      request_params = {
          'method' => 'POST',
          'uri' => params[:launch_url],
          'parameters' => params[:launch_params]
      }

      if !tp.valid_request?(request_params)
        return render json: {error: 'Invalid signature'}, status: 400
      end

      if Time.now.utc.to_i > tp.request_oauth_timestamp.to_i + 60*5
        return render json: {error: 'Message has expired'}, status: 400
      end

      if security_contract.lti_launches.where(nonce: tp.request_oauth_nonce).count > 0
        return render json: {error: 'Message has been used'}, status: 400
      end

      security_contract.lti_launches.where("created_at < ?", 1.day.ago).destroy_all

      lti_launch = security_contract.lti_launches.create(
          nonce: tp.request_oauth_nonce,
          launch_params: tp.to_params
      )

      render json: {lti_launches: [lti_launch]}
    end

    def show
      request_proxy = OAuth::RequestProxy.proxy(request)
      vendor = Vendor.where(code: request_proxy.parameters["oauth_consumer_key"]).first
      unless vendor && OAuth::Signature.build(request_proxy, :consumer_secret => vendor.shared_secret).verify()
        return render json: {error: 'unauthorized'}, status: 401
      end

      if params[:id].start_with? "nonce:"
        nonce = params[:id].sub('nonce:', '').strip
        lti_launch = LtiLaunch.where(nonce: nonce).first
      else
        lti_launch = LtiLaunch.where(id: params[:id]).first
      end

      if lti_launch
        render json: {lti_launches: [lti_launch]}
      else
        render json: {error: 'Not found'}, status: 404
      end
    end

  end
end
