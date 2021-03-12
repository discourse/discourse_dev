# frozen_string_literal: true

DiscourseDev::Engine.routes.draw do
  get ':username_or_email/become' => 'admin/impersonate#create', constraints: AdminConstraint.new
end
