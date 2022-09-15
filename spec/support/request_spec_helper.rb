# frozen_string_literal: true

module RequestSpecHelper
  def rendered_json
    JSON.parse(response.body)
  end

  def stub_json_request(url, method = :get, params = {}, body = {})
    stub_request(method, url).with(
      body: params.to_json,
      headers: { 'Content-Type' => 'application/json' }
    ).to_return(body: body.to_json)
  end
end
