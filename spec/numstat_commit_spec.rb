require 'spec_helper'
require './numstat_commit'

describe NumstatCommit do
  let(:commit) { '194fe03c7 MOB-4053 Bill Pay Receipt Missing From Email (#3089) (Emad Hilo, 7 months ago)' }
  let(:changes) do
    [
      "53\t11\tRQMobile/Code/Sales/EmailPrintReceiptViewController.m",
      "1\t0\tRQMobile/Code/Services/RQAPI/RQAPIInvoiceService.h",
      "13\t0\tRQMobile/Code/Services/RQAPI/RQAPIInvoiceService.m",
      "1300\t0\tRQMobile/somefilenotallowed.pdf",
      "1500\t0\tRQMobile/somefilenotallowed.jpg"
    ]
  end

  subject {
    NumstatCommit.new(
      commit: commit,
      changes: changes
    )
  }

  it 'should calculate the insertions' do
    expect(subject.insertions).to eq 67
  end

  it 'should calculate the deletions' do
    expect(subject.deletions).to eq 11
  end
end
