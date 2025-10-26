# frozen_string_literal: true

RSpec.describe Hanami::Http::Status do
  subject(:status) { described_class }

  describe ".for_code" do
    it "accepts an Integer status code" do
      expect(status.for_code(200)).to eq([200, "OK"])
      expect(status.for_code(301)).to eq([301, "Moved Permanently"])
      expect(status.for_code(401)).to eq([401, "Unauthorized"])
      expect(status.for_code(404)).to eq([404, "Not Found"])
      expect(status.for_code(500)).to eq([500, "Internal Server Error"])
    end

    it "accepts a symbolic status code" do
      expect(status.for_code(:ok)).to eq([200, "OK"])
      expect(status.for_code(:moved_permanently)).to eq([301, "Moved Permanently"])
      expect(status.for_code(:unauthorized)).to eq([401, "Unauthorized"])
      expect(status.for_code(:not_found)).to eq([404, "Not Found"])
      expect(status.for_code(:internal_server_error)).to eq([500, "Internal Server Error"])
    end

    it "raises UnknownHttpStatusError for unknown status codes" do
      expect {
        status.for_code(999)
      }.to raise_error(Hanami::Action::UnknownHttpStatusError)

      expect {
        status.for_code(:foo)
      }.to raise_error(Hanami::Action::UnknownHttpStatusError)
    end
  end

  describe ".lookup" do
    it "accepts an Integer status code" do
      expect(status.lookup(200)).to eq(200)
      expect(status.lookup(301)).to eq(301)
      expect(status.lookup(401)).to eq(401)
      expect(status.lookup(404)).to eq(404)
      expect(status.lookup(500)).to eq(500)
    end

    it "accepts a symbolic status code" do
      expect(status.lookup(:ok)).to eq(200)
      expect(status.lookup(:moved_permanently)).to eq(301)
      expect(status.lookup(:unauthorized)).to eq(401)
      expect(status.lookup(:not_found)).to eq(404)
      expect(status.lookup(:internal_server_error)).to eq(500)
    end

    it "raises UnknownHttpStatusError for unknown status codes" do
      expect {
        status.lookup(999)
      }.to raise_error(Hanami::Action::UnknownHttpStatusError)

      expect {
        status.lookup(:foo)
      }.to raise_error(Hanami::Action::UnknownHttpStatusError)
    end
  end

  describe ".message_for" do
    it "accepts an Integer status code" do
      expect(status.message_for(200)).to eq("OK")
      expect(status.message_for(301)).to eq("Moved Permanently")
      expect(status.message_for(401)).to eq("Unauthorized")
      expect(status.message_for(404)).to eq("Not Found")
      expect(status.message_for(500)).to eq("Internal Server Error")
    end

    it "accepts a symbolic status code" do
      expect(status.message_for(:ok)).to eq("OK")
      expect(status.message_for(:moved_permanently)).to eq("Moved Permanently")
      expect(status.message_for(:unauthorized)).to eq("Unauthorized")
      expect(status.message_for(:not_found)).to eq("Not Found")
      expect(status.message_for(:internal_server_error)).to eq("Internal Server Error")
    end

    it "raises UnknownHttpStatusError for unknown status codes" do
      expect {
        status.message_for(999)
      }.to raise_error(Hanami::Action::UnknownHttpStatusError)

      expect {
        status.message_for(:foo)
      }.to raise_error(Hanami::Action::UnknownHttpStatusError)
    end
  end

  context "Rack 2", rack: "< 3" do
    it "handles the 422 rename gracefully" do
      expect(status.for_code(:unprocessable_content)).to eq([422, "Unprocessable Entity"])
      expect(status.lookup(:unprocessable_content)).to eq(422)
      expect(status.message_for(:unprocessable_content)).to eq("Unprocessable Entity")
    end
  end

  context "Rack 3", rack: ">= 3" do
    it "handles the 422 rename gracefully" do
      expect(status.for_code(:unprocessable_entity)).to eq([422, "Unprocessable Content"])
      expect(status.lookup(:unprocessable_entity)).to eq(422)
      expect(status.message_for(:unprocessable_entity)).to eq("Unprocessable Content")
    end
  end
end
