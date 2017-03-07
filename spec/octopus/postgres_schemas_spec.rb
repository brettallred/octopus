require 'spec_helper'

context "postgres schema support" do

  describe 'Octopus#using_schema' do
    it 'should allow to pass a string as the schema name to a block' do 
      OctopusHelper.using_environment(:postgres_schemas) do
        Octopus.using_schema('schema_1') do
          User.create!(:name => 'Block test')
        end

        Octopus.using_schema('schema_1') do
          user = User.find_by(:name => 'Block test')
          expect(user).not_to be_nil
        end
      end
    end
  end

  describe "configuring postgres schemas support" do
    it 'should allow you to map schemas to shards' do
      OctopusHelper.using_environment(:postgres_schemas) do
        proxy = Octopus::Proxy.new
        expect(proxy.postgres_schema_names).to eq(['schema_1', 'schema_2'])
      end
    end

    it 'should allow you to set the default schema path' do
      OctopusHelper.using_environment(:postgres_schemas) do
        proxy = Octopus::Proxy.new
        expect(proxy.default_postgres_schema).to eq('random, "$user", public')
      end
    end

    it 'should allow you to set persistent schemas' do
      OctopusHelper.using_environment(:postgres_schemas) do
        proxy = Octopus::Proxy.new
        expect(proxy.persistent_postgres_schemas).to eq('persistant_schema')
      end
    end
  end
end
