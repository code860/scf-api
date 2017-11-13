module RequestHelpers
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
end
