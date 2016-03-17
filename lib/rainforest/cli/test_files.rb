# frozen_string_literal: true
class RainforestCli::TestFiles
  DEFAULT_TEST_FOLDER = './spec/rainforest'
  FILE_EXTENSION = '.rfml'

  attr_reader :test_folder, :test_data

  def initialize(test_folder = nil)
    if test_folder.nil?
      RainforestCli.logger.info "No test folder supplied. Using default folder: #{DEFAULT_TEST_FOLDER}"
      @test_folder = File.expand_path(DEFAULT_TEST_FOLDER)
    else
      @test_folder = File.expand_path(test_folder)
    end
  end

  def test_paths
    "#{@test_folder}/**/*#{FILE_EXTENSION}"
  end

  def test_data
    if @test_data.nil?
      @test_data = []
      if Dir.exist?(@test_folder)
        Dir.glob(test_paths) do |file_name|
          @test_data << RainforestCli::TestParser::Parser.new(file_name).process
        end
      end
    end
    @test_data
  end

  def file_extension
    FILE_EXTENSION
  end

  def rfml_ids
    test_data.map(&:rfml_id)
  end

  def count
    test_data.count
  end

  def test_dictionary
    {}.tap do |dictionary|
      test_data.each { |rfml_test| dictionary[rfml_test.rfml_id] = rfml_test }
    end
  end
end