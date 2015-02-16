require "spec_helper"

Unrecognized = Class.new(StandardError)
Parent = Class.new(StandardError)
Child = Class.new(Parent)

class TestController < ApplicationController
  map_error Child, to: :unprocessable_entity, type: :first, message: "first"
  map_error Parent, to: :unprocessable_entity, type: :second, message: "second"

  def unrecognized_exception
    raise Unrecognized
  end

  def record_not_found
    raise ActiveRecord::RecordNotFound
  end

  def record_invalid
    User.create!
  end

  def overridden
    raise Child
  end
end

describe "Errors" do
  before do
    Rails.application.routes.draw do
      get "/unrecognized_exception"  => "test#unrecognized_exception"
      get "/record_not_found"  => "test#record_not_found"
      get "/record_invalid"  => "test#record_invalid"
      get "/overridden"  => "test#overridden"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  context "when there is an unrecognized exception" do
    it "responds with a server_error" do
      j_get("/unrecognized_exception")

      expect_status(500)
      expect_type("server_error")
      expect_message("Something went wrong")
    end
  end

  context "when a record is not found" do
    it "responds with a record_not_found" do
      j_get("/record_not_found")

      expect_status(404)
      expect_type("record_not_found")
      expect_message("No such record")
    end
  end

  context "when an attribute is not valid" do
    it "responds with a record_invalid" do
      j_get("/record_invalid")

      expect_status(422)
      expect_type("record_invalid")
      expect_message("Name can't be blank")
    end
  end

  context "when an error is mapped twice" do
    it "responds with the last mapping" do
      j_get("/overridden")

      expect_status(422)
      expect_type("second")
      expect_message("second")
    end
  end
end
