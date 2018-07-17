require 'spec_helper'
require './commit_details'

describe CommitDetails do
  let(:line) { " 3 files changed, 16 insertions(+), 9 deletions(-)\nb9243ebb8 MOB-4021 Changed Next To Apply on RefundReasonCode Modal (#3087) (Trevor Pries, 7 months ago)" }
  subject { CommitDetails.new(commit: line) }

  context 'when line is invalid' do
    let(:line) { '194fe03c7 MOB-4053 Bill Pay Receipt Missing From Email (#3089) (Emad Hilo, 7 months ago)' }

    it 'should be invalid when first line does not include file changed' do
      expect(subject).to be_invalid
    end
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
