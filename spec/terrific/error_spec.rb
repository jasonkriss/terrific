require 'spec_helper'

describe Terrific::Error do
  let(:exception) { Exception.new }

  describe "#as_json" do
    let(:error) { Terrific::Error.new(exception) }

    before do
      expect(error).to receive(:message) { "message" }
      expect(error).to receive(:type) { "type" }
    end

    it "returns message and type" do
      expect(error.as_json).to eq({
        type: "type",
        message: "message"
      })
    end
  end

  describe "#message" do
    context "when it is explictly provided" do
      let(:error) { Terrific::Error.new(exception, message: "explicit message") }

      it "is the value specified" do
        expect(error.message).to eq("explicit message")
      end
    end

    context "when it is provided as lambda" do
      let(:lambda) { ->(e) { "lambda message" } }
      let(:error) { Terrific::Error.new(exception, message: lambda) }

      it "is the result of the lambda" do
        expect(error.message).to eq("lambda message")
      end
    end

    context "when it is not provided" do
      context "but a translation is available" do
        let(:error) { Terrific::Error.new(Exception.new("message")) }

        it "is the translated message" do
          expect(error.message).to eq("translated message")
        end
      end

      context "and there is no translation available" do
        let(:error) { Terrific::Error.new(StandardError.new("message")) }

        it "is the exception message" do
          expect(error.message).to eq("message")
        end
      end
    end
  end

  describe "#type" do
    context "when it is explictly provided" do
      let(:error) { Terrific::Error.new(exception, type: "explicit") }

      it "is the value specified" do
        expect(error.type).to eq("explicit")
      end
    end

    context "when it is provided as lambda" do
      let(:lambda) { ->(e) { "lambda" } }
      let(:error) { Terrific::Error.new(exception, type: lambda) }

      it "is the result of the lambda" do
        expect(error.type).to eq("lambda")
      end
    end

    context "when it is not provided" do
      let(:error) { Terrific::Error.new(exception) }

      it "is uses the default" do
        expect(error.type).to eq("exception")
      end
    end
  end
end
