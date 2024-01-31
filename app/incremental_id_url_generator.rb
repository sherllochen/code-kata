# frozen_string_literal: true
require_relative './url_generator'

class IncrementalIdUrlGenerator < UrlGenerator
  URL_PREFIX = 'https://jsonplaceholder.typicode.com/todos/'

  # @param [integer] amount the amount of TODOs to request
  # @param [integer] last_id the last id of previous generated urls
  def initialize(amount, last_id)
    @amount = amount
    @last_id = last_id
  end

  def generate
    urls = []
    @amount.times do
      @last_id += 2
      urls << "#{URL_PREFIX}#{@last_id}"
    end

    { urls: urls, last_id: @last_id }
  end
end