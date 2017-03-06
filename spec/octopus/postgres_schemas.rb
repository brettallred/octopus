require 'spec_helper'

describe "Octopus::PostgresSchemas" do
  describe '#using_schema' do
    it 'should allow to pass a string as the schema name to a block' do 
        Octopus.using_schema('schema_1') do
          User.create!(:name => 'Block test')
        end

        x = nil

        Octopus.using_schema('schema_1') do
          x = User.find_by(:name => 'Block test')
        end

        expect(x).not_to be_nil
    end
  end
end
