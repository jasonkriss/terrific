module RequestHelper
  def json
    @json ||= JSON.parse(response.body, symbolize_names: true)
  end

  def expect_status(status)
    expect(response.status).to eq(status)
  end

  def expect_type(type)
    expect(json[:error][:type]).to eq(type)
  end

  def expect_message(message)
    expect(json[:error][:message]).to eq(message)
  end

  def j_get(path, params = nil, headers = {})
    json_request(:get, path, params, headers)
  end

  def json_request(method, path, params = nil, headers = {})
    send(method, path, params, headers.merge({
      "CONTENT_TYPE" => "application/json"
    }))
  end
end
