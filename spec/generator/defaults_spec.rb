require_relative '../spec_helper.rb'

RSpec.describe Jekyll::PaginateV2::Generator::DEFAULT do
  subject { described_class }

  context "checking default config" do
    it "should always contain the following keys" do
      expect(subject).to include 'enabled'
      expect(subject).to include 'collection'
      expect(subject).to include 'per_page'
      expect(subject).to include 'permalink'
      expect(subject).to include 'title'
      expect(subject).to include 'page_num'
      expect(subject).to include 'sort_reverse'
      expect(subject).to include 'sort_field'
      expect(subject).to include 'limit'
      expect(subject).to include 'debug'
      expect(subject.size).to be >= 10
    end

    it "should always contain the following key defaults" do
      expect(subject['enabled']).to eq false
      expect(subject['collection']).to eq 'posts'
      expect(subject['per_page']).to eq 10
      expect(subject['permalink']).to eq '/page:num/'
      expect(subject['title']).to eq ':title - page :num'
      expect(subject['page_num']).to eq 1
      expect(subject['sort_reverse']).to eq false
      expect(subject['sort_field']).to eq 'date'
      expect(subject['limit']).to eq 0
      expect(subject['debug']).to eq false
    end
  end
end