require_relative '../../app/main'  # make sure to replace '...' with the actual file path

RSpec.describe CodeKata::Main, '.run' do
  let(:urls) { %w[https://jsonplaceholder.typicode.com/todos/2
                  https://jsonplaceholder.typicode.com/todos/4
                  https://jsonplaceholder.typicode.com/todos/6
                  https://jsonplaceholder.typicode.com/todos/8
                  https://jsonplaceholder.typicode.com/todos/10] }

  let(:json_response) do
    { 'userId' => 1, 'id' => 2, 'title' => 'quis ut nam facilis et officia qui', 'completed' => false }.to_json
  end

  before do
    # Stubbing the HTTP requests and returning a predetermined JSON response.
    stub_request(:get, /jsonplaceholder.typicode.com/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: json_response, headers: {})
  end

  context 'when running the application' do
    it 'sends the correct HTTP requests and outputs the responses as formatted strings' do
      expected_output = urls.map { |url| "TITLE: quis ut nam facilis et officia qui, COMPLETED: false" }

      expect do
        CodeKata::Main.run
      end.to output(a_string_including(*expected_output)).to_stdout
    end
  end
end