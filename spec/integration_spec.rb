require_relative '../app/main'

describe 'Integration Tests' do
  # This test triggers the real request to the target urls.
  it 'output the result' do
    expect do
      system('bin/entry')
    end.to output(/TITLE: .+, COMPLETED: (true|false)/).to_stdout_from_any_process
  end
end
