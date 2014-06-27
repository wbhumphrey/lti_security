require 'rails_helper'

module LtiSecurityEngine
  describe LtiLaunchesController do
    describe "#create" do
      before(:each) do
        @security_contract = SecurityContract.create!(key: 'key', shared_secret: 'secret')
      end

      let(:tc) {
        tc = IMS::LTI::ToolConsumer.new(@security_contract.key, @security_contract.shared_secret)
        tc.resource_link_id = '123'
        tc.launch_url = 'https://example.com'
        tc
      }

      it "returns an error if the key doesn't exist" do
        post :create

        expect(response.code).to eq "400"
        expect(JSON.parse(response.body)['error']).to eq "Invalid consumer key"
      end

      it "returns an error if the key doesn't exist" do
        post :create, launch_params: {oauth_consumer_key: 'key'}

        expect(response.code).to eq "400"
        expect(JSON.parse(response.body)['error']).to eq "Invalid signature"
      end

      it "returns an error if the message timestamp is too old" do
        tc.timestamp = 3.days.ago
        post :create, launch_url: tc.launch_url, launch_params: tc.generate_launch_data

        expect(response.code).to eq "400"
        expect(JSON.parse(response.body)['error']).to eq "Message has expired"
      end

      it "returns an error if the nonce has been used before" do
        launch_data = tc.generate_launch_data
        post :create, launch_url: tc.launch_url, launch_params: launch_data
        post :create, launch_url: tc.launch_url, launch_params: launch_data

        expect(response.code).to eq "400"
        expect(JSON.parse(response.body)['error']).to eq "Message has been used"
      end

      it "returns an lti launch object if the request validates" do
        post :create, launch_url: tc.launch_url, launch_params: tc.generate_launch_data
        lti_launches = JSON.parse(response.body)['lti_launches']
        lti_launch_json = lti_launches.first
        lti_launch = LtiLaunch.where(id: lti_launch_json['id']).first

        expect(response.code).to eq "200"
        expect(lti_launches.size).to eq 1
        expect(lti_launch_json['id']).to eq lti_launch.id
        expect(lti_launch_json['nonce']).to eq lti_launch.nonce
      end

      it "cleans up requests that are older then 1 day" do
        old_launch = @security_contract.lti_launches.create!({nonce: "old_launch"})
        old_launch.created_at = 2.days.ago
        old_launch.save!

        post :create, launch_url: tc.launch_url, launch_params: tc.generate_launch_data

        expect(@security_contract.lti_launches.where(nonce: "old_launch").size).to eq 0
      end
    end

    describe "#show", type: :request do

      before(:each) do
        @vendor = Vendor.create!(code: 'my_vendor', shared_secret: 'auth_secret')
        @security_contract = @vendor.security_contracts.create!(key: 'key', shared_secret: 'secret')

        @lti_launch = @security_contract.lti_launches.create!(
            nonce: 'nonce',
            launch_params: {'launch' => 'params'}
        )
      end

      it "requires authentication" do
        get "/lti_security_engine/lti_launches/#{@lti_launch.id}"

        expect(response.code).to eq "401"
      end

      it "returns a saved lti launch by id" do
        get signed_path(@vendor.code, @vendor.shared_secret, "/lti_security_engine/lti_launches/#{@lti_launch.id}")
        lti_launches = JSON.parse(response.body)['lti_launches']
        lti_launch_json = lti_launches.first

        expect(response.code).to eq "200"
        expect(lti_launches.size).to eq 1
        expect(lti_launch_json['id']).to eq @lti_launch.id
        expect(lti_launch_json['nonce']).to eq @lti_launch.nonce
        expect(lti_launch_json['launch_params']).to eq @lti_launch.launch_params
      end

      it "returns a saved lti launch by nonce" do
        get signed_path(@vendor.code, @vendor.shared_secret, "/lti_security_engine/lti_launches/nonce:#{@lti_launch.nonce}")
        lti_launches = JSON.parse(response.body)['lti_launches']
        lti_launch_json = lti_launches.first

        expect(response.code).to eq "200"
        expect(lti_launches.size).to eq 1
        expect(lti_launch_json['id']).to eq @lti_launch.id
        expect(lti_launch_json['nonce']).to eq @lti_launch.nonce
        expect(lti_launch_json['launch_params']).to eq @lti_launch.launch_params
      end

      it "returns a 404 when the launch is not found" do
        get signed_path(@vendor.code, @vendor.shared_secret, "/lti_security_engine/lti_launches/fake")

        expect(response.code).to eq "404"
      end
    end
  end
end