require 'spec_helper'

describe Encipher::Cli::Base do
  let(:key_path) { 'keypath' }
  let(:config) { double(key_path: 'keypath') }
  
  context do
    before :each do
      allow(subject).to receive(:config) { config }
    end

    describe '.environment' do
      let(:environment) { double }

      it 'memoizes the environment object' do
        subject.instance_variable_set(:@environment, environment)
        expect(Encipher::Environment).to_not receive(:new)
        expect(subject.send(:environment)).to be environment
      end

      it 'creates a new environment object if not set' do
        expect(Encipher::Environment).to receive(:new).with(key_path) { environment }
        expect(subject.send(:environment)).to be(environment)
      end
    end

    describe '.vault' do
      let(:vault) { double }

      it 'memoizes the vault object' do
        subject.instance_variable_set(:@vault, vault)
        expect(Encipher::Vault).to_not receive(:new)
        expect(subject.send(:vault)).to be vault
      end

      it 'creates a new vault object if not set' do
        expect(Encipher::Vault).to receive(:new).with(key_path) { vault }
        expect(subject.send(:vault)).to be(vault)
      end
    end
  end

  describe '.config' do
    let (:yaml_hash) { double }
    let (:config) { double }

    before :each do
      allow(OpenStruct).to receive(:new) { config }
      allow(YAML).to receive(:load) { yaml_hash }
      allow(File).to receive(:read)
      allow(File).to receive(:exist?) { true }
    end

    it 'memoizes the config object' do
      subject.instance_variable_set(:@config, config)
      expect(OpenStruct).to_not receive(:new)
      expect(subject.send(:config)).to be config
    end

    it 'loads the config from yaml' do
      expect(YAML).to receive(:load)
      subject.send(:config)
    end

    it 'creates a new config object if not set' do
      expect(OpenStruct).to receive(:new).with(yaml_hash) { config }
      expect(subject.send(:config)).to be(config)
    end
  end
end