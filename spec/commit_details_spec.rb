require 'spec_helper'
require './commit_details'

describe CommitDetails do
  let(:meta_data) { '3 files changed, 16 insertions(+), 9 deletions(-)' }
  let(:commits) { ['b9243ebb8 MOB-4021 Changed Next To Apply on RefundReasonCode Modal (#3087) (Trevor Pries, 7 months ago)'] }
  subject { CommitDetails.new(meta_data: meta_data, commits: commits) }

  it 'should extract the sha' do
    expect(subject.sha).to eq 'b9243ebb8'
  end

  it 'should extract the insertions' do
    expect(subject.insertions).to eq '16'
  end

  it 'should extract the deletions' do
    expect(subject.deletions).to eq '9'
  end

  it 'should calculate the delta' do
    expect(subject.delta).to eq 7
  end
end
