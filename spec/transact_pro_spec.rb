RSpec.describe TransactPro do
  it "has a version number" do
    expect(TransactPro::VERSION).not_to be nil
  end

  describe ".root" do
    it "returns a Pathname to root of gem" do
      # this spec may fail if you cloned the gem to a custom dir
      expect(TransactPro.root.to_s).to match(%r".*/transact_pro\z")
    end
  end
end
